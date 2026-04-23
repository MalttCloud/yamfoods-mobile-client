# Notification Service API Specification

## Overview
Backend service to manage Firebase Cloud Messaging (FCM) tokens for push notifications.

## Required NPM Packages

Install the following packages:

```bash
npm install firebase-admin
```

**Package Details:**
- **firebase-admin**: Official Firebase Admin SDK for Node.js
  - Version: `^12.0.0` or latest
  - Used for: Sending push notifications via FCM, managing tokens
  - Documentation: https://firebase.google.com/docs/admin/setup

**Setup Requirements:**
1. Download Firebase service account key JSON file from Firebase Console
2. Initialize Firebase Admin in your Node.js app:
   ```javascript
   const admin = require('firebase-admin');
   const serviceAccount = require('./path/to/serviceAccountKey.json');
   
   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });
   ```

## Base Path
```
/notification
```

## Endpoints

### 1. Save/Register Token
**POST** `/notification/save-token`

Saves or updates the user's FCM token. Should be called:
- After successful login
- After token refresh
- When app receives a new FCM token
- On app launch (if user is authenticated)

**Request Body:**
```json
{
  "token": "string (FCM token)",
  "deviceId": "string (optional, unique device identifier)",
  "platform": "string (ios/android)"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Token saved successfully"
  }
}
```

---

### 2. Update Token
**PUT** `/notification/update-token`

Updates an existing token (e.g., when token refreshes).

**Request Body:**
```json
{
  "oldToken": "string (previous FCM token)",
  "newToken": "string (new FCM token)",
  "deviceId": "string (optional)"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Token updated successfully"
  }
}
```

---

### 3. Clear/Delete Token
**DELETE** `/notification/clear-token`

Removes the user's FCM token. Should be called:
- On logout
- When user disables notifications
- When app is uninstalled (if possible)

**Request Body:**
```json
{
  "token": "string (FCM token to remove)",
  "deviceId": "string (optional)"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Token cleared successfully"
  }
}
```

---

### 4. Get User Tokens (Optional)
**GET** `/notification/get-tokens`

Retrieves all active tokens for the authenticated user (for admin/debugging purposes).

**Response:**
```json
{
  "success": true,
  "data": {
    "tokens": [
      {
        "token": "string",
        "deviceId": "string",
        "platform": "string",
        "createdAt": "datetime",
        "lastUpdated": "datetime"
      }
    ]
  }
}
```

---

## Authentication
All endpoints require authentication via Bearer token in the Authorization header:
```
Authorization: Bearer <access_token>
```

## Error Responses
Standard error format:
```json
{
  "success": false,
  "error": {
    "message": "Error description",
    "code": "ERROR_CODE"
  }
}
```

## Reusable Methods for Backend

### After Successful Operations
The backend should have reusable methods to send notifications after key events:

1. **Order Status Updates**
   - Order placed
   - Order confirmed
   - Order preparing
   - Order out for delivery
   - Order delivered
   - Order cancelled

2. **Authentication Events**
   - Account verification
   - Password reset confirmation

3. **Promotional Notifications**
   - New promo codes
   - Special offers
   - Achievement points updates

**Example Implementation:**
```javascript
const admin = require('firebase-admin');

// Send notification to a single token
async function sendNotificationToToken(token, title, body, data = {}) {
  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: data, // Custom data payload
    token: token, // FCM token
    android: {
      priority: 'high',
    },
    apns: {
      headers: {
        'apns-priority': '10',
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending message:', error);
    // Handle invalid/expired tokens
    if (error.code === 'messaging/invalid-registration-token' || 
        error.code === 'messaging/registration-token-not-registered') {
      // Remove invalid token from database
    }
    throw error;
  }
}

// Send notification to multiple tokens (batch)
async function sendNotificationToMultipleTokens(tokens, title, body, data = {}) {
  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: data,
    tokens: tokens, // Array of FCM tokens
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log(`Successfully sent ${response.successCount} messages`);
    return response;
  } catch (error) {
    console.error('Error sending messages:', error);
    throw error;
  }
}

// Send notification to user (fetch tokens from database)
async function sendNotificationToUser(userId, title, body, data = {}) {
  // Fetch all active tokens for user from database
  const tokens = await getUserTokens(userId);
  
  if (tokens.length === 0) {
    console.log(`No tokens found for user ${userId}`);
    return;
  }

  return sendNotificationToMultipleTokens(tokens, title, body, data);
}
```

## Implementation Notes

- **Token Uniqueness**: One user can have multiple tokens (multiple devices)
- **Token Validation**: Validate FCM token format before saving
- **Token Expiry**: Handle expired/invalid tokens gracefully
- **Idempotency**: Save/update should be idempotent (same token can be saved multiple times safely)
- **User Association**: Associate tokens with authenticated user ID from JWT token
