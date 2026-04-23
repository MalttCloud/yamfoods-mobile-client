  
  // Centralized order pricing configuration.
// Update values here when business rules change.

export const ORDER_PRICING = Object.freeze({
  // Delivery fee applied when orderType === "delivery"
  DELIVERY_FEE_ETB: 34.0,

  // Points conversion: 1 point = X ETB
  POINT_TO_ETB_RATE: 0.25,

  // Tolerance for client/server monetary comparisons to avoid float drift issues
  TOTALS_TOLERANCE_ETB: 2.0,
});


  
  // --- Authoritative server-side totals recomputation (never trust client totals) ---
    const carts = await Cart.getAllCarts({ branchId, userId }, conn);
    if (!carts?.length) {
      throw createHttpError(400, {
        code: ERROR_CODES.INVALID_INPUT,
        message: "Cart is empty",
      });
    }

    // Points validation (balance check) + conversion to ETB.
    const requestedPointUsed = Math.max(0, Math.trunc(Number(pointUsed) || 0));
    if (requestedPointUsed > 0) {
      const wallet = await AchievmentPoint.getUserTotalPoint(userId, conn);
      const available = Math.max(0, Math.trunc(Number(wallet?.point) || 0));
      if (requestedPointUsed > available) {
        throw createHttpError(400, {
          code: ERROR_CODES.USER_NOT_ENOUGH_POINTS,
          message: "Insufficient points to use",
        });
      }
    }

    // Base totals (promo = 0) used for promo min-order validation.
    // Match frontend behavior: orderAmount = checkoutSummary.subtotal (which already includes point discount if applied).
    const promoValidationTotals = computeOrderTotalsFromCarts({
      carts,
      orderType,
      promoCodeDiscount: 0,
      pointUsed: requestedPointUsed,
      deliveryFeeEtb: ORDER_PRICING.DELIVERY_FEE_ETB,
      pointToEtbRate: ORDER_PRICING.POINT_TO_ETB_RATE,
    });
    const orderAmountForPromoValidation = promoValidationTotals.subtotal;
    const discountedItemsTotal =
      promoValidationTotals.priceTotal - promoValidationTotals.itemDiscountTotal;

    // Promo discount: absolute ETB (validated from DB).
    let serverPromoCodeDiscount = 0.0;
    if (promoCode) {
      const promo = await PromocodeService.validatePromoCode(
        { code: promoCode, orderAmount: orderAmountForPromoValidation },
        conn
      );
      serverPromoCodeDiscount = Number(promo?.discount) || 0.0;
    }

    const serverTotals = computeOrderTotalsFromCarts({
      carts,
      orderType,
      promoCodeDiscount: serverPromoCodeDiscount,
      pointUsed: requestedPointUsed,
      deliveryFeeEtb: ORDER_PRICING.DELIVERY_FEE_ETB,
      pointToEtbRate: ORDER_PRICING.POINT_TO_ETB_RATE,
    });

    // Optional guard: prevent points from discounting beyond payable amount.
    const maxPointDiscount = Math.max(
      0,
      discountedItemsTotal - serverPromoCodeDiscount
    );
    if (serverTotals.pointDiscount > maxPointDiscount) {
      throw createHttpError(400, {
        code: ERROR_CODES.INVALID_INPUT,
        message: "Point used exceeds payable amount",
      });
    }

    const clientTotals = {
      quantity,
      subtotal,
      vatTotal,
      deliveryFee,
      pointUsed,
      pointDiscount,
      promoCodeDiscount,
      discountTotal,
      totalAmount,
    };

    const mismatches = diffOrderTotals({
      clientTotals,
      serverTotals,
      toleranceEtb: ORDER_PRICING.TOTALS_TOLERANCE_ETB,
    });

    if (Object.keys(mismatches).length > 0) {
      throw createHttpError(400, {
        code: ERROR_CODES.ORDER_TOTAL_MISMATCH,
        message: "Order calculation mismatch please contact support",
        details: {
          toleranceEtb: ORDER_PRICING.TOTALS_TOLERANCE_ETB,
          mismatches,
        },
      });
    }

    // Persist and pay using server totals (authoritative)
    const finalQuantity = serverTotals.quantity;
    const finalSubtotal = serverTotals.subtotal;
    const finalVatTotal = serverTotals.vatTotal;
    const finalDeliveryFee = serverTotals.deliveryFee;
    const finalPointUsed = serverTotals.pointUsed;
    const finalPointDiscount = serverTotals.pointDiscount;
    const finalPromoCodeDiscount = serverTotals.promoCodeDiscount;
    const finalDiscountTotal = serverTotals.discountTotal;
    const finalTotalAmount = serverTotals.totalAmount;

    const order = await this.createOrder(
      {
        userId,
        userPhone,
        branchId,
        orderType,
        scheduledAt,
        note,
        quantity: finalQuantity,
        subtotal: finalSubtotal,
        vatTotal: finalVatTotal,
        deliveryFee: finalDeliveryFee,
        pointUsed: finalPointUsed,
        pointDiscount: finalPointDiscount,
        promoCode,
        promoCodeDiscount: finalPromoCodeDiscount,
        discountTotal: finalDiscountTotal,
        totalAmount: finalTotalAmount,
        isCustom,
      },
      conn
    );


