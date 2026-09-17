```bash
#!/bin/bash

echo "=========================================="
echo "     STUDENT TABLE ASSIGNMENT TEST"
echo "=========================================="

set -e

# ------------------------------------------
# 1. Check database
# ------------------------------------------

echo ""
echo "1. Checking database..."

if [ ! -f database.db ]; then
    echo "FAIL: database.db was not created."
    exit 1
fi

echo "PASS: database.db exists."


# ------------------------------------------
# 2. Check Student table
# ------------------------------------------

echo ""
echo "2. Checking Student table..."

TABLE=$(sqlite3 database.db \
"SELECT name FROM sqlite_master WHERE type='table' AND name='Student';")

if [ "$TABLE" != "Student" ]; then
    echo "FAIL: Student table does not exist."
    exit 1
fi

echo "PASS: Student table exists."


# ------------------------------------------
# 3. Display table structure
# ------------------------------------------

echo ""
echo "3. Student table structure:"
echo ""

sqlite3 database.db "PRAGMA table_info(Student);"


# ------------------------------------------
# 4. Check required columns
# ------------------------------------------

echo ""
echo "4. Checking required columns..."

for COLUMN in StudentID StudentName DOB Gender DepartmentID
do

    COUNT=$(sqlite3 database.db \
    "SELECT COUNT(*) FROM pragma_table_info('Student') WHERE name='$COLUMN';")

    if [ "$COUNT" -ne 1 ]; then
        echo "FAIL: $COLUMN column is missing."
        exit 1
    fi

    echo "PASS: $COLUMN exists."

done


# ------------------------------------------
# 5. Check number of columns
# ------------------------------------------

echo ""
echo "5. Checking number of columns..."

COLUMN_COUNT=$(sqlite3 database.db \
"SELECT COUNT(*) FROM pragma_table_info('Student');")

if [ "$COLUMN_COUNT" -ne 5 ]; then
    echo "FAIL: Student table must contain exactly 5 columns."
    exit 1
fi

echo "PASS: Student table contains 5 columns."


# ------------------------------------------
# 6. Check PRIMARY KEY
# ------------------------------------------

echo ""
echo "6. Checking PRIMARY KEY..."

PK=$(sqlite3 database.db \
"SELECT pk FROM pragma_table_info('Student') WHERE name='StudentID';")

if [ "$PK" -ne 1 ]; then
    echo "FAIL: StudentID must be PRIMARY KEY."
    exit 1
fi

echo "PASS: StudentID is PRIMARY KEY."


# ------------------------------------------
# 7. Check NOT NULL
# ------------------------------------------

echo ""
echo "7. Checking NOT NULL constraints..."

for COLUMN in StudentName DOB Gender DepartmentID
do

    NOTNULL=$(sqlite3 database.db \
    "SELECT notnull FROM pragma_table_info('Student') WHERE name='$COLUMN';")

    if [ "$NOTNULL" -ne 1 ]; then
        echo "FAIL: $COLUMN must be NOT NULL."
        exit 1
    fi

    echo "PASS: $COLUMN is NOT NULL."

done


# ------------------------------------------
# 8. Check UNIQUE constraint
# ------------------------------------------

echo ""
echo "8. Checking UNIQUE constraint on StudentName..."

sqlite3 database.db "DELETE FROM Student;"

sqlite3 database.db <<EOF
INSERT INTO Student
(StudentID, StudentName, DOB, Gender, DepartmentID)
VALUES
(10001, 'Arun', '2002-05-10', 'Male', 101);
EOF

if sqlite3 database.db <<EOF
INSERT INTO Student
(StudentID, StudentName, DOB, Gender, DepartmentID)
VALUES
(10002, 'Arun', '2002-06-15', 'Male', 102);
EOF
then
    echo "FAIL: StudentName is not UNIQUE."
    exit 1
else
    echo "PASS: StudentName is UNIQUE."
fi


# ------------------------------------------
# 9. Check duplicate StudentID
# ------------------------------------------

echo ""
echo "9. Checking duplicate StudentID..."

if sqlite3 database.db <<EOF
INSERT INTO Student
(StudentID, StudentName, DOB, Gender, DepartmentID)
VALUES
(10001, 'Kumar', '2001-07-20', 'Male', 102);
EOF
then
    echo "FAIL: Duplicate StudentID was accepted."
    exit 1
else
    echo "PASS: Duplicate StudentID is rejected."
fi


# ------------------------------------------
# 10. Check NULL StudentName
# ------------------------------------------

echo ""
echo "10. Checking NULL StudentName..."

if sqlite3 database.db <<EOF
INSERT INTO Student
(StudentID, StudentName, DOB, Gender, DepartmentID)
VALUES
(10003, NULL, '2003-01-10', 'Female', 103);
EOF
then
    echo "FAIL: NULL StudentName was accepted."
    exit 1
else
    echo "PASS: NULL StudentName is rejected."
fi


# ------------------------------------------
# 11. Final result
# ------------------------------------------

echo ""
echo "=========================================="
echo "          ALL TESTS PASSED!"
echo "=========================================="

echo ""
echo "Student table assignment completed"
echo "successfully."

exit 0
```
