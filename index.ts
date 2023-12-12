import { faker } from "@faker-js/faker";
import sql from "mssql";

const createSqlServerConnection = async () => {
  const conn = await sql.connect(
    `Server=tcp:kdu.database.windows.net,1433;Initial Catalog=kdu_warehouse;Persist Security Info=False;User ID=kduadmin;Password=Alienuwu241.;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;`
  );

  return conn;
};

const insertProjectStatus = async () => {
  const projectStatusNames = [
    "In Progress",
    "Completed",
    "On Hold",
    "Cancelled",
    "Not Started",
  ];

  projectStatusNames.forEach(async (name) => {
    await sql.query`INSERT INTO status (name, description) VALUES (${name}, ${faker.lorem.paragraph()})`;
  });
};

const insertProjectType = async () => {
  const projectTypeNames = [
    "Software",
    "Hardware",
    "Marketing",
    "Sales",
    "Design",
    "Research",
    "Development",
    "Testing",
    "Support",
    "Maintenance",
    "Training",
  ];

  projectTypeNames.forEach(async (name) => {
    await sql.query`INSERT INTO project_type (name, description) VALUES (${name}, ${faker.lorem.paragraph()})`;
  });
};

const insertProject = async () => {
  const validProjectStatus = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  const validProjectType = (await sql.query`SELECT id FROM project_type`)
    .recordset as Array<any>;

  for (let i = 0; i < 100; i++) {
    const name = faker.music.songName();
    const start = faker.date.past();
    const finish = faker.date.future();
    const status_id =
      validProjectStatus[Math.floor(Math.random() * validProjectStatus.length)]
        ?.id;
    const type_id =
      validProjectType[Math.floor(Math.random() * validProjectType.length)]?.id;

    await sql.query`INSERT INTO project (name, start, finish, status_id, type_id) VALUES (${name}, ${start}, ${finish}, ${status_id}, ${type_id})`;
  }
};

const insertFunctionalityType = async () => {
  const functionalityTypeNames = [
    "Feature",
    "Bug",
    "Improvement",
    "Epic",
    "Task",
    "Story",
  ];

  functionalityTypeNames.forEach(async (name) => {
    await sql.query`INSERT INTO functionality_type (name, description) VALUES (${name}, ${faker.lorem.paragraph()})`;
  });
};
const insertFunctionality = async () => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validFunctionalityStatus = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  const validFunctionalityType = (
    await sql.query`SELECT id FROM functionality_type`
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    for (let i = 0; i < 1000; i++) {
      const title = faker.git.branch();
      const description = faker.lorem.paragraph();
      const status_id =
        validFunctionalityStatus[
          Math.floor(Math.random() * validFunctionalityStatus.length)
        ]?.id;
      const type_id =
        validFunctionalityType[
          Math.floor(Math.random() * validFunctionalityType.length)
        ]?.id;

      await sql.query`INSERT INTO functionality (project_id, status_id, type_id, title, description) VALUES (${project.id}, ${status_id}, ${type_id}, ${title}, ${description})`;
    }
  });
};
const insertEmployeePosition = async () => {
  const employeePositionNames = [
    "Developer",
    "Designer",
    "Tester",
    "Manager",
    "Support",
    "Sales",
    "Marketing",
    "Researcher",
    "Human Resources",
    "Finance",
    "Accountant",
    "Lawyer",
    "Executive",
  ];

  employeePositionNames.forEach(async (name) => {
    await sql.query`INSERT INTO employee_position (name) VALUES (${name})`;
  });
};

const insertEmployee = async () => {
  const validEmployeePosition = (
    await sql.query`SELECT id FROM employee_position`
  ).recordset as Array<any>;

  for (let i = 0; i < 100; i++) {
    const names = faker.person.firstName();
    const last_names = faker.person.lastName();
    const birth = faker.date.past();
    const email = faker.internet.email();
    const phone = faker.phone.number().slice(0, 12);
    const position_id =
      validEmployeePosition[
        Math.floor(Math.random() * validEmployeePosition.length)
      ]?.id;

    const salary = faker.finance.amount(1000000, 10000000);
    const hiring = faker.date.past();
    const unlinking = faker.date.future();

    await sql.query`INSERT INTO employees (names, last_names, birth, email, phone, position_id, salary, hiring, unlinking) VALUES (${names}, ${last_names}, ${birth}, ${email}, ${phone}, ${position_id}, ${salary}, ${hiring}, ${unlinking})`;
  }
};

