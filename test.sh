#!/bin/bash

set -u

DB="CollegeDB"
USER="${MYSQL_USER:-root}"
PASSWORD="${MYSQL_PASSWORD:-root}"

MYSQL="mysql -u${USER} -p${PASSWORD} -N -B"

echo "========================================"
echo "RDBMS AUTOGRADER"
echo "Student Table Creation"
echo "========================================"

# ----------------------------------------
# 1. Create fresh database
# ----------------------------------------

echo "Creating fresh CollegeDB database..."

$MYSQL -e "DROP DATABASE IF EXISTS ${DB};"

if [ $? -ne 0 ]; then
    echo "FAIL: Could not drop database."
    exit 1
fi

$MYSQL -e "CREATE DATABASE ${DB};"

if [ $? -ne 0 ]; then
    echo "FAIL: Could not create CollegeDB database."
    exit 1
fi

echo "PASS: CollegeDB database created."

# ----------------------------------------
# 2. Check student solution file
# ----------------------------------------

if [ ! -s student_solution.sql ]; then
    echo "FAIL: student_solution.sql is empty."
    exit 1
fi

echo "PASS: student_solution.sql found."

# ----------------------------------------
# 3. Execute student SQL
# ----------------------------------------

echo "Executing student_solution.sql..."

$MYSQL "${DB}" < student_solution.sql

if [ $? -ne 0 ]; then
    echo "FAIL: SQL execution error."
    exit 1
fi

echo "PASS: Student SQL executed successfully."

PASS=0
TOTAL=10

# ----------------------------------------
# Function to record test result
# ----------------------------------------

check() {
    LABEL="$1"
    CONDITION="$2"

    if eval "$CONDITION"; then
        echo "PASS: $LABEL"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $LABEL"
    fi
}

# ----------------------------------------
# Test 1
# Student table exists
# ----------------------------------------

TABLE_EXISTS=$($MYSQL -e "
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema='${DB}'
AND table_name='Student';
")

check "Student table exists" \
"[ \"$TABLE_EXISTS\" = \"1\" ]"

if [ "$TABLE_EXISTS" != "1" ]; then
    echo "========================================"
    echo "FINAL SCORE: 0/10"
    echo "========================================"
    exit 1
fi

# ----------------------------------------
# Get column information
# ----------------------------------------

get_column() {
    COLUMN="$1"

    $MYSQL -e "
    SELECT CONCAT(
        column_type, '|',
        is_nullable, '|',
        column_key
    )
    FROM information_schema.columns
    WHERE table_schema='${DB}'
    AND table_name='Student'
    AND column_name='${COLUMN}';
    "
}

# ----------------------------------------
# Test 2
# StudentID INT
# ----------------------------------------

META=$(get_column "StudentID")

check "StudentID is INT" \
"echo \"$META\" | cut -d'|' -f1 | grep -Eq '^int$'"

# ----------------------------------------
# Test 3
# StudentID NOT NULL
# ----------------------------------------

check "StudentID is NOT NULL" \
"echo \"$META\" | cut -d'|' -f2 | grep -Eq '^NO$'"

# ----------------------------------------
# Test 4
# StudentID PRIMARY KEY
# ----------------------------------------

check "StudentID is PRIMARY KEY" \
"echo \"$META\" | cut -d'|' -f3 | grep -Eq '^PRI$'"

# ----------------------------------------
# StudentName
# ----------------------------------------

META=$(get_column "StudentName")

# ----------------------------------------
# Test 5
# StudentName VARCHAR(20) and NOT NULL
# ----------------------------------------

check "StudentName is VARCHAR(20) and NOT NULL" \
"echo \"$META\" | grep -Eq '^varchar\\(20\\)\\|NO\\|'"

# ----------------------------------------
# Test 6
# StudentName UNIQUE
# ----------------------------------------

UNIQUE_NAME=$($MYSQL -e "
SELECT COUNT(*)
FROM information_schema.statistics
WHERE table_schema='${DB}'
AND table_name='Student'
AND column_name='StudentName'
AND non_unique=0;
")

check "StudentName is UNIQUE" \
"[ \"$UNIQUE_NAME\" -ge 1 ]"

# ----------------------------------------
# DOB
# ----------------------------------------

META=$(get_column "DOB")

# ----------------------------------------
# Test 7
# DOB DATE
# ----------------------------------------

check "DOB is DATE" \
"echo \"$META\" | cut -d'|' -f1 | grep -Eq '^date$'"

# ----------------------------------------
# Test 8
# DOB NOT NULL
# ----------------------------------------

check "DOB is NOT NULL" \
"echo \"$META\" | cut -d'|' -f2 | grep -Eq '^NO$'"

# ----------------------------------------
# Gender
# ----------------------------------------

META=$(get_column "Gender")

# ----------------------------------------
# Test 9
# Gender VARCHAR(10) and NOT NULL
# ----------------------------------------

check "Gender is VARCHAR(10) and NOT NULL" \
"echo \"$META\" | grep -Eq '^varchar\\(10\\)\\|NO\\|'"

# ----------------------------------------
# DepartmentID
# ----------------------------------------

META=$(get_column "DepartmentID")

# ----------------------------------------
# Test 10
# DepartmentID INT and NOT NULL
# ----------------------------------------

check "DepartmentID is INT and NOT NULL" \
"echo \"$META\" | grep -Eq '^int\\|NO\\|'"

# ----------------------------------------
# Final Result
# ----------------------------------------

echo ""
echo "========================================"
echo "AUTOGRADING RESULT"
echo "========================================"

echo "Passed Tests: $PASS / $TOTAL"

if [ "$PASS" -eq "$TOTAL" ]; then
    echo "AUTOGRADING: PASS"
    echo "FINAL SCORE: 10/10"
    exit 0
else
    echo "AUTOGRADING: FAIL"
    echo "FINAL SCORE: $PASS/10"
    exit 1
fi
