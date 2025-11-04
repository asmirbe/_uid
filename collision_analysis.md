# Collision Probability Analysis for _uid Function

## Mathematical Foundation

The collision probability follows the **birthday paradox** formula:

```
P(collision) ≈ 1 - e^(-n²/2N)
```

Where:
- `n` = number of UIDs generated
- `N` = total possible combinations = 62^len
- `e` = Euler's number ≈ 2.71828

## Collision Probabilities by Length

### Length 6 (62^6 = 56,800,235,584 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000          | 0.0000088%          |
| 10,000         | 0.00088%            |
| 100,000        | 0.088%              |
| 1,000,000      | 8.8%                |
| 5,000,000      | 99.9%               |

**Use case:** Short-term sessions, temporary tokens (< 100k entries)

---

### Length 8 (62^8 = 218,340,105,584,896 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000          | 0.0000000023%       |
| 10,000         | 0.00000023%         |
| 100,000        | 0.000023%           |
| 1,000,000      | 0.0023%             |
| 10,000,000     | 0.23%               |
| 100,000,000    | 22.9%               |
| 1,000,000,000  | 99.99%              |

**Use case:** Small to medium databases (< 10M entries)

---

### Length 10 (62^10 = 839,299,365,868,340,224 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000          | 0.0000000000006%    |
| 10,000         | 0.00000000006%      |
| 100,000        | 0.000000006%        |
| 1,000,000      | 0.0000006%          |
| 10,000,000     | 0.00006%            |
| 100,000,000    | 0.006%              |
| 1,000,000,000  | 0.6%                |
| 10,000,000,000 | 56.3%               |

**Use case:** Medium to large databases (< 100M entries)

---

### Length 11 (62^11 = 52,036,560,683,837,093,888 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000,000      | 0.00000001%         |
| 10,000,000     | 0.000001%           |
| 100,000,000    | 0.0001%             |
| 1,000,000,000  | 0.01%               |
| 10,000,000,000 | 0.96%               |

**Use case:** Large-scale production systems (< 1B entries)

---

### Length 12 (62^12 = 3,226,266,762,397,899,821,056 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000,000      | 0.00000000015%      |
| 10,000,000     | 0.000000015%        |
| 100,000,000    | 0.0000015%          |
| 1,000,000,000  | 0.00015%            |
| 10,000,000,000 | 0.015%              |
| 100,000,000,000| 1.5%                |

**Use case:** Enterprise-scale systems (< 10B entries)

---

### Length 16 (62^16 ≈ 4.77 × 10^28 combinations)

| UIDs Generated | Collision Probability |
|----------------|----------------------|
| 1,000,000,000  | 0.00000000001%      |
| 1,000,000,000,000 | 0.00001%         |
| 10^15          | 1%                  |

**Use case:** Global-scale distributed systems, cryptographic use cases

---

## Recommended Lengths by Use Case

| Use Case | Recommended Length | Max Safe Entries (< 0.01% collision) |
|----------|-------------------|-------------------------------------|
| Session IDs (short-lived) | 8 | 1M |
| User IDs (small app) | 10 | 10M |
| User IDs (medium app) | 11 | 100M |
| User IDs (large app) | 12 | 1B |
| Transaction IDs | 12-14 | 10B |
| Security tokens | 16+ | Practically unlimited |
| API Keys | 20+ | Practically unlimited |

---

## Comparison with UUID

**UUID v4 (128 bits = ~3.4 × 10^38 combinations)**

UUID v4 provides approximately:
- 36 characters (with hyphens): `550e8400-e29b-41d4-a716-446655440000`
- 32 characters (without hyphens): `550e8400e29b41d4a716446655440000`

**_uid equivalent for similar collision resistance:**
- Length 22: 62^22 ≈ 2.7 × 10^39 combinations
- **39% shorter than UUID without hyphens**
- **61% shorter than UUID with hyphens**

**Trade-off:**
- UUID: Standardized, globally recognized format
- _uid: Shorter, more readable, URL-friendly, but custom format

---

## Formula Reference

For exact calculations:

```
N = 62^len
P(at least 1 collision) ≈ 1 - e^(-n²/(2N))
P(no collision) ≈ e^(-n²/(2N))

Safe threshold (P < 0.01%):
n ≈ sqrt(2 × N × ln(10000))
n ≈ sqrt(2 × 62^len × 9.21)
n ≈ 4.29 × sqrt(62^len)
```

---

## Notes

1. **Actual distribution:** The rejection sampling in the current implementation ensures true uniform distribution across the 62-character set.

2. **Birthday paradox:** Collision probability grows quadratically with the number of entries, not linearly. This is why 1M entries in a length-11 space (52 quintillion combinations) still has virtually zero collision risk.

3. **Production safety:** Always add a UNIQUE constraint on UID columns to catch the rare collision case and retry generation.

4. **Multi-table consideration:** If using the same UID space across multiple tables, aggregate the total number of UIDs when calculating collision probability.

---

*Generated: 2025-11-04*
*Analysis by: Asmir Belkic*
