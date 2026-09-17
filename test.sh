```bash
#!/bin/bash

set -e

DB="student_db"
USER="testuser"
PASSWORD="testpass"

MYSQL="mysql -u$USER -p$PASSWORD $DB"

echo "======================================"
echo "     RDBMS PROGRAM 2 AUTOGRADER"
echo "======================================"

echo ""
echo "Checking Student table..."

# Check table exists
TABLE=$($MYSQL -N -e "
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema='$DB'
AND table_name='Student';
")

if [ "$TABLE" -ne 1 ]; then
    echo "FAIL: Student table does not exist."
    exit 1
fi

echo "PASS: Student table exists."


# Check columns
echo ""
echo "Checking columns..."

for COLUMN in StudentID StudentName DOB Gender DepartmentID
do

    COUNT=$($MYSQL -N -e "
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema='$DB'
    AND table_name='Student'
    AND column_name='$COLUMN';
    ")

    if [ "$COUNT" -ne 1 ]; then
        echo "FAIL: Missing column: $COLUMN"
        exit 1
    fi

    echo "PASS: $COLUMN exists."

done


# Check StudentID PRIMARY KEY
echo ""
echo "Checking PRIMARY KEY..."

PK=$($MYSQL -N -e "
SELECT COUNT(*)
FROM information_schema.key_column_usage
WHERE table_schema='$DB'
AND table_name='Student'
AND column_name='StudentID'
AND constraint_name='PRIMARY';
")

if [ "$PK" -ne 1 ]; then
    echo "FAIL: StudentID is not PRIMARY KEY."
    exit 1
fi

echo "PASS: StudentID is PRIMARY KEY."


# Check NOT NULL
echo ""
echo "Checking NOT NULL constraints..."

for COLUMN in StudentName DOB Gender DepartmentID
do

    NULLABLE=$($MYSQL -N -e "
    SELECT IS_NULLABLE
    FROM information_schema.columns
    WHERE table_schema='$DB'
    AND table_name='Student'
    AND column_name='$COLUMN';
    ")

    if [ "$NULLABLE" != "NO" ]; then
        echo "FAIL: $COLUMN must be NOT NULL."
        exit 1
    fi

    echo "PASS: $COLUMN is NOT NULL."

done


# Check UNIQUE StudentName
echo ""
echo "Checking UNIQUE constraint..."

UNIQUE_COUNT=$($MYSQL -N -e "
SELECT COUNT(*)
FROM information_schema.statistics
WHERE table_schema='$DB'
AND table_name='Student'
AND column_name='StudentName'
AND non_unique=0;
")

if [ "$UNIQUE_COUNT" -lt 1 ]; then
    echo "FAIL: StudentName must be UNIQUE."
    exit 1
fi

echo "PASS: StudentName is UNIQUE."


# Final result
echo ""
echo "======================================"
echo "       ALL TESTS PASSED!"
echo "======================================"

exit 0
```
