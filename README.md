# SQL Ranking Practice

This repository contains a collection of SQL queries focused on ranking functions using the `EmployeeSales` table. It is designed to help practice and understand various window functions like `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`.

## 🧾 Table Used
Assumes a sample table named `EmployeeSales` with the following structure:

- `emp_id`
- `emp_name`
- `department`
- `sale_month`
- `sales_amount`

## 📌 Topics Covered

- Basic ranking with `RANK()`
- Department-wise ranking using `PARTITION BY`
- Difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()`
- Top-N queries
- Monthly rank comparison
- Ties and unique row rankings
- Using CTEs for readable query structures

## 📂 File: rank_practice.sql

All SQL queries are written in one file and commented for clarity.

## 🔧 Requirements

- MySQL 8.0+ (tested on 8.0.42)
- Any SQL editor like MySQL Workbench, DBeaver, DataGrip, or command-line


