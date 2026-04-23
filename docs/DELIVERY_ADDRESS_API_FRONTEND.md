# Delivery Address API – Request & Response Format (Frontend)

Base path: **`/api/address`** (or as mounted in your app).  
All endpoints require **authentication**.

**Breaking change:** The API now uses a single **`address`** field (required) instead of `subcity`, `street`, and `note`.  
Removed: `subcity`, `street`, `note`, `location`.  
Added: **`address`** (string, required, max 500 characters).

---

## Response envelope (all endpoints)

Success:

```json
{
  "runtimeType": "success",
  "success": true,
  "data": { ... },
  "meta": {
    "request_id": "uuid-v4-string",
    "timestamp": "2025-02-24T12:00:00.000Z"
  }
}
```

Error:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": null,
    "retry": null
  },
  "meta": {
    "request_id": "uuid-v4-string",
    "timestamp": "2025-02-24T12:00:00.000Z"
  }
}
```

---

## 1. Create delivery address

**`POST /api/address/create-address`**

### Request body

Send validated payload (can be under `data` or at root). Only these fields are accepted:

| Field      | Type   | Required | Constraints              | Description                    |
|-----------|--------|----------|---------------------------|--------------------------------|
| `address` | string | **Yes**  | Trimmed, max 500 chars    | Full delivery address text     |
| `building`| string | No       | Max 100 chars             | Building name/number; can be null/"" |
| `houseNo` | string | No       | Max 20 chars              | Default `"N/A"`                |
| `lat`     | number | **Yes**  | -90 ≤ value ≤ 90, 8 dp    | Latitude (WGS84)               |
| `lng`     | number | **Yes**  | -180 ≤ value ≤ 180, 8 dp  | Longitude (WGS84)              |

Example:

```json
{
  "data": {
    "address": "Bole Road, near Edna Mall, Addis Ababa",
    "building": "Tower A",
    "houseNo": "4B",
    "lat": 9.0180,
    "lng": 38.7525
  },
  "meta": {
    "request_id": "optional-uuid"
  }
}
```

Or without wrapper:

```json
{
  "address": "Bole Road, near Edna Mall, Addis Ababa",
  "building": "Tower A",
  "houseNo": "4B",
  "lat": 9.0180,
  "lng": 38.7525
}
```

### Response (success)

`data` is the created **Delivery address object**:

```json
{
  "runtimeType": "success",
  "success": true,
  "data": {
    "id": 1,
    "userId": 10,
    "address": "Bole Road, near Edna Mall, Addis Ababa",
    "building": "Tower A",
    "houseNo": "4B",
    "lat": 9.0180,
    "lng": 38.7525,
    "createdAt": "2025-02-24T12:00:00.000Z",
    "updatedAt": "2025-02-24T12:00:00.000Z"
  },
  "meta": {
    "request_id": "...",
    "timestamp": "2025-02-24T12:00:00.000Z"
  }
}
```

**Delivery address object (create/update/get):**

| Field       | Type   | Description                    |
|------------|--------|--------------------------------|
| `id`       | number | Delivery address ID            |
| `userId`   | number | Owner user ID                   |
| `address`  | string | Full address (required)         |
| `building` | string \| null | Building            |
| `houseNo`  | string | House/unit number (default N/A) |
| `lat`      | number | Latitude                        |
| `lng`      | number | Longitude                       |
| `createdAt`| string | ISO 8601                        |
| `updatedAt`| string | ISO 8601                        |

---

## 2. Update delivery address

**`PUT /api/address/update-address/:addressId`**

### Request

- **URL:** e.g. `PUT /api/address/update-address/5`
- **Body:** Same shape as create (same validation). Only `address`, `building`, `houseNo`, `lat`, `lng` are used.

Example:

```json
{
  "data": {
    "address": "Updated full address text",
    "building": null,
    "houseNo": "5A",
    "lat": 9.0200,
    "lng": 38.7600
  }
}
```

### Response (success)

`data` is the updated **Delivery address object** (same shape as in create response).

---

## 3. Get user delivery addresses

**`GET /api/address/get-address`**

### Request

- No body. Auth identifies the user.

### Response (success)

`data` is an **array** of **Delivery address objects** (same shape as above):

```json
{
  "runtimeType": "success",
  "success": true,
  "data": [
    {
      "id": 1,
      "userId": 10,
      "address": "Bole Road, near Edna Mall, Addis Ababa",
      "building": "Tower A",
      "houseNo": "4B",
      "lat": 9.0180,
      "lng": 38.7525,
      "createdAt": "2025-02-24T12:00:00.000Z",
      "updatedAt": "2025-02-24T12:00:00.000Z"
    },
    {
      "id": 2,
      "userId": 10,
      "address": "Kazanchis, behind Commercial Bank",
      "building": null,
      "houseNo": "N/A",
      "lat": 9.0250,
      "lng": 38.7580,
      "createdAt": "2025-02-24T11:00:00.000Z",
      "updatedAt": "2025-02-24T11:00:00.000Z"
    }
  ],
  "meta": {
    "request_id": "...",
    "timestamp": "2025-02-24T12:00:00.000Z"
  }
}
```

---

## 4. Delete delivery address

**`DELETE /api/address/delete-address/:addressId`**

### Request

- **URL:** e.g. `DELETE /api/address/delete-address/5`
- No body.

### Response (success)

```json
{
  "runtimeType": "success",
  "success": true,
  "data": {
    "message": "Delivery address deleted successfully"
  },
  "meta": {
    "request_id": "...",
    "timestamp": "2025-02-24T12:00:00.000Z"
  }
}
```
