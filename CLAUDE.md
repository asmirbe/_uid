# CLAUDE.md

## Project Overview

This is a PostgreSQL function library for generating cryptographically secure unique identifiers (UIDs). The UIDs use a 62-character alphanumeric set (A-Z, a-z, 0-9) and are URL-safe.

## Key Files

| File | Purpose |
|------|---------|
| `_uid_function.sql` | Standard `_uid(len)` function - default choice for most applications |
| `_uid_optimized.sql` | Optimized `_uid_fast(len)` function - 3-5x faster for high-throughput scenarios |
| `performance_analysis.sql` | SQL scripts for benchmarking and testing |
| `collision_analysis.md` | Mathematical analysis of collision probabilities |
| `performance_theoretical_analysis.md` | Detailed performance comparison documentation |

## Database Requirements

- **PostgreSQL** with the `pgcrypto` extension
- Extension is auto-created by the SQL files: `CREATE EXTENSION IF NOT EXISTS pgcrypto;`

## Function Signatures

```sql
-- Standard version (3,000-10,000 UIDs/sec)
_uid(len INTEGER) RETURNS TEXT

-- Optimized version (10,000-25,000 UIDs/sec)
_uid_fast(len INTEGER) RETURNS TEXT

-- Performance comparison helper
compare_uid_performance(iterations INTEGER, uid_length INTEGER) RETURNS TABLE
```

## Common Commands

```sql
-- Generate a UID
SELECT _uid(11);

-- Test performance comparison (requires both functions installed)
SELECT * FROM compare_uid_performance(1000, 11);

-- Verify character distribution
SELECT substr(_uid(1), 1, 1) as char, COUNT(*) FROM generate_series(1, 6200) GROUP BY char;
```

## Implementation Details

- Uses `gen_random_bytes()` from pgcrypto for cryptographic randomness
- Implements rejection sampling to ensure uniform distribution (avoids modulo bias)
- Standard version: rejection threshold at 248 (62 * 4)
- Optimized version: pre-generates 10% extra bytes to minimize crypto calls

## Recommended UID Lengths

| Length | Use Case | Safe for |
|--------|----------|----------|
| 8 | Session IDs, temp tokens | 1M entries |
| 11 | User IDs (recommended) | 100M entries |
| 12 | Large-scale systems | 1B entries |
| 16 | Security tokens | Unlimited |

## Code Style

- SQL uses uppercase keywords (SELECT, CREATE, RETURNS)
- PL/pgSQL for function bodies
- Comprehensive header comments in SQL files
- Markdown for documentation