const insertEmployeeRole = async () => {
  const employeeRoleNames = [
    "Developer",
    "Team Leader",
    "Product Owner",
    "Scrum Master",
    "Tester",
    "Designer",
    "Support",
  ];

  employeeRoleNames.forEach(async (name) => {
    await sql.query`INSERT INTO employee_role (name, description) VALUES (${name}, ${faker.lorem.paragraph()})`;
  });
};

const insertProjectAssigment = async () => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validEmployeeRole = (await sql.query`SELECT id FROM employee_role`)
    .recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    validProject.forEach(async (project) => {
      for (let i = 0; i < 1000; i++) {
        const role_id =
          validEmployeeRole[
            Math.floor(Math.random() * validEmployeeRole.length)
          ]?.id;

        const start = faker.date.past();
        const finish = faker.date.future();

        await sql.query`INSERT INTO project_assignment (employee_id, project_id, role_id, start, finish) VALUES (${employee.id}, ${project.id}, ${role_id}, ${start}, ${finish})`;
      }
    });
  });
};

const insertTasks = async () => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validFunctionality = (await sql.query`SELECT * FROM functionality`)
    .recordset as Array<any>;

  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validTaskState = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    const functionalities = validFunctionality.filter(
      (f) => f.project_id === project.id
    );
    functionalities.forEach(async (functionality) => {
      for (let i = 0; i < 1000; i++) {
        const employee_id =
          validEmployee[Math.floor(Math.random() * validEmployee.length)]?.id;

        const title = faker.git.branch();
        const description = faker.lorem.paragraph();
        const state_id =
          validTaskState[Math.floor(Math.random() * validTaskState.length)]?.id;

        const start = faker.date.past();
        const estimation = faker.helpers.rangeToNumber({
          max: 21,
          min: 1,
        });

        const finish = faker.date.future();

        await sql.query`INSERT INTO tasks (project_id, functionality_id, employee_id, title, description, state_id, start, estimation, finish) VALUES (${project.id}, ${functionality.id}, ${employee_id}, ${title}, ${description}, ${state_id}, ${start}, ${estimation}, ${finish})`;
      }
    });
  });
};

const insertDevlopmentTime = async (conn: sql.ConnectionPool) => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validTask = (await sql.query`SELECT id, functionality_id FROM tasks`)
    .recordset as Array<any>;

  let query =
    "insert into development_time (task_id, functionality_id, employee_id, hours) values ";

  const batchSize = 100;
  const taskBatches = [];
  for (let i = 0; i < validTask.length; i += batchSize) {
    taskBatches.push(validTask.slice(i, i + batchSize));
  }

  for (let batch of taskBatches) {
    query =
      "insert into development_time (task_id, functionality_id, employee_id, hours) values ";
    for (let task of batch) {
      const employee_id =
        validEmployee[Math.floor(Math.random() * validEmployee.length)]?.id;

      const hours = faker.helpers.rangeToNumber({
        max: 100,
        min: 1,
      });

      query += `('${task.id}', '${task.functionality_id}', '${employee_id}', ${hours}),`;
    }

    query = query.slice(0, -1);
    await conn.batch(query);
  }
};

const insertConsultingTime = async (conn: sql.ConnectionPool) => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  let query = `insert into time_consulting (project_id, consultant_id, hours, start) values `;
  validProject.forEach(async (project) => {
    for (let i = 0; i < 10; i++) {
      const consultant_id =
        validEmployee[Math.floor(Math.random() * validEmployee.length)]?.id;

      const hours = faker.helpers.rangeToNumber({
        max: 100,
        min: 1,
      });

      const start = faker.date.past();

      query += `('${project.id}', '${consultant_id}', ${hours}, ${start}),`;
    }
  });

  query = query.slice(0, -1);
  await conn.query(query);
};

