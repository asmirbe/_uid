# _uid

Creates a cryptographically secure UID with a 62 character range that can be safely used in URLs.

## Usage

Run the following SQL query in your PostgreSQL database:

```sql
CREATE OR REPLACE FUNCTION _uid(len INTEGER)
RETURNS TEXT AS $$
-- Function body here (full code in _uid_function.sql)
$$ LANGUAGE plpgsql VOLATILE;
```

Then use it in your queries:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    uid TEXT UNIQUE NOT NULL DEFAULT _uid(11), -- Output : u7aMTGDjQ3a
    username TEXT NOT NULL
	 ...
);
```

## API

**`_uid(INTEGER len) => TEXT`**

- Returns a string of random characters of length `len`
- `len` must always be provided and be a positive integer, else an exception is raised
- Uses `gen_random_bytes` from the pgcrypto extension for secure random number generation
- Character set: `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`

## Collision Probability

The risk of UID collision is extremely low when using appropriate lengths:

| Length | Use Case | Max Safe Entries (< 0.01% collision risk) |
|--------|----------|-------------------------------------------|
| 8      | Session IDs, temporary tokens | 1 million |
| 11     | User IDs (recommended) | 100 million |
| 12     | Large-scale systems | 1 billion |
| 16     | Security tokens | Practically unlimited |

**Example with length 11:**
- 1M users → 0.00000001% collision probability
- 10M users → 0.000001% collision probability
- 100M users → 0.0001% collision probability

For detailed calculations and more length options, see [collision_analysis.md](collision_analysis.md).

**Comparison with UUID:** A 22-character _uid provides similar collision resistance to UUID v4 (128 bits) but is **39% shorter** than UUID without hyphens (32 chars).

## Performance

Two versions are available:

### Standard Version (`_uid_function.sql`)
- **Throughput:** 3,000-10,000 UIDs/second
- **Best for:** Most applications (< 1,000 UIDs/sec)
- **Pros:** Simple, clear code, explicit rejection sampling
- **When to use:** Default choice for typical applications

### Optimized Version (`_uid_optimized.sql`)
- **Throughput:** 10,000-25,000 UIDs/second
- **Best for:** High-throughput scenarios (> 1,000 UIDs/sec)
- **Pros:** 3-5x faster, single crypto call, maintains security & uniformity
- **When to use:** Event logging, batch inserts, high-traffic APIs

**Which version should I use?**

Use the **standard version** unless you have performance requirements exceeding 1,000 UIDs/second. The standard version is perfectly adequate for the vast majority of applications.

For detailed performance analysis and benchmarks, see [performance_theoretical_analysis.md](performance_theoretical_analysis.md).

## Authors

- Asmir [GitHub](https://github.com/asmirbe)