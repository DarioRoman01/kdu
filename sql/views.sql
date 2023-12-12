CREATE VIEW IF NOT EXISTS project_progress_view
AS
SELECT (
    fact_project_progress.hours_spent,
    fact_project_progress.progress,
    project_dimension.name,
    task_dimension.name,
    functionality_dimension.name,
    time_dimension.date
) FROM fact_project_progress
INNER JOIN project_dimension ON fact_project_progress.project_id = project_dimension.id
INNER JOIN task_dimension ON fact_project_progress.task_id = task_dimension.id
INNER JOIN functionality_dimension ON fact_project_progress.functionality_id = functionality_dimension.id
INNER JOIN time_dimension ON fact_project_progress.time_id = time_dimension.id


CREATE VIEW IF NOT EXISTS project_delays_view
WITH PARAMS (
    year INT,
    month INT,
    country VARCHAR(255),
    position VARCHAR(255)
) AS
SELECT (
    fact_project_delays.hours_spent,
    fact_project_delays.progress,
    project_dimension.name,
    task_dimension.name,
    functionality_dimension.name,
    time_dimension.date
) FROM fact_project_delays
INNER JOIN project_dimension ON fact_project_delays.project_id = project_dimension.id
INNER JOIN task_dimension ON fact_project_delays.task_id = task_dimension.id
INNER JOIN functionality_dimension ON fact_project_delays.functionality_id = functionality_dimension.id
INNER JOIN time_dimension ON fact_project_delays.time_id = time_dimension.id
WHERE time_dimension.year = @year AND time_dimension.month = @month AND employee_dimension.country = @country AND employee_dimension.position = @position;

CREATE VIEW IF NOT EXISTS sales_view
WITH PARAMS (
    year INT,
    month INT,
    country VARCHAR(255),
    product VARCHAR(255)
) AS
SELECT (
    fact_sales.quantity,
    fact_sales.total,
    customer_dimension.name,
    product_dimension.name,
    time_dimension.date
) FROM fact_sales
INNER JOIN customer_dimension ON fact_sales.customer_id = customer_dimension.id
INNER JOIN product_dimension ON fact_sales.product_id = product_dimension.id
INNER JOIN time_dimension ON fact_sales.time_id = time_dimension.id
WHERE time_dimension.year = @year AND time_dimension.month = @month AND customer_dimension.country = @country AND product_dimension.name = @product;

CREATE VIEW IF NOT EXISTS functionality_time_spent_view
WITH PARAMS (
    status VARCHAR(255),
    year INT,
    month INT,
    country VARCHAR(255),
    position VARCHAR(255)
) AS
SELECT (
    fact_functionality_time_spent.hours_spent,
    project_dimension.name,
    functionality_dimension.name,
    employee_dimension.name,
    development_time_dimension.status
) FROM fact_functionality_time_spent
INNER JOIN project_dimension ON fact_functionality_time_spent.project_id = project_dimension.id
INNER JOIN functionality_dimension ON fact_functionality_time_spent.functionality_id = functionality_dimension.id
INNER JOIN employee_dimension ON fact_functionality_time_spent.employee_id = employee_dimension.id
INNER JOIN development_time_dimension ON fact_functionality_time_spent.development_time_id = development_time_dimension.id
WHERE project_dimension.status = @status AND time_dimension.year = @year AND time_dimension.month = @month AND customer_dimension.country = @country AND employee_dimension.position = @position;


CREATE VIEW IF NOT EXISTS performance_reviews_view
WITH PARAMS (
    year INT,
    month INT,
    country VARCHAR(255),
    position VARCHAR(255)
) AS
SELECT (
    fact_performance_reviews.avg_score,
    fact_performance_reviews.score,
    employee_dimension.name,
    employee_dimension.surname,
    time_dimension.date
) FROM fact_performance_reviews
INNER JOIN employee_dimension ON fact_performance_reviews.employee_id = employee_dimension.id
INNER JOIN time_dimension ON fact_performance_reviews.time_id = time_dimension.id
WHERE time_dimension.year = @year AND time_dimension.month = @month AND employee_dimension.country = @country AND employee_dimension.position = @position;

CREATE VIEW IF NOT EXISTS profit_loss_view
WITH PARAMS (
    year INT,
    month INT,
    country VARCHAR(255),
    position VARCHAR(255)
) AS
SELECT (
    fact_profit_loss.profit_loss_amount,
    fact_profit_loss.profit_loss_date,
    revenue_dimension.revenue_amount,
    expense_dimension.amount,
    time_dimension.date
) FROM fact_profit_loss
INNER JOIN revenue_dimension ON fact_profit_loss.revenue_id = revenue_dimension.id
INNER JOIN expense_dimension ON fact_profit_loss.expense_id = expense_dimension.id
INNER JOIN time_dimension ON fact_profit_loss.time_id = time_dimension.id
WHERE time_dimension.year = @year AND time_dimension.month = @month AND employee_dimension.country = @country AND employee_dimension.position = @position;

CREATE VIEW IF NOT EXISTS support_tickets_view
WITH PARAMS (
    status VARCHAR(255),
    year INT,
    month INT,
    country VARCHAR(255),
    position VARCHAR(255)
) AS

SELECT (
    fact_created_support_tickets.total_tickets,
    fact_created_support_tickets.time_spent,
    project_dimension.name,
    support_ticket_dimension.description,
    time_dimension.date,
    customer_dimension.name,
    employee_dimension.names 
) FROM fact_created_support_tickets
INNER JOIN project_dimension ON fact_created_support_tickets.project_id = project_dimension.id
INNER JOIN support_ticket_dimension ON fact_created_support_tickets.support_id = support_ticket_dimension.id
INNER JOIN time_dimension ON fact_created_support_tickets.time_id = time_dimension.id
INNER JOIN customer_dimension ON support_ticket_dimension.customer_id = customer_dimension.id
INNER JOIN employee_dimension ON support_ticket_dimension.employee_id = employee_dimension.id
WHERE project_dimension.status = @status AND time_dimension.year = @year AND time_dimension.month = @month AND customer_dimension.country = @country AND employee_dimension.position = @position;

SELECT (
    fact_system_downtime.downtime_amount,
    fact_system_downtime.downtime_date,
    system_dimension.system_name,
    system_dimension.system_type,
    system_dimension.system_version,
    employee_dimension.name,
    employee_dimension.surname,
    time_dimension.date
) FROM fact_system_downtime
INNER JOIN system_dimension ON fact_system_downtime.system_id = system_dimension.id
INNER JOIN employee_dimension ON fact_system_downtime.employee_id = employee_dimension.id
INNER JOIN time_dimension ON fact_system_downtime.time_id = time_dimension.id
WHERE time_dimension.year = @year AND time_dimension.month = @month AND employee_dimension.country = @country AND employee_dimension.position = @position;