const insertErrorServerity = async (conn: sql.ConnectionPool) => {
  const errorSeverityNames = ["Low", "Medium", "High", "Critical", "Blocker"];

  errorSeverityNames.forEach(async (name) => {
    await conn.query(
      `INSERT INTO error_severity (title, description) VALUES ('${name}', '${faker.lorem.paragraph()}')`
    );
  });
};

const insertErrors = async (conn: sql.ConnectionPool) => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validFunctionality = (await sql.query`SELECT * FROM functionality`)
    .recordset as Array<any>;

  const validErrorSeverity = (await sql.query`SELECT id FROM error_severity`)
    .recordset as Array<any>;

  const validErrorState = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    const functionalities = validFunctionality.filter(
      (f) => f.project_id === project.id
    );
    functionalities.forEach(async (functionality) => {
      for (let i = 0; i < 10; i++) {
        const severity_id =
          validErrorSeverity[
            Math.floor(Math.random() * validErrorSeverity.length)
          ]?.id;

        const state_id =
          validErrorState[Math.floor(Math.random() * validErrorState.length)]
            ?.id;

        const description = faker.lorem.paragraph();
        const report_date = faker.date.past();
        const resolution = faker.date.past({
          refDate: report_date,
        });

        await sql.query`INSERT INTO errors (project_id, functionality_id, severity_id, state_id, description, report_date, resolution) VALUES (${project.id}, ${functionality.id}, ${severity_id}, ${state_id}, ${description}, ${report_date}, ${resolution})`;
      }
    });
  });
};

const insertVacation = async (conn: sql.ConnectionPool) => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validStatus = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const state_id =
        validStatus[Math.floor(Math.random() * validStatus.length)]?.id;

      const start = faker.date.past();
      const finish = faker.date.past({ refDate: start });

      await sql.query`INSERT INTO vacations (employee_id, state_id, start, finish) VALUES (${employee.id}, ${state_id}, ${start}, ${finish})`;
    }
  });
};

const insertAbseceType = async (conn: sql.ConnectionPool) => {
  const absenceTypeNames = ["Vacation", "Sick", "Personal"];

  absenceTypeNames.forEach(async (name) => {
    await conn.query`INSERT INTO absence_type (name, description) VALUES (${name}, ${faker.lorem.paragraph()})`;
  });
};

const insertAbsence = async (conn: sql.ConnectionPool) => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validAbsenceType = (await sql.query`SELECT id FROM absence_type`)
    .recordset as Array<any>;

  let query = `insert into absence (employee_id, type_id, start, finish) values `;

  validEmployee.forEach(async (employee) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const type_id =
        validAbsenceType[Math.floor(Math.random() * validAbsenceType.length)]
          ?.id;

      const start = faker.date.past();
      const finish = faker.date.future();

      await sql.query`INSERT INTO absence (employee_id, type_id, start, finish) VALUES (${employee.id}, ${type_id}, ${start}, ${finish})`;
    }
  });
};

const insertPerformanceEvaluation = async (conn: sql.ConnectionPool) => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  let query = `insert into performance_evaluation (employee_id, date, score) values `;

  validEmployee.forEach(async (employee) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const date = faker.date.past();
      const score = faker.helpers.rangeToNumber({
        max: 10,
        min: 1,
      });

      await sql.query`INSERT INTO performance_evaluation (employee_id, date, score) VALUES (${employee.id}, ${date}, ${score})`;
    }
  });

  query = query.slice(0, -1);
  await conn.batch(query);
};

const insertQualityAudit = async (conn: sql.ConnectionPool) => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const responsible_id =
        validEmployee[Math.floor(Math.random() * validEmployee.length)]?.id;

      const date = faker.date.past();
      const result = faker.lorem.paragraph();
      const score = faker.helpers.rangeToNumber({
        max: 10,
        min: 1,
      });

      await sql.query`INSERT INTO quality_audit (project_id, responsible_id, date, result, score) VALUES (${project.id}, ${responsible_id}, ${date}, ${result}, ${score})`;
    }
  });
};

