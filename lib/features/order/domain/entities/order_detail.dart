import 'package:freezed_annotation/freezed_annotation.dart';
import 'order.dart';
import 'order_item.dart';
import 'order_address.dart';
import 'payment.dart';
import 'order_branch.dart';

part 'order_detail.freezed.dart';

@freezed
sealed class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required Orderr order,
    required List<OrderItem> items,
    OrderAddress?
    address, // Nullable because pickup orders don't have addresses
    required Payment payment,
    OrderBranch? branch,
  }) = _OrderDetail;
}
/*
we have problems in our datasource folder let's think before we create these files because there is a bit different thing when it becomes to order usecase since get order details and get all orders response are a bit dirrent so using ApiResponse will not make things correct for get order details or get all order i think let's make a professional educated discussion first

here is the api documentation from backend teams
Get All Orders 
 Retrieves all orders for the authenticated user. 
 URL: /order/get-orders 
 Method: GET 
 Path Parameters: None 
 Query Parameters: None 
 Headers: 
o Authorization: Bearer <token> (required) 
 Example: GET http://localhost:3000/api/order/get-deliverer-orders 
Success Response: 
{ 
"success": true, 
"data": { 
"orders": [ 
{ 
"id": 3, 
"userId": 4, 
"userPhone": "+251912345678", 
"branchId": 1, 
"qrCode": "141900", 
"status": "pending", 
"type": "pickup", 
"delivererId": null, 
"delivererPhone": null, 
"scheduledAt": "2025-09-07T21:01:19.000Z", 
"note": "Leave at the front gate", 
"quantity": 3, 
"subtotal": "450.00", 
"vatTotal": "67.50", 
"deliveryFee": "30.00", 
"pointUsed": 100, 
"pointDiscount": "10.00", 
"promoCode": "WELCOME122", 
"promoCodeDiscount": "45.00", 
"discountTotal": "55.00", 
"totalAmount": "492.50", 
"createdAt": "2025-09-18T08:04:38.000Z", 
"updatedAt": "2025-09-18T08:04:38.000Z" 
}, 
{ 
"id": 2, 
"userId": 4, 
"userPhone": "+251912345678", 
"branchId": 1, 
"qrCode": "276242", 
"status": "pending", 
"type": "pickup", 
"delivererId": null, 
"delivererPhone": null, 
"scheduledAt": "2025-09-07T21:01:19.000Z", 
"note": "Leave at the front gate", 
"quantity": 3, 
"subtotal": "450.00", 
"vatTotal": "67.50", 
"deliveryFee": "30.00", 
"pointUsed": 100, 
"pointDiscount": "10.00", 
"promoCode": "WELCOME122", 
"promoCodeDiscount": "45.00", 
"discountTotal": "55.00", 
"totalAmount": "492.50", 
"createdAt": "2025-09-17T13:10:38.000Z", 
"updatedAt": "2025-09-17T13:10:38.000Z" 
} 
] 
}, 
"meta": { 
"request_id": "a918b041-fe3a-4bae-a6d9-3a6f88d0e998", 
"timestamp": "2025-09-18T08:05:43.624Z" 
} 
} 
Empty Response (No Orders): 
{ 
"success": true, 
"data": { 
"orders": [] 
}, 
"meta": { 
"request_id": "test-20001", 
"timestamp": "2025-09-18T08:05:43.624Z" 
} 
}


Get Order Details 
 Retrieves detailed information for a specific order, including items, address snapshot, and 
payment details. 
 URL: /order/get-order-detail/:orderId 
 Method: GET 
 Path Parameters: 
o orderId (integer*, required): ID of the order 
 Query Parameters: None 
 Headers: 
o Authorization: Bearer <token> (required) 
 Example: GET http://localhost:3000/api/order/get-order-detail/2 
Success Response: 
{ 
"success": true, 
"data": { 
"order": { 
"id": 2, 
"userId": 4, 
"userPhone": "+251912345678", 
"branchId": 1, 
"qrCode": "276242", 
"status": "pending", 
"type": "pickup", 
"delivererId": null, 
"delivererPhone": null, 
"scheduledAt": "2025-09-07T21:01:19.000Z", 
"note": "Leave at the front gate", 
"quantity": 3, 
"subtotal": "450.00", 
"vatTotal": "67.50", 
"deliveryFee": "30.00", 
"pointUsed": 100, 
"pointDiscount": "10.00", 
"promoCode": "WELCOME122", 
"promoCodeDiscount": "45.00", 
"discountTotal": "55.00", 
"totalAmount": "492.50", 
"createdAt": "2025-09-17T13:10:38.000Z", 
"updatedAt": "2025-09-17T13:10:38.000Z" 
}, 
"items": [ 
{ 
"id": 1, 
"orderId": 2, 
"productId": 3, 
"quantity": 10, 
"name": "Potato Chips", 
"price": "1.50", 
"images": ["chips.png"], 
"description": "Salted potato chips", 
"ingredients": ["Potatoes", "Salt"], 
"discount": "0.00", 
"variants": "Small,Large", 
"nutrition": "200.00", 
"vatRate": "0.10", 
"createdAt": "2025-09-17T13:10:38.000Z" 
}, 
{ 
"id": 2, 
"orderId": 2, 
"productId": 1, 
"quantity": 5, 
"name": "Espresso", 
"price": "2.50", 
"images": ["espresso1.png", "espresso2.png"], 
"description": "Strong black coffee", 
"ingredients": ["Coffee Beans", "Water"], 
"discount": "0.00", 
"variants": "Single,Double", 
"nutrition": "50.00", 
"vatRate": "0.15", 
"createdAt": "2025-09-17T13:10:38.000Z" 
} 
], 
"address": null, 
"payment": { 
"id": 1, 
"orderId": 2, 
"method": "chappa", 
"transactionId": "TXN123456789", 
"amount": "492.50", 
"date": "2025-09-17T13:10:38.000Z" 
} 
}, 
"meta": { 
"request_id": "48486fab-ece5-441d-9578-355777b128df", 
"timestamp": "2025-09-18T08:06:23.736Z" 
} 
} 
Error Response (Order Not Found, Status: 404): 
{ 
"success": false, 
"error": { 
"code": "NOT_FOUND", 
"message": "Order not found", 
"details": null, 
"retry": null 
}, 
"meta": { 
"request_id": "test-20001", 
"timestamp": "2025-09-18T08:06:23.736Z" 
} 
} 
Notes: 
 Includes order details, item snapshots (product data at order time), address snapshot (for 
delivery orders), and payment info. 
 items is an array of order item snapshots (product data preserved at order creation). 
 address is null for pickup orders. 
 Requires a valid Bearer token and ownership of the order
*/ 