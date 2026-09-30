# SQL Solutions

## 1- Create tables

```sql
CREATE TABLE Gender (
    Gender_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL
);

CREATE TABLE University (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL
);

CREATE TABLE MyDepartment (
    Dept_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL
);

CREATE TABLE MyEmployee (
    ID NUMBER PRIMARY KEY,
    LAST_NAME VARCHAR2(50) NOT NULL,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    HIRE_DATE DATE NOT NULL,
    USERID NUMBER NOT NULL,
    SALARY NUMBER CHECK (SALARY > 0),
    DEPT_ID NUMBER REFERENCES MyDepartment(Dept_ID),
    Gender_ID NUMBER REFERENCES Gender(Gender_ID),
    University_ID NUMBER REFERENCES University(ID),
    EMP_IMAGE BLOB,
    MANAGER_ID NUMBER REFERENCES MyEmployee(ID),
    JOB_TITLE VARCHAR2(50)
);
```

I added MANAGER_ID and JOB_TITLE because Q2 and Q3 need them.

## 2- Employee details

```sql
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS Employee_Name,
       e.SALARY,
       d.Name AS Department,
       m.FIRST_NAME || ' ' || m.LAST_NAME AS Manager,
       g.Name AS Gender,
       u.Name AS University
FROM MyEmployee e
JOIN MyDepartment d ON e.DEPT_ID = d.Dept_ID
JOIN Gender g ON e.Gender_ID = g.Gender_ID
JOIN University u ON e.University_ID = u.ID
LEFT JOIN MyEmployee m ON e.MANAGER_ID = m.ID;
```

## 3- Total salary per job title

```sql
SELECT JOB_TITLE, SUM(SALARY) AS Total_Salary
FROM MyEmployee
WHERE JOB_TITLE <> 'SALES'
GROUP BY JOB_TITLE
HAVING SUM(SALARY) > 2500;
```

## 4- Errors in the statement
```sql
SELECT empno, ename,
salary x 12 ANNUAL SALARY; FROM emp;
```

1. The table name is `MyEmployee`, not `emp`, and the column names are `ID`, `FIRST_NAME`, and `LAST_NAME`, not `empno` and `ename`.
2. Multiplication is `*`, not `x`.
3. The alias has a space, so it needs double quotes: `"ANNUAL SALARY"`.
4. The `;` before FROM is wrong, the semicolon goes at the end.

Correct version:

```sql
SELECT ID, FIRST_NAME, LAST_NAME, SALARY * 12 "ANNUAL SALARY"
FROM MyEmployee;
```
## 5- Function F_HR_QUERY

Test data:

```sql
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY)
VALUES (1, 'Scott', 'SCOTT', TO_DATE('09/09/1987', 'DD/MM/YYYY'), 1, 1000);

INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY)
VALUES (2, 'Ali', 'Ahmad', TO_DATE('10/10/1980', 'DD/MM/YYYY'), 2, 1000);

INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY)
VALUES (3, 'Khaled', 'Rami', TO_DATE('24/05/1986', 'DD/MM/YYYY'), 3, 1000);

-- hired after SCOTT, so the function has a result
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY)
VALUES (4, 'Saleh', 'Laila', TO_DATE('01/03/1990', 'DD/MM/YYYY'), 4, 1000);

COMMIT;
```

Function:

```sql
CREATE OR REPLACE FUNCTION F_HR_QUERY RETURN NUMBER IS
    v_date DATE;
    v_count NUMBER := 0;
BEGIN
    SELECT HIRE_DATE INTO v_date
    FROM MyEmployee
    WHERE FIRST_NAME = 'SCOTT';

    FOR emp IN (SELECT FIRST_NAME, HIRE_DATE
                FROM MyEmployee
                WHERE HIRE_DATE > v_date) LOOP
        DBMS_OUTPUT.PUT_LINE(emp.FIRST_NAME || ' - ' || emp.HIRE_DATE);
        v_count := v_count + 1;
    END LOOP;

    RETURN v_count;
END;
/
```

Run it:

```sql
SET SERVEROUTPUT ON
DECLARE
    n NUMBER;
BEGIN
    n := F_HR_QUERY;
END;
/
```

## 6- Procedure P_COPY_EMPLOYEE

```sql
CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE IS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE MyEmployee_update AS SELECT * FROM MyEmployee';
END;
/
```

Run it:

```sql
EXEC P_COPY_EMPLOYEE;
SELECT * FROM MyEmployee_update;
```
