IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'project_type' AND type = 'U')
BEGIN
    CREATE TABLE project_type (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(MAX) NOT NULL,
        description NVARCHAR(MAX) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'status' AND type = 'U')
BEGIN
    CREATE TABLE status (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(MAX) NOT NULL,
        description NVARCHAR(MAX) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'project' AND type = 'U')
BEGIN
    CREATE TABLE project (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(MAX) NOT NULL,
        start DATE NOT NULL DEFAULT GETDATE(),
        finish DATE,
        status_id uniqueidentifier NOT NULL,
        type_id uniqueidentifier NOT NULL,
        CONSTRAINT fk_project_status_id FOREIGN KEY (status_id) REFERENCES status(id),
        CONSTRAINT fk_project_type_id FOREIGN KEY (type_id) REFERENCES project_type(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employee_role' AND type = 'U')
BEGIN
    CREATE TABLE employee_role (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(30) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'functionality_type' AND type = 'U')
BEGIN
    CREATE TABLE functionality_type (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(50) NOT NULL,
        description NVARCHAR(MAX) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'functionality' AND type = 'U')
BEGIN
    CREATE TABLE functionality (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        status_id uniqueidentifier NOT NULL,
        type_id uniqueidentifier NOT NULL,
        title NVARCHAR(50) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        CONSTRAINT fk_functionality_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_functionality_status_id FOREIGN KEY (status_id) REFERENCES status(id),
        CONSTRAINT fk_functionality_type_id FOREIGN KEY (type_id) REFERENCES functionality_type(id)
    );
END


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'error_severity' AND type = 'U')
BEGIN
    CREATE TABLE error_severity (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        title NVARCHAR(50) NOT NULL,
        description NVARCHAR(MAX) NOT NULL
    );
END



IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'errors' AND type = 'U')
BEGIN
    CREATE TABLE errors (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        functionality_id uniqueidentifier NOT NULL,
        severity_id uniqueidentifier NOT NULL,
        state_id uniqueidentifier NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        report_date DATE NOT NULL,
        resolution DATE,
        CONSTRAINT fk_error_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_error_functionality_id FOREIGN KEY (functionality_id) REFERENCES functionality(id),
        CONSTRAINT fk_error_severity_id FOREIGN KEY (severity_id) REFERENCES error_severity(id),
        CONSTRAINT fk_error_state_id FOREIGN KEY (state_id) REFERENCES status(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employee_position' AND type = 'U')
BEGIN
    CREATE TABLE employee_position (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(MAX)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employees' AND type = 'U')
BEGIN
    CREATE TABLE employees (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        names NVARCHAR(MAX) NOT NULL,
        last_names NVARCHAR(MAX) NOT NULL,
        birth NVARCHAR(MAX) NOT NULL,
        email NVARCHAR(320) NOT NULL,
        phone NVARCHAR(15) NOT NULL,
        position_id uniqueidentifier NOT NULL,
        salary DECIMAL(10,2) NOT NULL,
        hiring DATE NOT NULL,
        unlinking DATE,
        CONSTRAINT fk_employee_position_id FOREIGN KEY (position_id) REFERENCES employee_position(id),
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'vacations' AND type = 'U')
BEGIN
    CREATE TABLE vacations (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        state_id uniqueidentifier NOT NULL,
        start DATE NOT NULL,
        finish DATE NOT NULL,
        CONSTRAINT fk_vacations_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id),
        CONSTRAINT fk_vacations_state_id FOREIGN KEY (state_id) REFERENCES status(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'absence_type' AND type = 'U')
BEGIN
    CREATE TABLE absence_type (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(50) NOT NULL,
        description NVARCHAR(MAX) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'absence' AND type = 'U')
BEGIN
    CREATE TABLE absence (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        type_id uniqueidentifier NOT NULL,
        start DATE NOT NULL,
        finish DATE NOT NULL,
        CONSTRAINT fk_absence_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id),
        CONSTRAINT fk_absence_type_id FOREIGN KEY (type_id) REFERENCES absence_type(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'performance_evaluation' AND type = 'U')
BEGIN
    CREATE TABLE performance_evaluation (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        score INT NOt NULL
        CONSTRAINT fk_evaluation_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tasks' AND type = 'U')
BEGIN
    CREATE TABLE tasks (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        functionality_id uniqueidentifier NOT NULL,
        employee_id uniqueidentifier NOT NULL,
        title NVARCHAR(200) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        state_id uniqueidentifier NOT NULL,
        start DATE NOT NULL,
        estimation INT NOT NULL,
        finish DATE,
        CONSTRAINT fk_task_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_task_functionality_id FOREIGN KEY (functionality_id) REFERENCES functionality(id),
        CONSTRAINT fk_task_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client' AND type = 'U')
BEGIN
    CREATE TABLE client (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(200) NOT NULL,
        country NVARCHAR(20) NOT NULL,
        city NVARCHAR(100) NOT NULL,
        email NVARCHAR(200) NOT NULL,
        phone NVARCHAR(15) NOT NULL,
        start_relationship DATE NOT NULL,
        end_relationship DATE
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sales' AND type = 'U')
BEGIN
    CREATE TABLE sales (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        client_id uniqueidentifier NOT NULL,
        project_id uniqueidentifier NOT NULL,
        employee_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        amount DECIMAL(10, 2),
        CONSTRAINT fk_sale_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id),
        CONSTRAINT fk_sale_client_id FOREIGN KEY (client_id) REFERENCES client(id),
        CONSTRAINT fk_sale_project_id FOREIGN KEY (project_id) REFERENCES project(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sales_goals' AND type = 'U')
BEGIN
    CREATE TABLE sales_goals (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        year INT NOT NULL,
        month INT NOT NULL,
        goal DECIMAL(10, 2) NOT NULL,
        reached BIT NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tracking' AND type = 'U')
BEGIN
    CREATE TABLE tracking (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX) NOT NULl,
        date DATE NOT NULL,
        source NVARCHAR(50) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'outsourcing' AND type = 'U')
BEGIN
    CREATE TABLE outsourcing (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        client_id uniqueidentifier NOT NULL,
        start DATE NOT NULL,
        finish DATE,
        amount DECIMAL(10, 2) NOT NULL,
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'project_assignment' AND type = 'U')
BEGIN
    CREATE TABLE project_assignment (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        project_id uniqueidentifier NOT NULL,
        role_id uniqueidentifier NOT NULL,
        start DATE NOT NULL,
        finish DATE NOT NULL,
        CONSTRAINT fk_assignment_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id),
        CONSTRAINT fk_assignment_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_assignment_role_id FOREIGN KEY (role_id) REFERENCES employee_role(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client_project' AND type = 'U')
BEGIN
    CREATE TABLE client_project (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project uniqueidentifier NOT NULL,
        client uniqueidentifier NOT NULL,
        CONSTRAINT fk_client_project_id FOREIGN KEY (project) REFERENCES project(id)
        CONSTRAINT fk_client_project_client_id FOREIGN KEY (client) REFERENCES client(id)
    );
END


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'time_consulting' AND type = 'U')
BEGIN
    CREATE TABLE time_consulting (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        consultant_id uniqueidentifier NOT NULL,
        hours INT DEFAULT 0,
        start DATE NOT NULL,
        CONSTRAINT fk_consulting_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_consulting_employee_id FOREIGN KEY (consultant_id) REFERENCES employees(id)
    );
END



IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'development_time' AND type = 'U')
BEGIN
    CREATE TABLE development_time (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        task_id uniqueidentifier NOT NULL,
        functionality_id uniqueidentifier NOT NULL,
        employee_id uniqueidentifier NOT NULL,
        hours INT DEFAULT 0,
        CONSTRAINT fk_development_task_id FOREIGN KEY (task_id) REFERENCES tasks(id),
        CONSTRAINT fk_development_functionality_id FOREIGN KEY (functionality_id) REFERENCES functionality(id),
        CONSTRAINT fk_development_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'quality_audit' AND type = 'U')
BEGIN
    CREATE TABLE quality_audit (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        responsible_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        result NVARCHAR(MAX) NOT NULL,
        score INT NOT NULL,
        CONSTRAINT fk_audit_employee_id FOREIGN KEY (responsible_id) REFERENCES employees(id),
        CONSTRAINT fk_audit_project_id FOREIGN KEY (project_id) REFERENCES project(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'support_ticket' AND type = 'U')
BEGIN
    CREATE TABLE support_ticket (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        responsible_id uniqueidentifier NOT NULL,
        client_id uniqueidentifier NOT NULL,
        state_id uniqueidentifier NOT NULL,
        summary NVARCHAR(60) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        priority INT NOT NULL CHECK (priority > 0 AND priority < 6), -- from 1 to 5
        creation DATE NOT NULL,
        closure DATE,
        satisfaction INT NOT NULL CHECK (satisfaction > 0 AND satisfaction < 6), -- from 1 to 5,
        CONSTRAINT fk_support_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_support_client_id FOREIGN KEY (client_id) REFERENCES client(id),
        CONSTRAINT fk_support_employee_id FOREIGN KEY (responsible_id) REFERENCES employees(id),
        CONSTRAINT fk_support_state_id FOREIGN KEY (state_id) REFERENCES status(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client_feedback' AND type = 'U')
BEGIN
    CREATE TABLE client_feedback (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        client_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        satisfaction INT NOT NULL CHECK (satisfaction > 0 AND satisfaction < 6), -- from 1 to 5,
        CONSTRAINT fk_feedback_project_id FOREIGN KEY (project_id) REFERENCES project(id),
        CONSTRAINT fk_feedback_client_id FOREIGN KEY (client_id) REFERENCES client(id)
    );
END

-- END SUPPORT AND MAINTENANCE

-- START FINANCES

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'income' AND type = 'U')
BEGIN
    CREATE TABLE income (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        client_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        amount DECIMAL(10, 2) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        payment_method NVARCHAR(30) NOT NULL,
        CONSTRAINT fk_income_client_id FOREIGN KEY (client_id) REFERENCES client(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'expense' AND type = 'U')
BEGIN
    CREATE TABLE expense (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        concept NVARCHAR(50) NOT NULL,
        amount DECIMAL(10, 2) NOT NULL,
        date DATE NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'budget' AND type = 'U')
BEGIN
    CREATE TABLE budget (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        project_id uniqueidentifier NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        amount DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_budget_project_id FOREIGN KEY (project_id) REFERENCES project(id)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'payroll' AND type = 'U')
BEGIN
    CREATE TABLE payroll (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        employee_id uniqueidentifier NOT NULL,
        date DATE NOT NULL,
        amount DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_payroll_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id)
    );
END

-- END FINANCES

-- START COMMERCIAL

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client' AND type = 'U')
BEGIN
    CREATE TABLE client (
        id uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
        name NVARCHAR(200) NOT NULL,
        country NVARCHAR(20) NOT NULL,
        city NVARCHAR(100) NOT NULL,
        email NVARCHAR(200) NOT NULL,
        phone NVARCHAR(15) NOT NULL,
        start_relationship DATE NOT NULL,
        end_relationship DATE
    );
END