const inssertClientProject = async () => {
  const validProject = (
    await sql.query`
    SELECT 
      project.id as project_id,
      client.id as client_id
    FROM project
    inner join sales on project.id = sales.project_id
    inner join client on sales.client_id = client.id
  `
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`INSERT INTO client_project (project, client) VALUES (${project.project_id}, ${project.client_id})`;
  });
};

const insertClient = async (conn: sql.ConnectionPool) => {
  for (let i = 0; i < 200; i++) {
    const name = faker.company.name();
    const country = faker.location.countryCode("alpha-3");
    const city = faker.location.city();
    const email = faker.internet.email();
    const phone = faker.phone.number().slice(0, 12);
    const start_relationship = faker.date.past();
    const end_relationship = faker.date.future();

    await sql.query`INSERT INTO client (name, country, city, email, phone, start_relationship, end_relationship) VALUES (${name}, ${country}, ${city}, ${email}, ${phone}, ${start_relationship}, ${end_relationship})`;
  }
};

const insertSUpportTicket = async (conn: sql.ConnectionPool) => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validClient = (await sql.query`SELECT id FROM client`)
    .recordset as Array<any>;

  const validStatus = (await sql.query`SELECT id FROM status`)
    .recordset as Array<any>;

  let query = `insert into support_ticket (project_id, responsible_id, client_id, state_id, summary, description, priority, creation, closure, satisfaction) values `;

  validProject.forEach(async (project) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const responsible_id =
        validEmployee[Math.floor(Math.random() * validEmployee.length)]?.id;

      const client_id =
        validClient[Math.floor(Math.random() * validClient.length)]?.id;

      const state_id =
        validStatus[Math.floor(Math.random() * validStatus.length)]?.id;

      const summary = faker.lorem.sentence({
        min: 2,
        max: 3,
      });

      const description = faker.lorem.paragraph();
      const priority = faker.helpers.rangeToNumber({
        max: 5,
        min: 1,
      });
      const creation = faker.date.past();
      const closure = faker.date.future();
      const satisfaction = faker.helpers.rangeToNumber({
        max: 5,
        min: 1,
      });

      await sql.query`INSERT INTO support_ticket (project_id, responsible_id, client_id, state_id, summary, description, priority, creation, closure, satisfaction) VALUES (${project.id}, ${responsible_id}, ${client_id}, ${state_id}, ${summary}, ${description}, ${priority}, ${creation}, ${closure}, ${satisfaction})`;
    }
  });
};

const insertClientFeedback = async (conn: sql.ConnectionPool) => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  const validClient = (await sql.query`SELECT id FROM client`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    for (let i = 0; i < Math.floor(Math.random() * 10); i++) {
      const client_id =
        validClient[Math.floor(Math.random() * validClient.length)]?.id;

      const date = faker.date.past();
      const description = faker.lorem.paragraph();
      const satisfaction = faker.helpers.rangeToNumber({
        max: 5,
        min: 1,
      });
      await sql.query`INSERT INTO client_feedback (project_id, client_id, date, description, satisfaction) VALUES (${project.id}, ${client_id}, ${date}, ${description}, ${satisfaction})`;
    }
  });
};

const insertIncome = async () => {
  const validClient = (await sql.query`SELECT id FROM client`)
    .recordset as Array<any>;

  validClient.forEach(async (client) => {
    for (let i = 0; i < Math.floor(Math.random() * 25); i++) {
      const date = faker.date.past();
      const amount = faker.finance.amount(1000000, 10000000);
      const description = faker.lorem.paragraph();
      const payment_method = faker.finance.transactionType();

      await sql.query`INSERT INTO income (client_id, date, amount, description, payment_method) VALUES (${client.id}, ${date}, ${amount}, ${description}, ${payment_method})`;
    }
  });
};

