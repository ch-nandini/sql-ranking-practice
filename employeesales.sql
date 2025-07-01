insert into employee_sales.employeesales (emp_id, emp_name, department, sale_month, sales_amount)
values  (1, 'Alice', 'Electronics', '2024-01', 5000),
        (2, 'Bob', 'Electronics', '2024-01', 6000),
        (3, 'Charlie', 'Electronics', '2024-01', 6000),
        (4, 'David', 'Clothing', '2024-01', 4500),
        (5, 'Eva', 'Clothing', '2024-01', 4000),
        (6, 'Frank', 'Clothing', '2024-01', 4500),
        (7, 'Grace', 'Electronics', '2024-02', 7000),
        (8, 'Heidi', 'Clothing', '2024-02', 5000),
        (9, 'Ivan', 'Clothing', '2024-02', 5200),
        (10, 'Judy', 'Electronics', '2024-02', 6800);


SELECT *
FROM EmployeeSales;

# Assign a rank to each employee based on their sales in January 2024.
SELECT emp_id, emp_name, sale_month, sales_amount,
       RANK() OVER(ORDER BY sales_amount DESC) as sales_rank
from EmployeeSales
where sale_month = "2024-01";

# Show the rank of employees within their department based on sales.
SELECT emp_id, emp_name, department, sales_amount,
       RANK() OVER(PARTITION BY department ORDER BY sales_amount DESC) AS dept_rank
from Employeesales
where sale_month = "2024-01";

# Use ROW_NUMBER() instead of RANK() and explain the difference.
#ROW_NUMBER() always gives a unique number (1, 2, 3...) — no skips, no duplicates, even if two people have the same sales_amount, they’ll get different numbers.
SELECT emp_id, emp_name, department, sales_amount,
       ROW_NUMBER() OVER(PARTITION BY department ORDER BY sales_amount DESC) AS dept_rank
from Employeesales
where sale_month = "2024-01";

# Use DENSE_RANK() to remove gaps in ranks.
SELECT emp_id, emp_name, department, sales_amount,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY sales_amount DESC) AS ranking
FROM EmployeeSales
WHERE sale_month = '2024-01';

# Show top 2 employees by sales (across all departments) in January 2024.
with ranked as (
    select emp_id, emp_name, sales_amount,
       rank() over(order by sales_amount desc) as rnk
    from employeesales
    where sale_month = '2024-01'
)
select *
from ranked
where rnk <= 2;

# Show the second highest salesperson overall for January 2024.

with ranked as(
    select emp_id, emp_name, sales_amount,
       DENSE_RANK() over(order by sales_amount desc) as 2nd_rank
    from employeesales
    where sale_month = '2024-01'
)
select *
from ranked
where 2nd_rank = 2;

# For each department and month, show the employee who had the highest sales (tie-break with ROW_NUMBER()).
with ranked as(
    select *,
       row_number() over(partition by department, sale_month order by sales_amount desc) as rn
    from employeesales
)
select *
from ranked
where rn = 1;

# Show employees whose rank differs between RANK() and DENSE_RANK() in January 2024.
WITH Ranks AS (
Select emp_id, emp_name, department, sales_amount,
       rank() over(partition by department order by sales_amount desc) as rn,
       dense_rank() over(partition by department order by sales_amount desc) as dn_rn
From employeesales
where sale_month = '2024-01'
)

Select *
From Ranks
where rn != dn_rn;

# Find the monthly department-wise rank change for each employee compared to the previous month.

with monthlysales as(
select *,
       rank() over(partition by department, sale_month order by sales_amount desc) as dept_rank
from employeesales
),
rankdiff as(
    select a.emp_id, a.emp_name, a.department,
           a.sale_month as current_month,
           b.sale_month as prev_month,
           a.dept_rank as current_rank,
           b.dept_rank as prev_rank,
           (b.dept_rank-a.dept_rank) as rank_change
    from monthlysales a
    join monthlysales b
    on a.emp_id = b.emp_id
    and a.department = b.department
    and a.sale_month = '2024-02'
    and b.sale_month = '2024-01'
)
select *
from rankdiff;

