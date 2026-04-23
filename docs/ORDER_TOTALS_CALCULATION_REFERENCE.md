# Order totals calculation (backend reference)

This document defines **how to recompute** `quantity, subtotal, vatTotal, deliveryFee, promoCodeDiscount, pointUsed, pointDiscount, discountTotal, totalAmount` on the backend using **authoritative DB data** (products + cart items + promo/points rules). The goal is **100% parity** with what the current client displays.

Backend rule: **never trust client totals**. Always recompute server-side. If you validate client-sent numbers, do it using a clear rounding/tolerance policy (see “Precision”).

---

## Inputs you need (from DB / services)

Per cart line (from DB):
- `productId`
- `quantity` (int)

Per product (from DB):
- `price` (number)
- `discountRate` (number, **fractional**: 0.20 = 20%)
- `vatRate` (number, **fractional**: 0.15 = 15%)

Order context:
- `orderType`: `"pickup"` or `"delivery"`

Promo (from promo validation on backend):
- `promoCodeDiscount` as an **absolute ETB amount** (number) for this cart/order (0 if none)

Points (from wallet/loyalty backend):
- `pointUsed` (int, optional)
- rule: **1 point = 0.25 ETB**

---

## Step 1: Product price after discount (per product)

Let:
- `originalPrice = price`
- `discountRate = discountRate` (fraction; if missing treat as 0)

Then:
- if `discountRate <= 0` → `discountedPrice = originalPrice`
- else → `discountedPrice = originalPrice * (1 - discountRate)`

---

## Step 2: Cart totals (derived from cart lines)

For each cart line:
- `q = quantity`
- `originalPrice` and `discountedPrice` from Step 1
- `vatRate` (fraction; if missing treat as 0)

Per-line:
- `lineOriginalTotal = originalPrice * q`
- `lineItemDiscount = (originalPrice - discountedPrice) * q`  (positive)
- `lineDiscountedTotal = discountedPrice * q`
- `lineVat = lineDiscountedTotal * vatRate` (**VAT is computed on discounted total**)

Accumulate over all lines:
- `priceTotal = Σ lineOriginalTotal`
- `itemDiscountTotal = Σ lineItemDiscount`
- `vatTotal = Σ lineVat`
- `quantity = Σ q`

---

## Step 3: Checkout totals (final)

Promo:
- `promoCodeDiscount` is an **absolute ETB amount** (0 if none)

Points:
- if `pointUsed` is `null` or `0` → `pointDiscount = 0`
- else `pointDiscount = pointUsed * 0.25`

Discount total:
- `discountTotal = itemDiscountTotal + promoCodeDiscount + pointDiscount`

Delivery fee:
- if `orderType == "delivery"` → `deliveryFee = 34.0`
- else → `deliveryFee = 0.0`

Final:
- `subtotal = priceTotal - discountTotal`
- `totalAmount = subtotal + vatTotal + deliveryFee`

---

## Worked example (cross-check)

Assume two cart lines:

1) Product A:
- `price = "1000"`, `discount = "0.20"`, `vatRate = "0.15"`, `quantity = 2`
- `originalPrice = 1000`
- `discountedPrice = 1000 * (1 - 0.20) = 800`
- `itemOriginalTotal = 1000 * 2 = 2000`
- `itemDiscount = (1000 - 800) * 2 = 400`
- `itemDiscountedTotal = 800 * 2 = 1600`
- `itemVat = 1600 * 0.15 = 240`

2) Product B:
- `price = "500"`, `discount = "0"`, `vatRate = "0.15"`, `quantity = 1`
- `originalPrice = 500`
- `discountedPrice = 500`
- `itemOriginalTotal = 500`
- `itemDiscount = 0`
- `itemDiscountedTotal = 500`
- `itemVat = 500 * 0.15 = 75`

Cart totals:
- `priceTotal = 2000 + 500 = 2500`
- `itemDiscountTotal = 400 + 0 = 400`
- `vatTotal = 240 + 75 = 315`

Checkout extras:
- `promoCodeDiscount = 50` (ETB absolute)
- `pointUsed = 100` → `pointDiscount = 100 * 0.25 = 25`
- `discountTotal = 400 + 50 + 25 = 475`
- `orderType = "delivery"` → `deliveryFee = 34`

Final:
- `subtotal = 2500 - 475 = 2025`
- `totalAmount = 2025 + 315 + 34 = 2374`
- `quantity = 2 + 1 = 3`

---

## Precision / rounding (critical for “small difference” failures)

Current client behavior:
- Uses floating point (`double`) without explicit rounding during accumulation.

Backend guidance (to avoid false mismatches):
- Prefer: **recompute and ignore client totals** (server totals are source of truth).
- If you still want to validate client totals, use one of these strategies:
  - **Tolerance check**: accept if absolute difference ≤ 0.01 (or the smallest currency unit you support).
  - **Single rounding policy** agreed by both sides (recommended long-term): round/quantize to 2 decimal places at the same step(s) on both frontend and backend, then compare.

---

## Validation recommendation (what to compare)

If backend wants to compare with client submission, compare these recomputed values:
- `quantity`
- `priceTotal` (optional internal)
- `itemDiscountTotal` (optional internal)
- `promoCodeDiscount`
- `pointUsed`, `pointDiscount`
- `discountTotal`
- `vatTotal`
- `deliveryFee`
- `subtotal`
- `totalAmount`

