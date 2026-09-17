```bash
#!/bin/bash

echo "======================================"
echo " Student Table Assignment - Test"
echo "======================================"

# Stop immediately if any command fails
set -e

# Check whether database exists
if [ ! -f database.db ]; then
    echo "FAIL: database.db was not created."
    exit 1
fi

echo "PASS: database.db exists."

# Check whether Student table exists
TABLE=$(sqlite3 database.db \
"SELECT name FROM sqlite_master WHERE type='table' AND name='Student';")

if [ "$TABLE" != "Student" ]; then
    echo "FAIL: Student table does not exist."
    exit 1
fi

echo "PASS: Student table exists."

# Display table structure
echo ""
echo "Student Table Structure:"
sqlite3 database.db "PRAGMA table_info(Student);"

# Check required columns
echo ""
echo "Checking required columns..."

for COLUMN in StudentID StudentName DOB Gender DepartmentID
do
    COUNT=$(sqlite3 database.db \
    "SELECT COUNT(*) FROM pragma_table_info('Student') WHERE name='$COLUMN';")

    if [ "$COUNT" -ne 1 ]; then
        echo "FAIL: Missing column $COLUMN"
        exit 1
    fi

    echo "PASS: $COLUMN exists."
done

# Check PRIMARY KEY
echo ""
echo "Checking PRIMARY KEY..."

PK=$(sqlite3 database.db \
"SELECT pk FROM pragma_table_info('Student') WHERE name='StudentID';")

if [ "$PK" -ne 1 ]; then
    echo "FAIL: StudentID is not PRIMARY KEY."
    exit 1
fi

echo "PASS: StudentID is PRIMARY KEY."

# Check NOT NULL constraints
echo ""
echo "Checking NOT NULL constraints..."

for COLUMN in StudentName DOB Gender DepartmentID
do
    NOTNULL=$(sqlite3 database.db \
    "SELECT \"notnull\" FROM pragma_table_info('Student') WHERE name='$COLUMN';")

    if [ "$NOTNULL" -ne 1 ]; then
        echo "FAIL: $COLUMN must be NOT NULL."
        exit 1
    fi

    echo "PASS: $COLUMN is NOT NULL."
done

# Check UNIQUE constraint on StudentName
echo ""
echo "Checking UNIQUE constraint on StudentName..."

sqlite3 database.db <<EOF
DELETE FROM Student;

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

# Final result
echo ""
echo "======================================"
echo " ALL TESTS PASSED!"
echo " Student Table Assignment Completed"
echo "======================================"

exit 0
```
