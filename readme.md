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

## Authors

- Asmir [GitHub](https://github.com/asmirbe)