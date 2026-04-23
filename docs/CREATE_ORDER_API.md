# Create Order API

**Endpoint:** `POST /order/create-order`  
**Base URL:** From `ApiUrls` (e.g. `http://<host>:3000/api`)  
**Auth:** Expects authenticated user (token in headers as per app).

---

## Request

### HTTP

- **Method:** `POST`
- **Path:** `/order/create-order`
- **Content-Type:** `application/json`

### Body structure

The client sends a **wrapped** payload: top-level `meta` and `data`. The actual order payload is inside `data`.

```json
{
  "meta": {
    "request_id": "uuid-v4-string",
    "client": "string",
    "version": "string"
  },
  "data": {
    "branchId": 1,
    "deliveryAddressId": 2,
    "orderType": "delivery",
    "scheduledAt": "2025-02-23 14:30:00",
    "method": "telebirr",
    "note": "Leave at door",
    "quantity": 3,
    "subtotal": 250.00,
    "vatTotal": 37.50,
    "deliveryFee": 30.00,
    "discountTotal": 0,
    "totalAmount": 317.50,
    "transactionFee": 7.94,
    "pointUsed": 0,
    "pointDiscount": 0,
    "promoCode": "SAVE10",
    "promoCodeDiscount": 25.00,
    "distanceKm": 2.5
  }
}
```

### Request fields (`data`)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `branchId` | number (int) | Yes | Branch ID. |
| `deliveryAddressId` | number (int) | Conditional | Required when `orderType` is `"delivery"`. |
| `orderType` | string | Yes | `"delivery"` or `"pickup"`. |
| `scheduledAt` | string | No | Scheduled time in `YYYY-MM-DD HH:mm:ss` (no `T`). Omit for ASAP. |
| `method` | string | Yes | Payment method (e.g. `"telebirr"`, `"chapa"`). |
| `note` | string | No | Order note. |
| `quantity` | number (int) | Yes | Total item quantity. |
| `subtotal` | number | Yes | Subtotal amount. |
| `vatTotal` | number | Yes* | VAT total. Sent only if > 0 in app. |
| `deliveryFee` | number | Yes | Delivery fee. |
| `discountTotal` | number | Yes* | Total discount. Sent only if > 0 in app. |
| `totalAmount` | number | Yes | Final total. |
| `transactionFee` | number | No | e.g. Chapa 2.5% fee when method is chapa. |
| `pointUsed` | number (int) | No | Loyalty points used. |
| `pointDiscount` | number | No | Discount from points. |
| `promoCode` | string | No | Applied promo code. |
| `promoCodeDiscount` | number | No | Discount from promo. |
| `distanceKm` | number | No | Distance from user to branch (km). |

\* App sends `vatTotal` and `discountTotal` only when > 0; backend may still expect them on payload depending on contract.

---

## Response

### Success (2xx)

Wrapper format:

```json
{
  "success": true,
  "data": {
    "receiveCode": "string-or-null",
    "order": { ... }
  },
  "meta": {
    "request_id": "string",
    "timestamp": "string"
  }
}
```

- **`receiveCode`**  
  - Present for some payment methods (e.g. Telebirr); used for payment flow.  
  - Can be `null` (e.g. Chapa does not use it in this app).

- **`order`**  
  Created order object (see below).

### Order object (`data.order`)

`branchLocation` and `deliveryLocation` **objects** are required (the client expects both to be present). For pickup orders, `deliveryLocation` may duplicate branch or use a placeholder. **Inside** each object, `lat` and `lng` are **optional**: they can be `null`, omitted, or numeric (number or string); the client parses them as nullable doubles.

```json
{
  "id": 123,
  "userId": 1,
  "userPhone": "+251912345678",
  "branchId": 1,
  "qrCode": "ABC123",
  "status": "pending",
  "type": "delivery",
  "delivererId": null,
  "delivererPhone": null,
  "scheduledAt": "2025-02-23T14:30:00.000Z",
  "note": "Leave at door",
  "quantity": 3,
  "subtotal": 250,
  "vatTotal": 37.5,
  "deliveryFee": 30,
  "pointUsed": null,
  "pointDiscount": null,
  "promoCode": null,
  "promoCodeDiscount": null,
  "discountTotal": null,
  "totalAmount": 317.5,
  "branchLocation": {
    "lat": 9.0320,
    "lng": 38.7469
  },
  "deliveryLocation": {
    "lat": 9.0350,
    "lng": 38.7500
  },
  "createdAt": "2025-02-23T12:00:00.000Z",
  "updatedAt": "2025-02-23T12:00:00.000Z"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id` | number (int) | Order ID. |
| `userId` | number (int) or null | User ID. |
| `userPhone` | string | Customer phone. |
| `branchId` | number (int) | Branch ID. |
| `qrCode` | string | Order QR code. |
| `status` | string | e.g. `"pending"`. |
| `type` | string | `"delivery"` or `"pickup"`. |
| `delivererId` | number (int) or null | Assigned deliverer ID. |
| `delivererPhone` | string or null | Deliverer phone. |
| `scheduledAt` | string (ISO 8601) or null | Scheduled time. |
| `note` | string or null | Order note. |
| `quantity` | number (int) | Total quantity. |
| `subtotal` | number | Subtotal. |
| `vatTotal` | number or null | VAT total. |
| `deliveryFee` | number | Delivery fee. |
| `pointUsed` | number (int) or null | Points used. |
| `pointDiscount` | number or null | Point discount. |
| `promoCode` | string or null | Promo code. |
| `promoCodeDiscount` | number or null | Promo discount. |
| `discountTotal` | number or null | Discount total. |
| `totalAmount` | number | Total amount. |
| `branchLocation` | object | **Required.** `{ "lat": number \| null, "lng": number \| null }`. Branch coordinates. `lat` and `lng` are optional (can be null or omitted); client accepts number or numeric string. |
| `deliveryLocation` | object | **Required.** Same shape as `branchLocation`. For pickup orders, backend may use branch coords or placeholder; `lat`/`lng` can be null. |
| `createdAt` | string (ISO 8601) | Created at. |
| `updatedAt` | string (ISO 8601) | Updated at. |

Numeric amounts may be returned as numbers or string numbers; the client parses them as numbers.

### Errors (4xx / 5xx)

- Backend returns non-2xx status and an error body (format may vary).
- Client treats non-2xx as failure and does not parse body as `Create Order` success format.

---

## Example (cURL)

```bash
curl -X POST "http://localhost:3000/api/order/create-order" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "meta": {
      "request_id": "550e8400-e29b-41d4-a716-446655440000",
      "client": "mobile",
      "version": "1.0.0"
    },
    "data": {
      "branchId": 1,
      "deliveryAddressId": 5,
      "orderType": "delivery",
      "method": "telebirr",
      "quantity": 2,
      "subtotal": 200,
      "vatTotal": 30,
      "deliveryFee": 25,
      "discountTotal": 0,
      "totalAmount": 255
    }
  }'
```

---

## Reference in codebase

- Route: `lib/core/network/api/api_routes.dart` → `ApiRoutes.createOrder` → `$_orderBase/create-order`
- Request body build: `lib/features/order/data/datasources/order_remote_data_source_impl.dart` (`createOrder`)
- Request wrapper: `lib/core/network/api/request_wrapper.dart` (`RequestWrapper.wrap`)
- Response model: `lib/features/order/data/models/create_order_response_model.dart`
- Order model: `lib/features/order/data/models/order_model.dart`