const insertExpense = async () => {
  let query = `insert into expense (concept, amount, date) values `;

  for (let i = 0; i < 200; i++) {
    const concept = faker.company.name();
    const amount = faker.finance.amount(1000000, 10000000);
    const date = faker.date.past();

    await sql.query`INSERT INTO expense (concept, amount, date) VALUES (${concept}, ${amount}, ${date})`;
  }
};

const insertBudget = async () => {
  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    for (let i = 0; i < Math.floor(Math.random() * 25); i++) {
      const description = faker.lorem.paragraph();
      const amount = faker.finance.amount(1000000, 10000000);
      await sql.query`INSERT INTO budget (project_id, description, amount) VALUES (${project.id}, ${description}, ${amount})`;
    }
  });
};

const insertPayrroll = async () => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    for (let i = 0; i < Math.floor(Math.random() * 50); i++) {
      const date = faker.date.past();
      const amount = faker.finance.amount(1000000, 10000000);

      await sql.query`INSERT INTO payroll (employee_id, date, amount) VALUES (${employee.id}, ${date}, ${amount})`;
    }
  });
};

const insertSales = async () => {
  const validEmployee = (await sql.query`SELECT id FROM employees`)
    .recordset as Array<any>;

  const validClient = (await sql.query`SELECT id FROM client`)
    .recordset as Array<any>;

  const validProject = (await sql.query`SELECT id FROM project`)
    .recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    for (let i = 0; i < Math.floor(Math.random() * 2); i++) {
      const client_id =
        validClient[Math.floor(Math.random() * validClient.length)]?.id;

      const project_id =
        validProject[Math.floor(Math.random() * validProject.length)]?.id;

      const date = faker.date.past();
      const amount = faker.finance.amount(1000000, 10000000);

      await sql.query`INSERT INTO sales (client_id, project_id, employee_id, date, amount) VALUES (${client_id}, ${project_id}, ${employee.id}, ${date}, ${amount})`;
    }
  });
};

const removeFinishFromTasks = async () => {
  const tasks = (await sql.query`SELECT id, finish FROM tasks`)
    .recordset as Array<any>;

  tasks.forEach(async (task) => {
    if (Math.random() < 0.5) {
      console.log("remove finish from task", task.id);
      await sql.query`UPDATE tasks SET finish = NULL WHERE id = ${task.id}`;
    }
  });
};

const insertDevelopmentTimeDimension = async () => {
  const validDevelopmentTime = (await sql.query`SELECT * FROM development_time`)
    .recordset as Array<any>;

  validDevelopmentTime.forEach(async (developmentTime) => {
    await sql.query`
      INSERT INTO development_time_dimension 
      (id, functionality_id, task_id, employee_id, hours, date, status) VALUES 
      (${developmentTime.id}, ${developmentTime.functionality_id}, ${developmentTime.task_id}, ${developmentTime.employee_id}, ${developmentTime.hours}, ${developmentTime.date}, ${developmentTime.status})`;
  });
};

const insertProjectDimension = async () => {
  const validProject = (await sql.query`SELECT * FROM project`)
    .recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`INSERT INTO project_dimension (id, name, start, finished, status) VALUES (${project.id}, ${project.name}, ${project.start}, ${project.finish}, ${project.status_id})`;
  });
};

const insertFunctionalityDimension = async () => {
  const validFunctionality = (await sql.query`SELECT * FROM functionality`)
    .recordset as Array<any>;

  validFunctionality.forEach(async (functionality) => {
    await sql.query`INSERT INTO functionality_dimension (id, name, description) VALUES (${functionality.id}, ${functionality.title}, ${functionality.description})`;
  });
};

const insertEmployeeDimension = async () => {
  const validEmployee = (await sql.query`SELECT * FROM employees`)
    .recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    await sql.query`INSERT INTO employee_dimension (id, names, surnames, birth_date, email, phone, position, salary, hiring_date, termination_date, relationship_end) VALUES (${employee.id}, ${employee.names}, ${employee.last_names}, ${employee.birth}, ${employee.email}, ${employee.phone}, ${employee.position_id}, ${employee.salary}, ${employee.hiring}, ${employee.unlinking}, ${employee.unlinking})`;
  });
};

