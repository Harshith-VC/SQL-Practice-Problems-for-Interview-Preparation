--You need to find every employee who currently has or previously had a title that contains the word manager.
--Return the first name of the employee together with the title.


CREATE TABLE workers
(
    department VARCHAR(100),
    first_name VARCHAR(50),
    joining_date DATE,
    last_name VARCHAR(50),
    salary BIGINT,
    worker_id BIGINT PRIMARY KEY
);

CREATE TABLE titles
(
    affected_from DATE,
    worker_ref_id BIGINT,
    worker_title VARCHAR(100),
    FOREIGN KEY (worker_ref_id) REFERENCES workers(worker_id)
);
INSERT INTO workers (department, first_name, joining_date, last_name, salary, worker_id) VALUES
('HR', 'Alice', '2020-01-15', 'Smith', 60000, 1),
('Engineering', 'Bob', '2019-03-10', 'Johnson', 80000, 2),
('Sales', 'Charlie', '2021-07-01', 'Brown', 50000, 3),
('Engineering', 'David', '2018-12-20', 'Wilson', 90000, 4),
('Marketing', 'Emma', '2020-06-30', 'Taylor', 70000, 5);

INSERT INTO titles (affected_from, worker_ref_id, worker_title) VALUES
('2020-01-15', 1, 'HR Manager'),
('2019-03-10', 2, 'Software Engineer'),
('2021-07-01', 3, 'Sales Representative'),
('2018-12-20', 4, 'Engineering Manager'),
('2020-06-30', 5, 'Marketing Specialist'),
('2022-01-01', 5, 'Marketing Manager');



--SQL Query 

SELECT
    w.first_name,
    t.worker_title
FROM workers w
JOIN titles t
    ON w.worker_id = t.worker_ref_id
WHERE t.worker_title LIKE '%Manager%';
