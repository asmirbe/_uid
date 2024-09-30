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