const insertTaskDimension = async () => {
  const validTask = (await sql.query`SELECT * FROM tasks`)
    .recordset as Array<any>;

  validTask.forEach(async (task) => {
    await sql.query`INSERT INTO task_dimension (id, name, description, estimated_hours) VALUES (${task.id}, ${task.title}, ${task.description}, ${task.estimation})`;
  });
};

const insertCustomerDimension = async () => {
  const validClient = (await sql.query`SELECT * FROM client`)
    .recordset as Array<any>;

  validClient.forEach(async (client) => {
    await sql.query`INSERT INTO customer_dimension (id, name, country, city, email, phone) VALUES (${client.id}, ${client.name}, ${client.country}, ${client.city}, ${client.email}, ${client.phone})`;
  });
};

const insertProductDimension = async () => {
  const validProduct = (await sql.query`select * from project`)
    .recordset as Array<any>;

  validProduct.forEach(async (product) => {
    await sql.query`INSERT INTO product_dimension (id, name, description, price) VALUES (${
      product.id
    }, ${product.name}, ${faker.lorem.paragraph(1)}, ${faker.finance.amount({
      min: 1000000,
      max: 10000000,
    })})`;
  });
};

const insertRevenueDimesion = async () => {
  const validRevenue = (await sql.query`SELECT * FROM income`)
    .recordset as Array<any>;

  validRevenue.forEach(async (revenue) => {
    await sql.query`INSERT INTO revenue_dimension (id, revenue_amount,revenue_date) VALUES 
    (${revenue.id}, ${revenue.amount}, ${revenue.date})`;
  });
};

const insertExpenseDimension = async () => {
  const validExpense = (await sql.query`SELECT * FROM expense`)
    .recordset as Array<any>;

  validExpense.forEach(async (expense) => {
    await sql.query`INSERT INTO expense_dimension (id, amount, expense_date) VALUES (${expense.id}, ${expense.amount}, ${expense.date})`;
  });
};

const insertSupportTicketDimenssion = async () => {
  const validSupportTicket = (
    await sql.query`SELECT
    support_ticket.id as id,
    support_ticket.description as description,
    support_ticket.priority as priority,
    pd.id as project_id,
    support_ticket.creation as creation,
    support_ticket.closure as closure,
    support_ticket.client_id as customer_id,
    support_ticket.satisfaction as satisfaction,
    status.name as status
  FROM support_ticket
  inner join status on support_ticket.state_id = status.id
  inner join project_dimension pd on support_ticket.project_id = pd.id
  `
  ).recordset as Array<any>;

  validSupportTicket.forEach(async (supportTicket) => {
    await sql.query`INSERT INTO support_ticket_dimension (
        id, 
        customer_id, 
        project_id, 
        description, 
        priority, 
        status, 
        creation, 
        category, 
        closure, 
        customer_satisfaction
      ) 
      VALUES (
          ${supportTicket.id}, 
          ${supportTicket.customer_id}, 
          ${supportTicket.project_id}, 
          ${supportTicket.description}, 
          ${supportTicket.priority}, 
          ${supportTicket.status}, 
          ${supportTicket.creation}, 
          ${faker.music.genre()}, 
          ${supportTicket.closure}, 
          ${supportTicket.satisfaction}
        )`;
  });
};

const insertFactProjectProgress = async () => {
  const validProject = (
    await sql.query`
    SELECT
      project.id as project_id,
      functionality.id as functionality_id,
      tasks.id as task_id,
      development_time.hours as hours_spent,
      status.name as status,
      time_dimension.id as time_id
    FROM project
    inner join functionality on project.id = functionality.project_id
    inner join tasks on project.id = tasks.project_id
    inner join development_time on tasks.id = development_time.task_id
    inner join status on tasks.state_id = status.id
    inner join time_dimension on tasks.start = time_dimension.date
  `
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`
      INSERT INTO fact_project_progress 
      (project_id, time_id, task_id, functionality_id, hours_spent, progress) VALUES 
      (${project.project_id}, ${project.time_id}, ${project.task_id}, ${
      project.functionality_id
    }, ${project.hours_spent}, ${faker.number.int({
      min: 30,
      max: 100,
    })})`;
  });
};

