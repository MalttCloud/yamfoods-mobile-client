# Checkout payment verification (Chapa & Telebirr)

A short guide to **why** the checkout screen uses two different ways to detect “user came back from payment” and when we show the verification dialog. Written so you (or a beginner) can understand the flow and reuse the idea elsewhere.

---

## What we’re solving

After the user pays with **Chapa** or **Telebirr**, they leave our app screen (Chapa opens an in-app route, Telebirr opens the Telebirr app). When they **come back**, we need to:

1. **Detect** that they returned.
2. **Show a verification dialog** that asks our backend: “Did this order get paid?”
3. On success: clear cart and go to Orders.

The tricky part: **Chapa and Telebirr “leave” the app in different ways**, so we need **two different ways to detect “user came back”**.

---

## Two ways the user “leaves” and “comes back”

| Payment  | What happens when they pay      | How we detect “they came back”   |
|----------|----------------------------------|-----------------------------------|
| **Chapa**   | Stays in our app; Chapa SDK **pushes a new route** on top of checkout | That route **pops** when they finish/cancel → we get a **route pop** event |
| **Telebirr** | Our app goes to **background**; Telebirr app opens | User returns to our app → app goes to **foreground** → we get an **app lifecycle** event |

So:

- **Chapa** = “another screen on top of checkout” → we care about **route** events (something was pushed, then popped).
- **Telebirr** = “our app was in background” → we care about **app lifecycle** (resumed = back in foreground).

That’s why we use **two different mechanisms** in the checkout screen.

---

## Mechanism 1: RouteAware (Chapa only)

- **What it is:** A Flutter mixin that lets a screen listen to **route** events: “a route was pushed on top of me” / “the route on top of me was **popped**”.
- **Why we use it for Chapa:** Chapa’s SDK pushes its own payment screen **as a new route** on top of checkout. When the user finishes or cancels, that route **pops**. So “user came back from Chapa” = “the route on top of checkout was popped” = we get **`didPopNext()`**.
- **What we do:** In the checkout screen we use the **`RouteAware`** mixin and subscribe to a **`RouteObserver`** that we pass to the app router. When the observer fires **`didPopNext`**, we check: “Are we waiting for Chapa?” If yes → show the verification dialog.

**In one line:** RouteAware + RouteObserver = “tell me when the screen on top of me is gone” → used for Chapa because Chapa uses an in-app route.

---

## Mechanism 2: WidgetsBindingObserver (Telebirr only)

- **What it is:** A Flutter mixin that lets you listen to **app lifecycle** events: resumed, paused, inactive, etc.
- **Why we use it for Telebirr:** Telebirr opens the **Telebirr app** (our app goes to background). When the user is done, they **switch back to our app** → our app goes to **foreground** → we get **`AppLifecycleState.resumed`**. So “user came back from Telebirr” = “app resumed”.
- **What we do:** In the checkout screen we use **`WidgetsBindingObserver`** and in **`didChangeAppLifecycleState`** we check: if `state == AppLifecycleState.resumed` and “we’re waiting for Telebirr” → show the verification dialog.

**In one line:** WidgetsBindingObserver = “tell me when the app comes back to foreground” → used for Telebirr because Telebirr takes the user to another app (Telebirr Super app).

---

## Summary table (beginner-friendly)

| Thing                         | Chapa                          | Telebirr                          |
|------------------------------|---------------------------------|-----------------------------------|
| User “leaves” how?           | Stays in app; new **route** on top | App goes to **background** (Telebirr app opens) |
| We detect “came back” how?   | **Route popped** (top route gone) | **App resumed** (app in foreground again) |
| Flutter mechanism            | **RouteAware** + **RouteObserver** | **WidgetsBindingObserver** (lifecycle) |
| Method we override           | `didPopNext()`                  | `didChangeAppLifecycleState(state)` |
| When we show verification   | When `didPopNext` + we’re waiting for Chapa | When `resumed` + we’re waiting for Telebirr |

---

## What’s shared (same for both)

- **Pending state:** We store one order id, one payment method, and (for Chapa only) the Chapa `txnRef`. “We’re waiting” = that payment method is set.
- **Verification dialog:** One dialog that asks the backend “is this order paid?” (with method = Chapa or Telebirr). Same dialog for both; only the **method** and **txnRef** (Chapa only) change.
- **On success:** Clear cart and navigate to Orders.

So: **two ways to detect “user came back”**, then **one flow** (show dialog → query backend → on success clear cart and go to Orders).

---

## Quick reference for the checkout screen

- **RouteObserver** is created in **`app_router.dart`** and passed to `GoRouter(observers: [checkoutRouteObserver])`. Without this, RouteAware’s `didPopNext` would never run.
- **RouteAware** is used **only** to react to Chapa’s route being popped.
- **WidgetsBindingObserver** is used **only** to react to app resume (Telebirr return).
- When you **normally** open checkout (no payment started), all pending fields are null, so neither `didPopNext` nor `resumed` will show the dialog — no false triggers.

Use this doc when you add another payment method: if it opens an **in-app route**, use RouteAware; if it **sends the user to another app**, use WidgetsBindingObserver (resumed).

By Rejeb Dendir