/*
_uid function generates a cryptographically secure unique identifier (UID) of a specified length.
It uses the pgcrypto extension to ensure cryptographic randomness.

Parameters:
- len INTEGER: The desired length of the UID. Must be a positive integer.

Returns:
TEXT: A string of random characters of the specified length.

Character Set:
The UID is composed of characters from the following set:
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789

Notes:
- Requires the pgcrypto extension.
- Uses gen_random_bytes() for secure random number generation.
- Ensures uniform distribution across the character set.
- Raises an exception if the length parameter is NULL or non-positive.

Usage Examples:
1. Generate a 10-character UID:
   SELECT _uid(10);

2. Use as a default value for a column:
   CREATE TABLE users (
       id SERIAL PRIMARY KEY,
       uid TEXT UNIQUE NOT NULL DEFAULT _uid(10)
   );

3. Generate UID in an INSERT statement:
   INSERT INTO users (uid, username) VALUES (_uid(15), 'john_doe');

Performance:
This function performs multiple database operations and should be used judiciously
in high-volume insert scenarios. Consider generating UIDs in batches for better performance
in such cases.
*/
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION _uid(len INTEGER)
RETURNS TEXT AS $$
DECLARE
    uid_chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    result TEXT := '';
    i INTEGER;
    rand_bytes BYTEA;
    rand_int INTEGER;
BEGIN
    -- Input validation
    IF len IS NULL THEN
        RAISE EXCEPTION 'Length parameter cannot be NULL';
    END IF;

    IF len <= 0 THEN
        RAISE EXCEPTION 'Length must be greater than zero';
    END IF;

    -- Generate random bytes
    rand_bytes := gen_random_bytes(len);

    -- Convert random bytes to characters
    FOR i IN 1..len LOOP
        rand_int := get_byte(rand_bytes, i - 1);
        -- Ensure rand_int is within the valid range (0-61)
        WHILE rand_int > 248 LOOP
            rand_int := get_byte(gen_random_bytes(1), 0);
        END LOOP;
        result := result || substr(uid_chars, (rand_int % 62) + 1, 1);
    END LOOP;

    RETURN result;
END;
$$ LANGUAGE plpgsql VOLATILE;