const insertTimeDimension = async () => {
  const years = [2020, 2021, 2022, 2023, 2024];
  const months = [
    { name: "January", days: 31 },
    { name: "February", days: 28 },
    { name: "March", days: 31 },
    { name: "April", days: 30 },
    { name: "May", days: 31 },
    { name: "June", days: 30 },
    { name: "July", days: 31 },
    { name: "August", days: 31 },
    { name: "September", days: 30 },
    { name: "October", days: 31 },
    { name: "November", days: 30 },
    { name: "December", days: 31 },
  ];

  years.forEach(async (year) => {
    months.forEach(async (month) => {
      for (let day = 1; day <= month.days; day++) {
        const date = `${year}-${month.name}-${day}`;
        const monthNumber = new Date(date).getMonth();
        const quarter = Math.ceil(month.days / 4);

        await sql.query`insert into time_dimension (date, day, month, year, quarter) values (${date}, ${day}, ${monthNumber}, ${year}, ${quarter})`;
      }
    });
  });
};

const insertProjectDelays = async () => {
  const validProject = (
    await sql.query`
    SELECT 
      project.id as project_id,
      functionality.id as functionality_id,
      tasks.id as task_id,
      development_time.hours as hours_spent,
      status.name as status
     FROM project
    inner join functionality on project.id = functionality.project_id
    inner join tasks on functionality.id = tasks.functionality_id
    inner join development_time on tasks.id = development_time.task_id
    inner join status on tasks.state_id = status.id
    inner join time_dimension on development_time.date = time_dimension.date
  `
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`
      INSERT INTO fact_project_progress 
      (project_id, time_id,functionality_id, task_id, hours_spent, status) VALUES 
      (${project.project_id}, ${project.time_id} ${project.functionality_id}, ${project.task_id}, ${project.hours_spent}, ${project.status})`;
  });
};

const insertFactSales = async () => {
  const customers = (
    await sql.query`
    SELECT
      client.id as client_id,
      sales.project_id as project_id,
      time_dimension.id as time_id,
      sales.amount as amount
    FROM client
    inner join client_project on client.id = client_project.client
    inner join project on client_project.project = project.id
    inner join sales on project.id = sales.project_id
    inner join time_dimension on sales.date = time_dimension.date
  `
  ).recordset as Array<any>;

  customers.forEach(async (customer) => {
    await sql.query`
      INSERT INTO fact_sales 
      (customer_id, product_id, time_id, quantity,total) VALUES 
      (${customer.client_id}, ${customer.project_id}, ${
      customer.time_id
    }, ${faker.number.int({ min: 2, max: 4 })},${customer.amount})`;
  });
};

const insertFactDevelopedFunctionalities = async () => {
  const validProject = (
    await sql.query`
    SELECT
      project.id as project_id,
      functionality.id as functionality_id,
      tasks.id as task_id,
      employees.id as employee_id,
      development_time.hours as hours_spent,
      development_time.id as development_time_id
     FROM functionality
    inner join project on project.id = functionality.project_id
    inner join tasks on functionality.id = tasks.functionality_id
    inner join employees on tasks.employee_id = employees.id
    inner join development_time on tasks.id = development_time.task_id
    inner join time_dimension on tasks.start = time_dimension.date
  `
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`
      INSERT INTO fact_developed_functionalities 
      (project_id, functionality_id, employee_id, development_time_id, hours_spent) VALUES 
      (${project.project_id}, ${project.functionality_id}, ${project.employee_id}, ${project.development_time_id},${project.hours_spent})`;
  });
};

const insertFactPerformanceEvaluation = async () => {
  const validEmployee = (
    await sql.query`
    SELECT 
      employees.id as employee_id,
      employees.id as reviewer_id,
      performance_evaluation.date as date,
      performance_evaluation.score as score,
      performance_evaluation.score as avg_score
    FROM employees
    inner join performance_evaluation on employees.id = performance_evaluation.employee_id
  `
  ).recordset as Array<any>;

  validEmployee.forEach(async (employee) => {
    await sql.query`
      INSERT INTO fact_performance_reviews 
      (employee_id, reviewer_id, date, score, avg_score) VALUES 
      (${employee.employee_id}, ${employee.reviewer_id}, ${employee.date}, ${employee.score}, ${employee.avg_score})`;
  });
};

