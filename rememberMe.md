Backend note:
when user logout or login reset otp count in the database

Frontend note:
local storage and some code throw error do our app catch uncatched errors this about this. example branch catch throw error when we catch branch locally if fail it throws what happen though


update backend address controller 
chnage update address by below
 async updateDeliveryAddress(req, res) {
        const requestId = req.body?.meta?.request_id;
        try {
            const userId = req.user.id;
            const { addressId } = req.params;
            const {
              subcity,
              street,
              building,
              houseNo,
              note,
              lat,
              lng,
            } = req.validatedData;
            const deliveryAddress = await AddressService.updateDeliveryAddress({
              id: addressId,
              userId,
              subcity,
              street,
              building,
              houseNo,
              note,
              lat,
              lng,
            });
            return sendSuccess(res, deliveryAddress, requestId);
        } catch (error) {
            logger.error(error, "Failed to update delivery address");
            throw error;
        }
    },



    review feature 
    change response format in controller like
    return sendSuccess(res, reviews, requestId);

because there are some small change replace review by new code from this laptop

    update review controller to below
    import { Router } from "express";
import { authMiddleware } from "../middlewares/authMiddleware.mjs";
import { reviewController } from "../controllers/review/reviewController.mjs";
import { validateRequestMiddleware } from "../middlewares/validateRequestMiddleware.mjs";
import { validateReviewInput } from "../utils/validators/reviewValidators.mjs";

const router = Router();

//create review
router.post("/create-review", 
    authMiddleware,
    validateRequestMiddleware(validateReviewInput),
    reviewController.createReview
);


//update review
router.put("/update-review/:reviewId", 
    authMiddleware,
    validateRequestMiddleware(validateReviewInput),
    reviewController.updateReview
);

//delete review
router.delete("/delete-review/:reviewId", 
    authMiddleware,
    reviewController.deleteReview
);

//get all reviews for a product
router.get("/get-all-reviews/:productId", 
    reviewController.getAllReviews
);


//get average rating for a product
router.get("/get-average-rating/:productId", 
    authMiddleware,
    reviewController.getAverageRating
);

//get comment count for a product
router.get("/get-comment-count/:productId", 
    authMiddleware,
    reviewController.getCommentCount
);



export default router;



if possible simplify the response of verify promocode endpoint to be the same as get promo codes ask web team




order feature

update  get orders endpoint inside 

service

 static async getOrders(userId, conn) {
    try {
      const orders = await Order.getOrders(userId, conn);
      return { orders };
    } catch (error) {
      throw error;
    }
  }

  to 

   static async getOrders(userId, conn) {
    try {
      const orders = await Order.getOrders(userId, conn);
      return  orders ;
    } catch (error) {
      throw error;
    }
  }

  inside controller

   return sendSuccess(res, { orders }, requestId);

   to 

    return sendSuccess(res, orders , requestId);




    change product.mjs by below

    import { getDB } from "../../config/db/db.mjs";
import { dbSchema } from "../../config/db/dbSchema.mjs";

export class Product {
  //tables
  static productTable = dbSchema.products.table;
  static reviewsTable = dbSchema.reviews.table;
  static imagesTable = dbSchema.product_images.table;
  static ingredientsTable = dbSchema.product_ingredients.table;
  static branchProductTable = dbSchema.branch_products.table;
  static branchStockTable = dbSchema.branch_stock.table;

  //columns
  static productColumns = dbSchema.products;
  static reviewColumns = dbSchema.reviews;
  static imageColumns = dbSchema.product_images;
  static ingredientColumns = dbSchema.product_ingredients;
  static branchProductColumns = dbSchema.branch_products;
  static branchStockColumns = dbSchema.branch_stock;

