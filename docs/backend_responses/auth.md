POST: {{baseURL}}/api/user/register
request
{
  "meta": {
    .... metadatas here
  },
  "data": {
    "name": "Rejeb Deliverer",
    "role": "user", //role is always user so that we gonna make it static
    "email": "rejebtest@gmail.com",
    "password": "123456"
  }
}

response

{
    
    "success": true,
    "data": {
        "user": {
            "id": 47,
            "imageUrl": null,
            "name": "Rejeb Deliverer",
            "phone": null,
            "role": "deliverer",
            "email": "rejebtest@gmail.com",
            "phoneVerified": 0,
            "googleId": null,
            "provider": "local",
            "createdAt": "2025-12-18T15:39:18.000Z",
            "updatedAt": "2025-12-18T15:39:18.000Z"
        },
    },
    "meta": {
        "request_id": "signup_123456",
        "timestamp": "2025-12-18T15:39:18.238Z"
    }
}


POST: {{baseURL}}/api/user/login

request:
{
  "meta": {
    "request_id": "signup_123456",
    "client": "mobile"
    ...
  },
  "data": {
    "password": "123456",
    "phone": "251930312864"
    
  }
}

response
{
    "success": true,
    "data": {
        "message": "Login successful",
        "user": {
            "id": 37,
            "imageUrl": "/uploads/user-profile/user-37-1765794691594-531329127.jpg",
            "name": "Rejeb Deliverer",
            "phone": "251930312864",
            "role": "deliverer",
            "email": "rejeb@gmail.com",
            "phoneVerified": 1,
            "googleId": null,
            "provider": "local",
            "createdAt": "2025-12-15T07:48:09.000Z",
            "updatedAt": "2025-12-15T10:31:31.000Z"
        },
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjM3LCJwaG9uZSI6IjI1MTkzMDMxMjg2NCIsImlhdCI6MTc2NjA3NTUwNSwiZXhwIjoxNzY2MDg0NTA1fQ.1LDq5maR0kWp4sKof-2XH67H_L1kG7GnqxSFfOygSUY",
        "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjM3LCJwaG9uZSI6IjI1MTkzMDMxMjg2NCIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzY2MDc1NTA1LCJleHAiOjE3NjY2ODAzMDV9.2vaubvSHUgT_6brp7J-ANklyzqOw6mLTdbzuMln4Ft0"
    },
    "meta": {
        "request_id": "signup_123456",
        "timestamp": "2025-12-18T16:31:45.917Z"
    }
}

