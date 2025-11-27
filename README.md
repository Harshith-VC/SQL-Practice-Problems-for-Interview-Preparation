# SQL Functions & Reference Guide

## 📋 Table of Contents
- [What is SQL?](#what-is-sql)
- [SQL Functions](#sql-functions)
  - [Aggregate Functions](#aggregate-functions)
  - [String/Text Functions](#stringtext-functions)
  - [Numeric/Math Functions](#numericmath-functions)
  - [Date and Time Functions](#date-and-time-functions)
  - [Conversion Functions](#conversion-functions)
  - [Null Handling Functions](#null-handling-functions)
  - [Window Functions](#window-functions)
  - [User Defined Functions](#user-defined-functions)
- [SQL Query Processing Order](#sql-query-processing-order)
- [SQL Constraints](#sql-constraints)

---

## What is SQL?

SQL stands for Structured Query Language.  
It is a domain specific programming language that is used to manage and manipulate data stored in relational database management systems.  
SQL helps you query data, insert new records, update existing information and control access to the database.

---

## 🗂️ SQL Functions

### Aggregate Functions

| Function name | What it does |
|--------------|--------------|
| COUNT | Returns count of rows that match a rule |
| SUM | Returns total of numeric values |
| AVG | Returns average of numeric values |
| MIN | Returns the smallest value in a column |
| MAX | Returns the largest value in a column |
| GROUPING | Identifies grouped data when using roll up or cube |

---

### String/Text Functions

| Function name | What it does |
|--------------|--------------|
| UPPER | Converts text to upper case |
| LOWER | Converts text to lower case |
| LENGTH | Returns the count of characters |
| CONCAT | Joins multiple strings |
| SUBSTRING | Extracts part of a string |
| TRIM | Removes leading and trailing spaces |
| REPLACE | Replaces character or text within a string |

---

### Numeric/Math Functions

| Function name | What it does |
|--------------|--------------|
| ROUND | Rounds a number with chosen precision |
| ABS | Returns absolute positive value |
| CEILING | Rounds a number up to nearest whole number |
| FLOOR | Rounds a number down to nearest whole number |
| POWER | Raises a number to a specified power |
| SQRT | Returns square root of a number |
| MOD | Returns remainder of a division |

---

### Date and Time Functions

| Function name | What it does | Complete syntax with parameters |
|--------------|--------------|--------------------------------|
| NOW | Returns current system date and time | NOW() |
| GETDATE | Returns current date and time in SQL Server | GETDATE() |
| CURRENT DATE | Returns current date only | CURRENT_DATE |
| CURRENT TIME | Returns current time only | CURRENT_TIME |
| CURDATE | Returns current date in MySQL | CURDATE() |
| CURTIME | Returns current time in MySQL | CURTIME() |
| SYSDATE | Returns system clock date and time | SYSDATE() |
| DATEDIFF | Returns difference between two dates | DATEDIFF(end_date, start_date) MySQL version  or  DATEDIFF(datepart, start_date, end_date) SQL Server version |
| TIMESTAMPDIFF | Difference between timestamps with a unit | TIMESTAMPDIFF(unit, start_date, end_date) |
| DATEADD | Adds time interval to a date | DATEADD(unit, number_to_add, base_date) |
| ADDDATE | Adds days or interval to a date | ADDDATE(base_date, INTERVAL number unit) |
| EXTRACT or DATEPART | Extracts a specific part such as year | EXTRACT(part FROM date_value) or DATEPART(part, date_value) |
| YEAR | Extracts year | YEAR(date_value) |
| MONTH | Extracts month number | MONTH(date_value) |
| DAY | Extracts day of month | DAY(date_value) |
| MONTHNAME | Returns month name | MONTHNAME(date_value) |
| DAYNAME | Returns weekday name | DAYNAME(date_value) |
| EOMONTH | Returns last day of month | EOMONTH(date_value) |
| LAST DAY | Returns last day of month Oracle style | LAST_DAY(date_value) |
| MAKEDATE | Creates date using year and day number | MAKEDATE(year_value, day_of_year) |
| MAKETIME | Creates time using hour minute second | MAKETIME(hour_value, minute_value, second_value) |
| TIMESTAMP | Converts value to timestamp | TIMESTAMP(date_value, optional_time_value) |
| STR TO DATE | Parses string to date using format | STR_TO_DATE(text_value, format_pattern) |

---

### Conversion Functions

| Function name | What it does |
|--------------|--------------|
| CAST | Converts data type of a value |
| CONVERT | Converts data type with formatting support |
| PARSE | Converts from string to date or number format |
| FORMAT | Formats numbers or dates as text |

---

### Null Handling Functions

| Function name | What it does |
|--------------|--------------|
| COALESCE | Returns first non null value |
| NULLIF | Returns null if two values are equal |
| ISNULL or NVL | Replaces null with given value |

---

### Window Functions

| Function name | What it does |
|--------------|--------------|
| ROW NUMBER | Returns unique sequence number per row |
| RANK | Ranking with gaps for ties |
| DENSE RANK | Ranking without gaps in ties |
| NTILE | Divides rows into equal logical groups |
| LAG | Reads earlier row value in sequence |
| LEAD | Reads next row value in sequence |
| FIRST VALUE | Returns first value in window |
| LAST VALUE | Returns last value in window |
| CUME DIST | Returns cumulative distribution value |
| PERCENT RANK | Returns rank percentage value |

---

### User Defined Functions

| Function name | What it does |
|--------------|--------------|
| Scalar UDF | Returns a single value from logic |
| Table UDF | Returns a full table result |

---

## 🔄 SQL Query Processing Order

Understanding the logical order in which SQL processes queries helps you write more efficient code.

| Step | Clause      | What it does                                        |
|-----:|-------------|----------------------------------------------------|
| 1    | FROM        | Reads data from the source tables                  |
| 2    | JOIN        | Combines data from related tables                  |
| 3    | WHERE       | Filters rows before grouping                       |
| 4    | GROUP BY    | Groups rows based on shared values                 |
| 5    | HAVING      | Filters grouped records using aggregated data     |
| 6    | SELECT      | Chooses columns or expressions for output         |
| 7    | DISTINCT    | Removes duplicate rows from the result            |
| 8    | ORDER BY    | Sorts the final output                            |
| 9    | LIMIT       | Restricts number of rows returned                 |
| 10   | OFFSET      | Skips rows before applying the limit              |

---

## 🔒 SQL Constraints

Constraints are rules applied on columns or tables to protect data accuracy and consistency.

| Constraint name | What it ensures |
|----------------|----------------|
| NOT NULL | A column cannot store a null value |
| UNIQUE | All values in a column are different |
| PRIMARY KEY | Combination of not null and unique to identify each row in a table |
| FOREIGN KEY | Maintains valid links between tables and protects relational integrity |
| CHECK | Values in a column must satisfy a rule or condition |
| DEFAULT | Automatically assigns a value when no value is given |
| CREATE INDEX | Improves speed of searching and reading data |

---

## 📝 Notes

- This guide covers the most commonly used SQL functions across different database systems
- Syntax may vary slightly between SQL Server, MySQL, PostgreSQL, and Oracle
- Always refer to your specific database documentation for exact syntax and available functions
