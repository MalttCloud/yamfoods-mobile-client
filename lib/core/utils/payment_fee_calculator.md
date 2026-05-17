# Telebirr payment fee — rules

When paying with **Telebirr**, an extra charge may apply on top of the order. It has two parts:

1. **Facilitation fee** — Telebirr service charge  
2. **VAT** — 15% added **only on the facilitation fee** (not on the full order)

**Total Telebirr charge** = facilitation fee + VAT

---

## The rules

| Order total | Facilitation fee |
|-------------|------------------|
| **30,000 or less** | **0.5%** of the order |
| **More than 30,000** | **150** (fixed amount) |

Then:

**VAT** = 15% × facilitation fee  

**Total fee** = facilitation fee + VAT

If the order is zero or negative, the fee is **0**.

---

## Two scenarios

### Small orders (30,000 or less)

The facilitation fee grows with the order (always 0.5% of it). VAT is 15% of that fee.

**Example — order 20,000**

| | |
|---|---|
| Facilitation | 20,000 × 0.5% = **100** |
| VAT | 100 × 15% = **15** |
| **Total fee** | **115** |

### Large orders (above 30,000)

The facilitation fee stays **150**, no matter how big the order is. VAT is still 15% of 150.

**Example — order 50,000**

| | |
|---|---|
| Facilitation | **150** |
| VAT | 150 × 15% = **22.50** |
| **Total fee** | **172.50** |

At exactly **30,000**, both rules give the same facilitation fee (150), so the total fee is the same at that point.

---

## Why you sometimes see ~0.58% (not 0.5%)

People often think the charge is **0.5% of the order**. The **effective** rate is slightly higher because VAT is stacked on top of the facilitation fee.

For orders **30,000 or less**:

```
Effective % ≈ 0.5% × (1 + 15%) = 0.5% × 1.15 = 0.575%
```

That rounds to about **0.58%** of the order — not because the base rate changed, but because **0.5% + 15% tax on that 0.5%** adds up to **0.575%** of the order total.

| Order | Total fee | Fee as % of order |
|-------|-----------|-------------------|
| 20,000 | 115 | **0.575%** (~0.58%) |
| 10,000 | 57.50 | **0.575%** |
| 30,000 | 172.50 | **0.575%** |

For these orders, the **percentage stays the same**; only the **money amount** changes with order size.

---

## Large orders — the % goes down as the order grows

Above 30,000, the fee in **money** is fixed (~**172.50** after VAT), but the **percentage of the order** shrinks when the order gets bigger.

| Order | Total fee | Fee as % of order |
|-------|-----------|-------------------|
| 50,000 | 172.50 | **0.345%** |
| 100,000 | 172.50 | **0.173%** |
| 500,000 | 172.50 | **0.035%** |

So you will **not** see 0.58% on large orders — you only get that kind of rate when the **0.5% + VAT** rule applies.

---

## Quick reference

| | Orders ≤ 30,000 | Orders > 30,000 |
|---|-----------------|-----------------|
| Facilitation | 0.5% of order | 150 flat |
| VAT | 15% of facilitation | 15% of 150 (= 22.50) |
| Typical total fee rate | **~0.575%** of order | **172.50 ÷ order** (varies) |

**In short:** Small orders pay roughly **half a percent plus tax** (~**0.58%** of the order). Large orders pay a **fixed ~172.50**, which is a **smaller share** of the order the more you spend.
