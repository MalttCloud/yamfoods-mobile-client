# Product Filters API Documentation

## Endpoint

```
GET /api/product/get-all-branch-products/{branchId}
```

## Query Parameters (All Optional)

| Parameter     | Type    | Description                                | Example                     |
| ------------- | ------- | ------------------------------------------ | --------------------------- |
| `search`      | string  | Search products by name (case-insensitive) | `search=pizza`              |
| `minPrice`    | number  | Minimum price filter                       | `minPrice=10`               |
| `maxPrice`    | number  | Maximum price filter                       | `maxPrice=50`               |
| `category`    | number  | Filter by single category ID               | `category=1`                |
| `subcategory` | number  | Filter by single subcategory ID            | `subcategory=4`             |
| `ingredients` | string  | Filter by ingredients (comma-separated)    | `ingredients=cheese,tomato` |
| `hasDiscount` | boolean | Filter products with discount > 0          | `hasDiscount=true`          |

## Usage Examples

### 1. Search Only

```
GET /api/product/get-all-branch-products/1?search=pizza
```

### 2. Price Range

```
GET /api/product/get-all-branch-products/1?minPrice=10&maxPrice=50
```

### 3. Category Filter

```
GET /api/product/get-all-branch-products/1?category=1
```

### 4. Subcategory Filter

```
GET /api/product/get-all-branch-products/1?subcategory=4
```

### 5. Discounted Products

```
GET /api/product/get-all-branch-products/1?hasDiscount=true
```

### 6. Combined Filters

```
GET /api/product/get-all-branch-products/1?search=pizza&minPrice=10&maxPrice=50&category=1&ingredients=cheese&hasDiscount=true
```

## Important Notes

- ✅ All filters are **optional** - use any combination
- ✅ `category` and `subcategory` accept **single values only** (not arrays)
- ✅ `ingredients` accepts **comma-separated values** (e.g., `cheese,tomato`)
- ✅ `hasDiscount` accepts `true`/`false` or `1`/`0`
- ✅ `minPrice` and `maxPrice` can be used together or separately
- ⚠️ If both `minPrice` and `maxPrice` are provided, `maxPrice` must be >= `minPrice`

## Response Format

```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": 1,
        "name": "Pizza",
        "price": 25.0,
        "discount": 5.0,
        "categoryId": 1,
        "subCategoryId": 4,
        "ingredients": ["cheese", "tomato"]
        // ... other product fields
      }
    ]
  }
}
```
