-- Execute student's solution
SOURCE starter/answers.sql;

-- Check whether Student table exists
SHOW TABLES LIKE 'Student';

-- Display the table structure
DESCRIBE Student;

-- Verify column definitions
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='assignmentdb'
AND TABLE_NAME='Student'
ORDER BY ORDINAL_POSITION;

-- Show CREATE TABLE statement
SHOW CREATE TABLE Student;
