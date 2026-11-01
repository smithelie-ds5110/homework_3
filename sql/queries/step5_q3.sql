-- Step 5, Q3: ZIP codes not starting with a digit
-- Predicted rows: 1
-- Actual rows: 1
-- Gap: None. The query returned one row identifying 18 users.

SELECT
    COUNT(*) AS non_numeric_zip_codes
FROM users
WHERE zip_code NOT GLOB '[0-9]*';