  constructor({
    [dbSchema.products.id]: id,
    [dbSchema.products.name]: name,
    [dbSchema.products.description]: description,
    [dbSchema.products.price]: price,
    [dbSchema.products.discount]: discount,
    [dbSchema.products.variants]: variants,
    [dbSchema.products.nutrition]: nutrition,
    [dbSchema.products.categoryId]: categoryId,
    [dbSchema.products.subCategoryId]: subCategoryId,
    [dbSchema.products.vatRate]: vatRate,
    [dbSchema.products.minimumThreshold]: minimumThreshold,
    [dbSchema.products.createdAt]: createdAt,
    [dbSchema.products.updatedAt]: updatedAt,
    imageUrls = [],
    ingredients = [],
    branchId,
    quantity,
    averageRating = 0,
    reviewCount = 0,
  }) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
    this.discount = discount;
    this.variants = variants;
    this.nutrition = nutrition;
    this.categoryId = categoryId;
    this.subCategoryId = subCategoryId;
    this.vatRate = vatRate;
    this.minimumThreshold = minimumThreshold;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.imageUrls = imageUrls;
    this.ingredients = ingredients;
    this.branchId = branchId;
    this.quantity = quantity;
    this.averageRating = averageRating;
    this.reviewCount = reviewCount;
  }

  static async getAllBranchProducts({ branchId }, conn) {
    const db = conn || getDB();
    const [rows] = await db.query(
      `
    SELECT 
      p.${this.productColumns.id},
      p.${this.productColumns.name},
      p.${this.productColumns.description},
      p.${this.productColumns.price},
      p.${this.productColumns.discount},
      p.${this.productColumns.variants},
      p.${this.productColumns.nutrition},
      p.${this.productColumns.categoryId},
      p.${this.productColumns.subCategoryId},
      p.${this.productColumns.vatRate},
      p.${this.productColumns.minimumThreshold},
      p.${this.productColumns.createdAt},
      p.${this.productColumns.updatedAt},
      GROUP_CONCAT(DISTINCT CONCAT(pi.${this.imageColumns.url}, ':', pi.${this.imageColumns.isMain}) SEPARATOR ',') AS imageUrls,
      GROUP_CONCAT(DISTINCT ping.${this.ingredientColumns.name} SEPARATOR ',') AS ingredients,
      bs.${this.branchStockColumns.branchId} AS branchId,
      bs.${this.branchStockColumns.quantity} AS quantity,
      COALESCE(r.averageRating, 0) AS averageRating,
      COALESCE(r.reviewCount, 0) AS reviewCount
    FROM ${this.productTable} p
    INNER JOIN ${this.branchProductTable} bp
      ON p.${this.productColumns.id} = bp.${this.branchProductColumns.productId}
    LEFT JOIN ${this.branchStockTable} bs
      ON p.${this.productColumns.id} = bs.${this.branchStockColumns.productId}
      AND bp.${this.branchProductColumns.branchId} = bs.${this.branchStockColumns.branchId}
    LEFT JOIN ${this.imagesTable} pi
      ON p.${this.productColumns.id} = pi.${this.imageColumns.productId}
    LEFT JOIN ${this.ingredientsTable} ping
      ON p.${this.productColumns.id} = ping.${this.ingredientColumns.productId}
    LEFT JOIN (
      SELECT 
        ${this.reviewColumns.productId},
        AVG(${this.reviewColumns.rating}) AS averageRating,
        COUNT(*) AS reviewCount
      FROM ${this.reviewsTable}
      GROUP BY ${this.reviewColumns.productId}
    ) r ON p.${this.productColumns.id} = r.${this.reviewColumns.productId}
    WHERE bp.${this.branchProductColumns.branchId} = ?
      AND bp.${this.branchProductColumns.isActive} = TRUE
    GROUP BY p.${this.productColumns.id}
    ORDER BY p.${this.productColumns.name} ASC
    `,
      [branchId]
    );

    return rows.map(
      (row) =>
        new Product({
          ...row,
          imageUrls: row.imageUrls
            ? row.imageUrls.split(",").map((item) => {
                // Split from the right to handle URLs with colons (e.g., https://)
                // Works for both absolute URLs (https://...) and relative URLs (/uploads/...)
                const lastColonIndex = item.lastIndexOf(":");
                if (lastColonIndex === -1) {
                  // Fallback: if no colon found, treat entire string as URL
                  return { url: item, is_main: false };
                }
                const url = item.substring(0, lastColonIndex);
                const is_main = item.substring(lastColonIndex + 1);
                return { url, is_main: is_main === "1" };
              })
            : [],
          ingredients: row.ingredients ? row.ingredients.split(",") : [],
          branchId: row.branchId,
          quantity: row.quantity,
          averageRating: row.averageRating,
          reviewCount: row.reviewCount,
        })
    );
  }

  // Get all products in a specific category in a branch
  static async getAllCategoryProducts({ branchId, categoryId }, conn) {
    const db = conn || getDB();
    const [rows] = await db.query(
      `
      SELECT 
        p.${this.productColumns.id},
        p.${this.productColumns.name},
        p.${this.productColumns.description},
        p.${this.productColumns.price},
        p.${this.productColumns.discount},
        p.${this.productColumns.variants},
        p.${this.productColumns.nutrition},
        p.${this.productColumns.categoryId},
        p.${this.productColumns.subCategoryId},
        p.${this.productColumns.vatRate},
        p.${this.productColumns.minimumThreshold},
        p.${this.productColumns.createdAt},
        p.${this.productColumns.updatedAt},
        GROUP_CONCAT(DISTINCT CONCAT(pi.${this.imageColumns.url}, ':', pi.${this.imageColumns.isMain}) SEPARATOR ',') AS imageUrls,
        GROUP_CONCAT(DISTINCT ping.${this.ingredientColumns.name} SEPARATOR ',') AS ingredients,
        bs.${this.branchStockColumns.branchId} AS branchId,
        bs.${this.branchStockColumns.quantity} AS quantity,
        COALESCE(r.averageRating, 0) AS averageRating,
        COALESCE(r.reviewCount, 0) AS reviewCount
      FROM ${this.productTable} p
      INNER JOIN ${this.branchProductTable} bp
        ON p.${this.productColumns.id} = bp.${this.branchProductColumns.productId}
      LEFT JOIN ${this.branchStockTable} bs
        ON p.${this.productColumns.id} = bs.${this.branchStockColumns.productId}
        AND bp.${this.branchProductColumns.branchId} = bs.${this.branchStockColumns.branchId}
      LEFT JOIN ${this.imagesTable} pi
        ON p.${this.productColumns.id} = pi.${this.imageColumns.productId}
      LEFT JOIN ${this.ingredientsTable} ping
        ON p.${this.productColumns.id} = ping.${this.ingredientColumns.productId}
      LEFT JOIN (
        SELECT 
          ${this.reviewColumns.productId},
          AVG(${this.reviewColumns.rating}) AS averageRating,
          COUNT(*) AS reviewCount
        FROM ${this.reviewsTable}
        GROUP BY ${this.reviewColumns.productId}
      ) r ON p.${this.productColumns.id} = r.${this.reviewColumns.productId}
      WHERE bp.${this.branchProductColumns.branchId} = ?
        AND p.${this.productColumns.categoryId} = ?
        AND bp.${this.branchProductColumns.isActive} = TRUE
      GROUP BY p.${this.productColumns.id}
      ORDER BY p.${this.productColumns.name} ASC
      `,
      [branchId, categoryId]
    );

    return rows.map(
      (row) =>
        new Product({
          ...row,
          imageUrls: row.imageUrls
            ? row.imageUrls.split(",").map((item) => {
                // Split from the right to handle URLs with colons (e.g., https://)
                // Works for both absolute URLs (https://...) and relative URLs (/uploads/...)
                const lastColonIndex = item.lastIndexOf(":");
                if (lastColonIndex === -1) {
                  // Fallback: if no colon found, treat entire string as URL
                  return { url: item, is_main: false };
                }
                const url = item.substring(0, lastColonIndex);
                const is_main = item.substring(lastColonIndex + 1);
                return { url, is_main: is_main === "1" };
              })
            : [],
          ingredients: row.ingredients ? row.ingredients.split(",") : [],
          branchId: row.branchId,
          quantity: row.quantity,
          averageRating: row.averageRating,
          reviewCount: row.reviewCount,
        })
    );
  }

  // Get all products in a specific sub-category in a branch
  static async getAllSubCategoryProducts({ branchId, subCategoryId }, conn) {
    const db = conn || getDB();
    const [rows] = await db.query(
      `
      SELECT 
        p.${this.productColumns.id},
        p.${this.productColumns.name},
        p.${this.productColumns.description},
        p.${this.productColumns.price},
        p.${this.productColumns.discount},
        p.${this.productColumns.variants},
        p.${this.productColumns.nutrition},
        p.${this.productColumns.categoryId},
        p.${this.productColumns.subCategoryId},
        p.${this.productColumns.vatRate},
        p.${this.productColumns.minimumThreshold},
        p.${this.productColumns.createdAt},
        p.${this.productColumns.updatedAt},
        GROUP_CONCAT(DISTINCT CONCAT(pi.${this.imageColumns.url}, ':', pi.${this.imageColumns.isMain}) SEPARATOR ',') AS imageUrls,
        GROUP_CONCAT(DISTINCT ping.${this.ingredientColumns.name} SEPARATOR ',') AS ingredients,
        bs.${this.branchStockColumns.branchId} AS branchId,
        bs.${this.branchStockColumns.quantity} AS quantity,
        COALESCE(r.averageRating, 0) AS averageRating,
        COALESCE(r.reviewCount, 0) AS reviewCount
      FROM ${this.productTable} p
      INNER JOIN ${this.branchProductTable} bp
        ON p.${this.productColumns.id} = bp.${this.branchProductColumns.productId}
      LEFT JOIN ${this.branchStockTable} bs
        ON p.${this.productColumns.id} = bs.${this.branchStockColumns.productId}
        AND bp.${this.branchProductColumns.branchId} = bs.${this.branchStockColumns.branchId}
      LEFT JOIN ${this.imagesTable} pi
        ON p.${this.productColumns.id} = pi.${this.imageColumns.productId}
      LEFT JOIN ${this.ingredientsTable} ping
        ON p.${this.productColumns.id} = ping.${this.ingredientColumns.productId}
      LEFT JOIN (
        SELECT 
          ${this.reviewColumns.productId},
          AVG(${this.reviewColumns.rating}) AS averageRating,
          COUNT(*) AS reviewCount
        FROM ${this.reviewsTable}
        GROUP BY ${this.reviewColumns.productId}
      ) r ON p.${this.productColumns.id} = r.${this.reviewColumns.productId}
      WHERE bp.${this.branchProductColumns.branchId} = ?
        AND p.${this.productColumns.subCategoryId} = ?
        AND bp.${this.branchProductColumns.isActive} = TRUE
      GROUP BY p.${this.productColumns.id}
      ORDER BY p.${this.productColumns.name} ASC
      `,
      [branchId, subCategoryId]
    );

    return rows.map(
      (row) =>
        new Product({
          ...row,
          imageUrls: row.imageUrls
            ? row.imageUrls.split(",").map((item) => {
                // Split from the right to handle URLs with colons (e.g., https://)
                // Works for both absolute URLs (https://...) and relative URLs (/uploads/...)
                const lastColonIndex = item.lastIndexOf(":");
                if (lastColonIndex === -1) {
                  // Fallback: if no colon found, treat entire string as URL
                  return { url: item, is_main: false };
                }
                const url = item.substring(0, lastColonIndex);
                const is_main = item.substring(lastColonIndex + 1);
                return { url, is_main: is_main === "1" };
              })
            : [],
          ingredients: row.ingredients ? row.ingredients.split(",") : [],
          branchId: row.branchId,
          quantity: row.quantity,
          averageRating: row.averageRating,
          reviewCount: row.reviewCount,
        })
    );
  }
  // Get product details by product ID and branch ID
  static async getProductById({ productId, branchId }, conn) {
    const db = conn || getDB();
    const [rows] = await db.query(
      `
      SELECT 
        p.${this.productColumns.id},
        p.${this.productColumns.name},
        p.${this.productColumns.description},
        p.${this.productColumns.price},
        p.${this.productColumns.discount},
        p.${this.productColumns.variants},
        p.${this.productColumns.nutrition},
        p.${this.productColumns.categoryId},
        p.${this.productColumns.subCategoryId},
        p.${this.productColumns.vatRate},
        p.${this.productColumns.minimumThreshold},
        p.${this.productColumns.createdAt},
        p.${this.productColumns.updatedAt},
        GROUP_CONCAT(DISTINCT CONCAT(pi.${this.imageColumns.url}, ':', pi.${this.imageColumns.isMain}) SEPARATOR ',') AS imageUrls,
        GROUP_CONCAT(DISTINCT ping.${this.ingredientColumns.name} SEPARATOR ',') AS ingredients,
        bs.${this.branchStockColumns.branchId} AS branchId,
        bs.${this.branchStockColumns.quantity} AS quantity,
        COALESCE(r.averageRating, 0) AS averageRating,
        COALESCE(r.reviewCount, 0) AS reviewCount
      FROM ${this.productTable} p
      INNER JOIN ${this.branchProductTable} bp
        ON p.${this.productColumns.id} = bp.${this.branchProductColumns.productId}
      LEFT JOIN ${this.branchStockTable} bs
        ON p.${this.productColumns.id} = bs.${this.branchStockColumns.productId}
        AND bp.${this.branchProductColumns.branchId} = bs.${this.branchStockColumns.branchId}
      LEFT JOIN ${this.imagesTable} pi
        ON p.${this.productColumns.id} = pi.${this.imageColumns.productId}
      LEFT JOIN ${this.ingredientsTable} ping
        ON p.${this.productColumns.id} = ping.${this.ingredientColumns.productId}
      LEFT JOIN (
        SELECT 
          ${this.reviewColumns.productId},
          AVG(${this.reviewColumns.rating}) AS averageRating,
          COUNT(*) AS reviewCount
        FROM ${this.reviewsTable}
        GROUP BY ${this.reviewColumns.productId}
      ) r ON p.${this.productColumns.id} = r.${this.reviewColumns.productId}
      WHERE p.${this.productColumns.id} = ?
        AND bp.${this.branchProductColumns.branchId} = ?
        AND bp.${this.branchProductColumns.isActive} = TRUE
      GROUP BY p.${this.productColumns.id}
      `,
      [productId, branchId]
    );

    if (!rows.length) return null;
    const row = rows[0];
    return new Product({
      ...row,
      imageUrls: row.imageUrls
        ? row.imageUrls.split(",").map((item) => {
            // Split from the right to handle URLs with colons (e.g., https://)
            // Works for both absolute URLs (https://...) and relative URLs (/uploads/...)
            const lastColonIndex = item.lastIndexOf(":");
            if (lastColonIndex === -1) {
              // Fallback: if no colon found, treat entire string as URL
              return { url: item, is_main: false };
            }
            const url = item.substring(0, lastColonIndex);
            const is_main = item.substring(lastColonIndex + 1);
            return { url, is_main: is_main === "1" };
          })
        : [],
      ingredients: row.ingredients ? row.ingredients.split(",") : [],
      branchId: row.branchId,
      quantity: row.quantity,
      averageRating: row.averageRating,
      reviewCount: row.reviewCount,
    });
  }
}


#order
in the backend you should verify the fields that are very sensitive when user places order such as delivery fee, total, subtotal..etc.. backend should calculate and check with hhat user sent


#cart
user only should create max of 5 items in his cart with max of 5 quantity in each. do this also in the backend


update cart.mjs method such as getCart and getAllCarts


on the achievemnt table specify types as below
transfer in
transfer out
spend
reward
other



#endihm yichalal
Navigator.pop(context, address),