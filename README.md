````markdown
# Student Table Assignment

## Objective

Create a database table named `Student` using SQL.

---

## Table Requirements

Create the following table:

| Field | Data Type | Constraint |
|---|---|---|
| StudentID | NUMBER(5) | PRIMARY KEY |
| StudentName | VARCHAR(20) | NOT NULL, UNIQUE |
| DOB | DATE | NOT NULL |
| Gender | VARCHAR(10) | NOT NULL |
| DepartmentID | NUMBER(5) | NOT NULL |

---

## Task

Create a table named:

```text
Student
````

The table must contain exactly five columns:

```text
StudentID
StudentName
DOB
Gender
DepartmentID
```

---

## Constraints

### PRIMARY KEY

`StudentID` must be the PRIMARY KEY.

Example:

```sql
StudentID INTEGER PRIMARY KEY
```

---

### NOT NULL

The following columns must have NOT NULL constraints:

```text
StudentName
DOB
Gender
DepartmentID
```

---

### UNIQUE

`StudentName` must have a UNIQUE constraint.

This means two students cannot have the same name.

---

## File to Edit

Write your SQL code in:

```text
starter.sql
```

Do not rename the file.

---

## Example

The following shows the expected SQL structure.

```sql
CREATE TABLE Student (
    StudentID INTEGER PRIMARY KEY,
    StudentName VARCHAR(20) NOT NULL UNIQUE,
    DOB DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    DepartmentID INTEGER NOT NULL
);
```

### Important

The example above is provided for learning purposes.

Write your own SQL statement in `starter.sql`.

---

# Submission Procedure

## Step 1

Open your GitHub assignment repository.

## Step 2

Open:

```text
starter.sql
```

## Step 3

Write your CREATE TABLE statement.

## Step 4

Commit your changes.

Suggested commit message:

```text
Completed Student Table Assignment
```

## Step 5

Go to:

```text
Actions
```

GitHub Actions will automatically run the tests.

---

# Automated Testing

The system checks:

* Student table exists
* Exactly five columns exist
* StudentID exists
* StudentName exists
* DOB exists
* Gender exists
* DepartmentID exists
* StudentID is PRIMARY KEY
* StudentName is NOT NULL
* DOB is NOT NULL
* Gender is NOT NULL
* DepartmentID is NOT NULL
* StudentName is UNIQUE
* Duplicate StudentID is rejected
* NULL StudentName is rejected

---

# Result

If your assignment is correct, GitHub Actions will display:

```text
ALL TESTS PASSED!

Student table assignment completed successfully.
```

A green tick means the assignment passed.

A red cross means one or more tests failed.

---

# Learning Outcomes

After completing this assignment, students will be able to:

1. Create a database table.
2. Define columns and data types.
3. Apply PRIMARY KEY constraints.
4. Apply UNIQUE constraints.
5. Apply NOT NULL constraints.
6. Understand database integrity constraints.
7. Use GitHub for SQL assignment submission.
8. Understand automated testing using GitHub Actions.

```
```
