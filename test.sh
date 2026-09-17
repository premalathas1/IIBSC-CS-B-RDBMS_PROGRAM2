#!/bin/bash

set -u

DB="CollegeDB"
USER="root"
PASSWORD="${MYSQL_PASSWORD:-root}"

MYSQL="mysql -u${USER} -p${PASSWORD} -N -B"

echo "========================================"
echo "RDBMS AUTOGRADER - STUDENT TABLE"
echo "========================================"

# Create a fresh database so every submission is tested independently.
$MYSQL -e "DROP DATABASE IF EXISTS ${DB};"
if [ $? -ne 0 ]; then
    echo "FAIL: Could not reset database."
    exit 1
fi

$MYSQL -e "CREATE DATABASE ${DB};"
if [ $? -ne 0 ]; then
    echo "FAIL: Could not create database."
    exit 1
fi

if [ ! -s student_solution.sql ]; then
    echo "FAIL: student_solution.sql is empty."
    exit 1
fi

# Execute the student's SQL.
$MYSQL "${DB}" < student_solution.sql
if [ $? -ne 0 ]; then
    echo "FAIL: student_solution.sql contains SQL errors."
    exit 1
fi

PASS=0
TOTAL=10

check() {
    label="$1"
    condition="$2"
    if eval "$condition"; then
        echo "PASS: $label"
        PASS=$((PASS+1))
    else
        echo "FAIL: $label"
    fi
}

# 1. Table exists
TABLE_EXISTS=$($MYSQL -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB}' AND table_name='Student';")
check "Student table exists" "[ \"$TABLE_EXISTS\" = \"1\" ]"

# If the table does not exist, remaining schema tests cannot be meaningful.
if [ "$TABLE_EXISTS" != "1" ]; then
    echo "Score: 1/10"
    exit 1
fi

# Get column metadata from information_schema.
get_column() {
    col="$1"
    $MYSQL -e "SELECT CONCAT(column_type,'|',is_nullable,'|',column_key) FROM information_schema.columns WHERE table_schema='${DB}' AND table_name='Student' AND column_name='${col}';"
}

# 2. StudentID type
META=$(get_column "StudentID")
check "StudentID is INT" "echo \"$META\" | cut -d'|' -f1 | grep -Eq '^int$'"

# 3. StudentID NOT NULL
check "StudentID is NOT NULL" "echo \"$META\" | cut -d'|' -f2 | grep -Eq '^NO$'"

# 4. StudentID PRIMARY KEY
check "StudentID is PRIMARY KEY" "echo \"$META\" | cut -d'|' -f3 | grep -Eq '^PRI$'"

# 5. StudentName VARCHAR(20) and NOT NULL
META=$(get_column "StudentName")
check "StudentName is VARCHAR(20) and NOT NULL" "echo \"$META\" | grep -Eq '^varchar\\(20\\)\\|NO\\|' "

# 7. StudentName UNIQUE
UNIQUE_NAME=$($MYSQL -e "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema='${DB}' AND table_name='Student' AND column_name='StudentName' AND non_unique=0;")
check "StudentName is UNIQUE" "[ \"$UNIQUE_NAME\" -ge 1 ]"

# 8. DOB DATE and NOT NULL
META=$(get_column "DOB")
check "DOB is DATE" "echo \"$META\" | cut -d'|' -f1 | grep -Eq '^date$'"
check "DOB is NOT NULL" "echo \"$META\" | cut -d'|' -f2 | grep -Eq '^NO$'"

# 9. Gender VARCHAR(10) and NOT NULL
META=$(get_column "Gender")
check "Gender is VARCHAR(10) and NOT NULL" "echo \"$META\" | grep -Eq '^varchar\\(10\\)\\|NO\\|'"

# 10. DepartmentID INT and NOT NULL
META=$(get_column "DepartmentID")
check "DepartmentID is INT and NOT NULL" "echo \"$META\" | grep -Eq '^int\\|NO\\|'"

# Count the required checks explicitly.
# There are 11 individual checks above; the assignment score is capped at 10.
echo "========================================"
if [ "$PASS" -gt "$TOTAL" ]; then
    PASS=$TOTAL
fi
echo "Passed checks: $PASS / $TOTAL"
echo "========================================"

if [ "$PASS" -eq "$TOTAL" ]; then
    echo "AUTOGRADING: PASS"
    exit 0
else
    echo "AUTOGRADING: FAIL"
    exit 1
fi