/**
 * Order totals calculator (server-side source of truth).
 *
 * Matches ORDER_TOTALS_CALCULATION_REFERENCE.md rules:
 * - Discount applied per product (fractional rate)
 * - VAT computed on discounted totals
 * - promoCodeDiscount is absolute ETB amount
 * - pointDiscount = pointUsed * pointToEtbRate
 * - deliveryFee is fixed for delivery orders
 */

function toNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

function normalizeFractionRate(rate) {
  // Defensive normalization: supports DB storing "0.15" or "15" for 15%.
  const r = toNumber(rate);
  if (r <= 0) return 0;
  if (r > 1 && r <= 100) return r / 100;
  return r;
}

export function computeOrderTotalsFromCarts({
  carts,
  orderType,
  promoCodeDiscount = 0,
  pointUsed = 0,
  deliveryFeeEtb,
  pointToEtbRate,
}) {
  const safeCarts = Array.isArray(carts) ? carts : [];

  let quantity = 0;
  let priceTotal = 0;
  let itemDiscountTotal = 0;
  let vatTotal = 0;

  for (const cart of safeCarts) {
    const q = Math.max(0, Math.trunc(toNumber(cart?.quantity)));
    quantity += q;

    const product = cart?.product || {};
    const originalPrice = toNumber(product.price);
    const discountRate = normalizeFractionRate(product.discount);
    const vatRate = normalizeFractionRate(product.vatRate);

    const discountedPrice =
      discountRate <= 0 ? originalPrice : originalPrice * (1 - discountRate);

    const lineOriginalTotal = originalPrice * q;
    const lineItemDiscount = (originalPrice - discountedPrice) * q;
    const lineDiscountedTotal = discountedPrice * q;
    const lineVat = lineDiscountedTotal * vatRate;

    priceTotal += lineOriginalTotal;
    itemDiscountTotal += lineItemDiscount;
    vatTotal += lineVat;
  }

  const promo = Math.max(0, toNumber(promoCodeDiscount));
  const usedPoints = Math.max(0, Math.trunc(toNumber(pointUsed)));
  const pointDiscount = usedPoints * toNumber(pointToEtbRate);

  const discountTotal = itemDiscountTotal + promo + pointDiscount;
  const deliveryFee =
    orderType === "delivery" ? toNumber(deliveryFeeEtb) : 0.0;

  const subtotal = priceTotal - discountTotal;
  const totalAmount = subtotal + vatTotal + deliveryFee;

  return {
    // Internal breakdown (useful for validation)
    priceTotal,
    itemDiscountTotal,

    // API-facing fields
    quantity,
    subtotal,
    vatTotal,
    deliveryFee,
    promoCodeDiscount: promo,
    pointUsed: usedPoints,
    pointDiscount,
    discountTotal,
    totalAmount,
  };
}

export function diffOrderTotals({ clientTotals, serverTotals, toleranceEtb }) {
  const tol = Math.max(0, toNumber(toleranceEtb));

  const intFields = ["quantity", "pointUsed"];
  const moneyFields = [
    "subtotal",
    "vatTotal",
    "deliveryFee",
    "promoCodeDiscount",
    "pointDiscount",
    "discountTotal",
    "totalAmount",
  ];

  const diffs = {};

  for (const field of intFields) {
    const c = Math.trunc(toNumber(clientTotals?.[field]));
    const s = Math.trunc(toNumber(serverTotals?.[field]));
    if (c !== s) {
      diffs[field] = { client: c, server: s, delta: c - s };
    }
  }

  for (const field of moneyFields) {
    const c = toNumber(clientTotals?.[field]);
    const s = toNumber(serverTotals?.[field]);
    const delta = c - s;
    if (Math.abs(delta) > tol) {
      diffs[field] = { client: c, server: s, delta };
    }
  }

  return diffs;
}