const insertFactProfitLoss = async () => {
  const profit = (
    await sql.query`
    SELECT
      time_dimension.id as time_id,
      revenue_dimension.id as revenue,
      expense_dimension.id as expense,
      sum(revenue_dimension.revenue_amount) - sum(expense_dimension.amount) as amount,
      time_dimension.date as date
    FROM time_dimension
    inner join revenue_dimension on time_dimension.date = revenue_dimension.revenue_date
    inner join expense_dimension on time_dimension.date = expense_dimension.expense_date
    group by time_dimension.id, revenue_dimension.id, expense_dimension.id, time_dimension.date
  `
  ).recordset as Array<any>;

  profit.forEach(async (revenue) => {
    await sql.query`
      INSERT INTO fact_profit_loss 
      (revenue_id, expense_id,time_id, profit_loss_amount, profit_loss_date) VALUES 
      (${revenue.revenue}, ${revenue.expense}, ${revenue.time_id}, ${revenue.amount}, ${revenue.date})`;
  });
};

const insertFactSupportTicketCreated = async () => {
  const validProject = (
    await sql.query`
    SELECT
      project.id as project_id,
      support_ticket_dimension.id as support_id,
      time_dimension.id as time_id,
      count(support_ticket_dimension.id) as total_tickets,
      sum(datediff(hour, support_ticket_dimension.creation, support_ticket_dimension.closure)) as time_spent
    FROM project
    inner join support_ticket on project.id = support_ticket.project_id
    inner join support_ticket_dimension on support_ticket.id = support_ticket_dimension.id
    inner join time_dimension on support_ticket.creation = time_dimension.date
    group by project.id, support_ticket_dimension.id, time_dimension.id
  `
  ).recordset as Array<any>;

  validProject.forEach(async (project) => {
    await sql.query`
      INSERT INTO fact_created_support_tickets 
      (project_id, support_id, time_id, total_tickets, time_spent) VALUES 
      (${project.project_id}, ${project.support_id}, ${project.time_id}, ${project.total_tickets}, ${project.time_spent})`;
  });
};

const insertFakeData = async (sql: sql.ConnectionPool) => {
  await insertProjectStatus();
  await insertProjectType();
  await insertProject();
  await insertFunctionalityType();
  await insertFunctionality();
  await insertEmployeePosition();
  await insertEmployee();
  await insertEmployeeRole();
  await insertProjectAssigment();
  await insertTasks();
  await insertDevlopmentTime(sql);
  await insertConsultingTime(sql);
  await insertErrorServerity(sql);
  await insertErrors(sql);
  await insertVacation(sql);
  await insertAbseceType(sql);
  await insertAbsence(sql);
  await insertPerformanceEvaluation(sql);
  await insertQualityAudit(sql);
  await insertClient(sql);
  await insertSUpportTicket(sql);
  await insertClientFeedback(sql);
  await insertIncome();
  await insertExpense();
  await insertBudget();
  await insertPayrroll();
  await insertSales();
  await removeFinishFromTasks();
  await insertFunctionalityDimension();
  await insertEmployeeDimension();
  await insertTaskDimension();
  await insertCustomerDimension();
  await insertProductDimension();
  await insertRevenueDimesion();
  await insertExpenseDimension();
  await insertProjectDimension();
  await insertSupportTicketDimenssion();
  await insertTimeDimension();
  await insertFactProjectProgress();
  await inssertClientProject();
  await insertFactSales();
  await insertFactDevelopedFunctionalities();
  await insertFactPerformanceEvaluation();
  await insertFactProfitLoss();
  await insertFactSupportTicketCreated();
};

const main = async () => {
  const connection = await createSqlServerConnection();
  await insertFakeData(connection);
};

main();
