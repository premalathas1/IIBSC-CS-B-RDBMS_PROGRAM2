#!/bin/bash

echo "===================================="
echo "Running SQL Assignment Tests..."
echo "===================================="

mysql -h127.0.0.1 -uroot -proot assignmentdb < tests/test_cases.sql

if [ $? -eq 0 ]; then
    echo ""
    echo "===================================="
    echo " All tests passed successfully!"
    echo "===================================="
    exit 0
else
    echo ""
    echo "===================================="
    echo " Tests failed!"
    echo "===================================="
    exit 1
fi
