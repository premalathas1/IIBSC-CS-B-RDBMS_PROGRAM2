CREATE TABLE Student(
   StudentID INT(5) primary key,
   StudentName VARCHAR(20) NOT NULL,
   DOB DATE default null,
   Gender VARCHAR(10) NOT NULL,
   DepartmentID  INT(5),
   CONSTRAINT UQ_StudentID UNIQUE(StudentID),CONSTRAINT FK_Student_DepartmentID FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);
DESC Student;
SELECT*FROM Student;
