## 1. Core principle (adult thinking first)

* **UI development must not block on backend readiness**
* Use **mock data that mirrors final backend shape**
* Swap mock → API later with **zero UI rewrite**
* Notification UI must be:

  * predictable
  * boring in a good way
  * familiar to users of real apps

No experiments. No “clever” patterns. Just industry-standard behavior.

### Navigation rule (important)

* If `orderId` exists → **navigate to order detail**
* Else if `productId` exists → **navigate to product detail**
* Else → **no navigation**
  If backend sends both, **order wins**. Period.

This avoids “what should happen?” bugs forever.

---

## 3. Notification screen behavior (adult UX)

### When user opens Notification Screen

1. Fetch notifications (mock for now)
2. Render list immediately
3. Collect all `unread` notification IDs
4. Call:

   ```js
   markMultipleUserNotificationsAsRead(userId, notificationIds)
   ```
5. Update local state so UI reflects **read status instantly**

No spinners. No delays. No dramatic animations.

This matches how real apps behave.

---

## 4. Read vs Unread UI (no nonsense)

### Unread notification

* Slightly bolder title
* Subtle background tint OR small left indicator
* Nothing fancy
* No gradients
* No animations

### Read notification

* Normal text weight
* Flat background

If a designer can describe it in one sentence, it’s good.

---

## 5. Notification card (final contract)

### Card shows only:

* **Title**
* **Body**
* **Created time** (relative: “5 min ago”, “Yesterday”)
* **Optional action**

  * “View details” button OR
  * trailing `>` icon

No icons per type.
No colors per event.
No unread badges per card.

The list itself is the UX.

---

## 6. Card interaction rules

### If notification is navigable

* Show trailing `>` icon
* OR show “View details” text button
* Tapping anywhere on card navigates

### If not navigable

* No button
* No arrow
* Card is static

This avoids fake affordances.

---

## 7. Files you will create (only these)

No more. No less.

### 1️⃣ Notification Screen

* Displays list of notifications
* Handles mark-as-read on entry
* Uses provider for data

### 2️⃣ Notification Card

* Stateless
* Receives:
object
* Zero business logic inside

### 3️⃣ Notification Provider

* Holds notification list
* Exposes:

  * `loadNotifications()`
  * `markAllAsRead()`
* Mock-backed now, API-backed later

### 4️⃣ Mock Data File

* Matches backend response shape exactly
* Contains:

  * order notifications
  * product notifications
  * broadcast notifications
  * read + unread mix

This is how you avoid refactors later.

---

## 8. Navigation entry point

* Home screen has notification icon
* Tap → navigate to Notification Screen
* No badge logic for now
* No unread count logic for now

Simple. Extend later.

---

## 9. What you are *not* doing (intentionally)

* No pagination
* No swipe actions
* No delete
* No filter
* No grouping by date
* No fancy empty states

Those come **after backend stabilization**, not before.

---

## 10. Final adult summary

You are building:

* a **stable UI contract**
* with **mock-first discipline**
* using **boring, proven UX**
* that will survive backend changes

This is how professionals move fast **without breaking the future**.
If you have question you can ask you are free!!!