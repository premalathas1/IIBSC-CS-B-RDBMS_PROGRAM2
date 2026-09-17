# RDBMS Lab – Create Student Table

## Objective
Create a MySQL table named `Student` with the following fields and constraints.

| Field | Data Type | Required Constraint |
|---|---|---|
| StudentID | INT | PRIMARY KEY |
| StudentName | VARCHAR(20) | NOT NULL and UNIQUE |
| DOB | DATE | NOT NULL |
| Gender | VARCHAR(10) | NOT NULL |
| DepartmentID | INT | NOT NULL |

> Note: MySQL does not use `NUMBER(5)` as an Oracle-style data type. Use `INT` for the `NUMBER(5)` fields.

## Student Task
Write the SQL statement in `student_solution.sql` to create the `Student` table.

Your table must:
1. Be named exactly `Student`.
2. Contain exactly these five columns:
   - `StudentID`
   - `StudentName`
   - `DOB`
   - `Gender`
   - `DepartmentID`
3. Use the required data types/lengths.
4. Define `StudentID` as the PRIMARY KEY.
5. Define `StudentName` as UNIQUE.
6. Define `StudentName`, `DOB`, `Gender`, and `DepartmentID` as NOT NULL.
7. Do not insert sample records. The autograder will perform its own tests.

## How to Submit
1. Open `student_solution.sql`.
2. Write your `CREATE TABLE Student ...` statement.
3. Save the file.
4. Commit and push your changes.
5. GitHub Actions will automatically run the tests.

## Important
- Do not rename `student_solution.sql`.
- Do not rename the table or columns.
- Do not modify `test.sh`.
- Do not modify the GitHub Actions workflow.
- SQL keywords may be written in upper or lower case.
- The autograder creates a fresh `CollegeDB` database before testing.

## Expected Structure
```text
.
├── README.md
├── student_solution.sql
├── test.sh
└── .github/
    └── workflows/
        └── autograding.yml
```
