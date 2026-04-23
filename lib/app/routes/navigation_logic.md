## First, one simple idea (this matters)

The app must always remember **where the user wanted to go**.

Call this thing:

> **targetScreen**

If the user is a guest and tries to do something private, we save the target, then ask them to log in.

That is the whole magic. Everything else is just repeating this rule.

---

## Basic rules the app must follow

1. Guest users can see public screens.
2. Guest users cannot open private screens or do private actions.
3. When a guest tries a private thing:

   - Do NOT navigate immediately.
   - Show a dialog on top of the current screen.

4. If user logs in successfully:

   - Go to the screen they wanted.

5. If user cancels or presses back:

   - Stay or return to where they were.

6. Logged-in users:

   - No dialog.
   - No drama.
   - Just proceed.

---

## Flow for Mr A (guest tapping tabs like Cart, Profile, Orders)

### Step by step logic

**When app starts**

- User is guest
- Show Home Page

---

**When Mr A taps Cart / Profile / Orders**

```
IF user is logged in
    Go to the tapped screen
ELSE
    Save targetScreen = Cart (or Profile, or Orders)
    Show login dialog on top of current screen
```

---

**When dialog buttons are pressed**

**Cancel button**

```
Close dialog
Stay on current screen
```

**Continue button**

```
Navigate to Login Screen
```

---

**On Login Screen**

**If login is successful**

```
Navigate to targetScreen
Clear targetScreen
```

**If user presses back without logging in**

```
Go back to previous screen (Home)
Do NOT navigate to targetScreen
Clear targetScreen
```

---

## Flow for Mr B (guest pressing "Add to Cart")

This is almost the same. The only difference is the **targetScreen**.

---

**When Mr B presses "Add to Cart"**

```
IF user is logged in
    Add item to cart
ELSE
    Save targetScreen = Current Screen (Home / Category / Detail)
    Show login dialog on top of current screen
```

---

**Dialog behavior**

**Cancel**

```
Close dialog
Stay on current screen
```

**Continue**

```
Navigate to Login Screen
```

---

**On Login Screen**

**If login successful**

```
Navigate back to targetScreen
Clear targetScreen
(Note: User must manually click "Add to Cart" again - no automatic adding)
```

**If user presses back**

```
Go back to targetScreen
Clear targetScreen
```

---

## Flow for Mr C (authenticated user)

This one is boring. Computers love boring.

```
IF user is logged in
    Allow everything
    No dialogs
    No checks
```

---

## One sentence summary (for your future self)

> If a guest wants something private, remember where they wanted to go, politely ask them to log in without moving the screen, and only navigate after successful login.

That’s it. No white screens. No accidental navigation. No “why am I here?” moments.
