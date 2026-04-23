# Premium Cart Screen Design Plan

## Design Philosophy
- Clean, minimal interface with clear visual hierarchy
- Smooth interactions with optimistic updates
- Premium feel with subtle animations and shadows
- Helpful empty states that guide user action

---

## Screen Structure

### 1. Layout Architecture

```
┌─────────────────────────────────────┐
│        FIXED HEADER SECTION         │
│  - Back button + "Your Cart" title  │
│  - Item count badge                 │
│  - Clear all button (if items > 0)  │
├─────────────────────────────────────┤
│                                     │
│      SCROLLABLE CONTENT AREA        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Cart Items List            │   │
│  │   - CartCard widgets         │   │
│  │   - Swipe to delete          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Price Summary Card         │   │
│  │   - Subtotal                 │   │
│  │   - Delivery fee (if any)    │   │
│  │   - VAT/Tax                  │   │
│  │   - Total (large, bold)      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Promo Code Section         │   │
│  │   (Optional, collapsible)    │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│      FIXED FOOTER SECTION           │
│  ┌─────────────────────────────┐   │
│  │   Proceed to Checkout Button │   │
│  │   (Disabled if empty)        │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

### A. Cart Header Widget
- Back navigation button (←)
- Title: "Your Cart" (h3 style)
- Item count badge: "(X items)"
- Clear All button (only visible when items > 0)
  - Shows confirmation dialog before clearing
  - Icon: trash/delete icon
  - Style: Text button with warning color

### B. Cart Card Widget
- Product image (80x80px, rounded)
- Product name (h4)
- Variant info (if exists)
- Quantity controls (-, quantity, +)
- Line total price
- Delete button
- Swipe to delete functionality

### C. Empty Cart State
- Large cart icon
- "Your cart is empty" message
- "Browse Menu" button

### D. Price Summary Card
- Subtotal
- Delivery Fee (optional)
- VAT (calculated)
- Total (large, bold)

### E. Checkout Button (Footer)
- Fixed at bottom
- Shows total price
- Disabled when empty

---

## Features

1. **Swipe to Delete**: Swipe left on CartCard reveals delete action
2. **Optimistic Updates**: Instant UI feedback
3. **Quantity Controls**: Circular buttons with +/-
4. **Price Calculations**: Subtotal, VAT, Delivery, Total
5. **Loading States**: Per-item and global loading indicators
6. **Error Handling**: Snackbars for success/failure

---

## Widget Structure

```
lib/features/cart/presentation/
├── screens/
│   └── cart_screen.dart (main screen)
├── widgets/
│   ├── cart_header.dart
│   ├── cart_card.dart
│   ├── empty_cart_state.dart
│   ├── price_summary_card.dart
│   ├── checkout_button.dart
│   └── quantity_selector.dart
```

---

## State Management

- `cartNotifierProvider(branchId)` - Get all carts
- `cartQuantityUpdateLoadingProvider` - Loading per item
- `cartDeleteLoadingProvider` - Loading per delete
- `cartDeleteAllLoadingProvider` - Loading for clear all
- `cartUiEventsProvider` - Success/error events

---

## Visual Design

- Primary: AppColors.primary (#64390C)
- Background: AppColors.background (#FFF9ED)
- Cards: White with shadow
- Typography: AppTextStyles constants
- Spacing: AppSizes constants

---

## User Flows

1. View cart → Load items → Display
2. Increase quantity → Optimistic update → API call
3. Decrease quantity → Optimistic update → API call
4. Delete item → Optimistic update → API call
5. Clear all → Confirmation → Optimistic update → API call

---

## Implementation Status

- [x] Plan created
- [ ] cart_screen.dart
- [ ] cart_header.dart
- [ ] cart_card.dart
- [ ] empty_cart_state.dart
- [ ] price_summary_card.dart
- [ ] checkout_button.dart
- [ ] quantity_selector.dart

