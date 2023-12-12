IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'project_dimension' AND type = 'U')
BEGIN
    CREATE TABLE project_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL,
        start DATE NOT NULL,
        finish DATE NOT NULL,
        status VARCHAR(255) NOT NULL
    );
END

-- Create the time_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'time_dimension' AND type = 'U')
BEGIN
    CREATE TABLE time_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        day INT NOT NULL,
        month INT NOT NULL,
        quarter INT NOT NULL,
        year INT NOT NULL
    );
END

-- Create the task_dimension table

-- Modify the fact_project_progress table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_project_progress' AND type = 'U')
BEGIN
    CREATE TABLE fact_project_progress (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id),
        time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES time_dimension(id),
        task_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES task_dimension(id),
        functionality_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES functionality_dimension(id),
        hours_spent INT NOT NULL,
        progress INT NOT NULL
    );
END


-- (fact_project_delays)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'task_dimension' AND type = 'U')
BEGIN
    CREATE TABLE task_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL,
        estimated_hours INT NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'functionality_dimension' AND type = 'U')
BEGIN
    CREATE TABLE functionality_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL
    );
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_project_delays' AND type = 'U')
BEGIN
    CREATE TABLE fact_project_delays (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id),
        time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES time_dimension(id),
        task_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES task_dimension(id),
        functionality_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES functionality_dimension(id),
        hours_spent INT NOT NULL,
        progress INT NOT NULL
    );
END

-- END FACT TABLES PROJECT_MANAGEMENT


-- START FACT TABLES SALES
-- (fact_sales)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'customer_dimension' AND type = 'U')
BEGIN
    CREATE TABLE customer_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL,
        country VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        phone VARCHAR(255) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'product_dimension' AND type = 'U')
BEGIN
    CREATE TABLE product_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL,
        price DECIMAL(10,2) NOT NULL
    );
END


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_sales' AND type = 'U')
BEGIN
    CREATE TABLE fact_sales (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        customer_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES customer_dimension(id),
        product_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES product_dimension(id),
        time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES time_dimension(id),
        quantity INT NOT NULL,
        total DECIMAL(10,2) NOT NULL
    );
END

-- END FACT TABLES SALES

-- START FACT TABLES FACTORY - SOFTWARE DEVELOPMENT
-- (fact_developed_functionalities)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'functionality_development_time' AND type = 'U')
BEGIN
    CREATE TABLE functionality_development_time (
        functionality_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES functionality_dimension(id),
        development_time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES development_time_dimension(id),
        hours INT NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'development_time_dimension' AND type = 'U')
BEGIN
    CREATE TABLE development_time_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        status VARCHAR(255) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_developed_functionalities' AND type = 'U')
BEGIN
    CREATE TABLE fact_developed_functionalities (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id),
        functionality_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES functionality_dimension(id),
        employee_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        development_time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES development_time_dimension(id),
        hours_spent INT NOT NULL
    );
END

-- (fact_time_spent_in_functionalities)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_time_spent_in_functionalities' AND type = 'U')
BEGIN
    CREATE TABLE fact_time_spent_in_functionalities (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id),
        functionality_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES functionality_dimension(id),
        employee_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        development_time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES development_time_dimension(id),
        hours_spent INT NOT NULL
    );
END


-- END FACT TABLES FACTORY - SOFTWARE DEVELOPMENT

-- START FACT TABLES HUMAN RESOURCES
-- (fact_performance_reviews)


IF EXISTS (SELECT * FROM sys.tables WHERE name = 'performance_review_dimension' AND type = 'U')
BEGIN
    CREATE TABLE performance_review_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        reviewer_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        date DATE NOT NULL,
        status VARCHAR(255) NOT NULL.
        score INT NOT NULL
    );
END


-- Create the employee_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employee_dimension' AND type = 'U')
BEGIN
    CREATE TABLE employee_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        names VARCHAR(255) NOT NULL,
        surnames VARCHAR(255) NOT NULL,
        birth_date DATE NOT NULL,
        email VARCHAR(255) NOT NULL,
        phone VARCHAR(255) NOT NULL,
        position VARCHAR(255) NOT NULL,
        salary DECIMAL(10,2) NOT NULL,
        hiring_date DATE NOT NULL,
        termination_date DATE NULL,
        relationship_end INT NULL
    );
END

-- Create the performance_review_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'performance_review_dimension' AND type = 'U')
BEGIN
    CREATE TABLE performance_review_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        reviewer_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        date DATE NOT NULL,
        status VARCHAR(255) NOT NULL.
        score INT NOT NULL
    );
END

-- Create the fact_performance_reviews table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_performance_reviews' AND type = 'U')
BEGIN
    CREATE TABLE fact_performance_reviews (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        reviewer_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES employee_dimension(id),
        performance_review_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES performance_review_dimension(id),
        date DATE NOT NULL,
        status VARCHAR(255) NOT NULL,
        score INT NOT NULL,
        avg_score INT NOT NULL
    );
END

-- END FACT TABLES HUMAN RESOURCES

-- START FACT TABLES FINANCES
-- (fact_profit_loss)

-- Create the revenue_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'revenue_dimension' AND type = 'U')
BEGIN
    CREATE TABLE revenue_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        revenue_amount DECIMAL(10,2) NOT NULL,
        revenue_date DATE NOT NULL
    );
END

-- Create the expense_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'expense_dimension' AND type = 'U')
BEGIN
    CREATE TABLE expense_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        amount DECIMAL(10,2) NOT NULL,
        expense_date DATE NOT NULL
    );
END

-- Create the time_dimension table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'time_dimension' AND type = 'U')
BEGIN
    CREATE TABLE time_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        day INT NOT NULL,
        month INT NOT NULL,
        quarter INT NOT NULL,
        year INT NOT NULL
    );
END

-- Create the fact_profit_loss table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_profit_loss' AND type = 'U')
BEGIN
    CREATE TABLE fact_profit_loss (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        revenue_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES revenue_dimension(id),
        expense_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES expense_dimension(id),
        time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES time_dimension(id),
        profit_loss_amount DECIMAL(10,2) NOT NULL,
        profit_loss_date DATE NOT NULL
    );
END

-- END FACT TABLES FINANCES

-- START FACT TABLES SUPPORT AND MAINTENANCE
-- (fact_created_support_tickets)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'support_ticket_dimension' AND type = 'U')
BEGIN
    CREATE TABLE support_ticket_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        customer_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES customer_dimension(id),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id),
        description VARCHAR(255) NOT NULL,
        priority VARCHAR(255) NOT NULL,
        status VARCHAR(255) NOT NULL,
        creation DATE NOT NULL,
        category VARCHAR(255) NOT NULL,
        closure DATE NULL,
        customer_satisfaction INT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_created_support_tickets' AND type = 'U')
BEGIN
    CREATE TABLE fact_created_support_tickets (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES project_dimension(id), 
        support_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES support_dimension(id),
        time_id uniqueidentifier NOT NULL FOREIGN KEY REFERENCES time_dimension(id),
        total_tickets INT NOT NULL,
        time_spent DECIMAL(10,2) NOT NULL
    );
END

-- END FACT TABLES SUPPORT AND MAINTENANCE

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'development_time_dimension' AND type = 'U')
BEGIN
    CREATE TABLE development_time_dimension (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        status VARCHAR(255) NOT NULL,
        functionality_id uniqueidentifier NOT NULL,
        employee_id uniqueidentifier NOT NULL,
        CONSTRAINT fk development_time_functionality_id FOREIGN KEY (functionality_id) REFERENCES functionality_dimension(id),
        CONSTRAINT fk development_time_employee_id FOREIGN KEY (employee_id) REFERENCES employee_dimension(id)
    );
END