-- Background
-- Now that Bobby has proven his SQL chops, his manager has given both of you two more assignments: 
-- determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program. 
-- Then, you’ll write a report that summarizes your analysis and helps prepare Bobby’s manager for the “silver tsunami” 
-- as many current employees reach retirement age.

-- This new assignment consists of two technical analysis deliverables and a written report. You will submit the following:
    -- Deliverable 1: The Number of Retiring Employees by Title
    -- Deliverable 2: The Employees Eligible for the Mentorship Program
    -- Deliverable 3: A written report on the employee database analysis (README.md)


-- Deliverable 1: The Number of Retiring Employees by Title (50 points)
-- Deliverable 1 Instructions
-- Using the ERD you created in this module as a reference and your knowledge of SQL queries, 
-- create a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955. 
-- Because some employees may have multiple titles in the database—for example, due to promotions—you’ll need to use the DISTINCT ON statement to create a table 
-- that contains the most recent title of each employee. 
-- Then, use the COUNT() function to create a table that has the number of retirement-age employees by most recent job title. 
-- Finally, because we want to include only current employees in our analysis, be sure to exclude those employees who have already left the company.

-- steps 1-7 finding employees who are retiring
SELECT 
	e.emp_no, 
	e.first_name,
	e.last_name,
--	e.gender, added for gender diversity analysis & then count performed on gender
	title.title,
	title.from_date,
	title.to_date
-- INTO Retirement_Titles
FROM employees as e
LEFT JOIN titles as title
ON e.emp_no=title.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- made > 1955-12-31 to calculate non-retirement age diversity
ORDER BY emp_no;

-- steps 8-15 - distinct with orderby to remove dup rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title,
--  rt.gender, added for gender diversity analysis & then count performed on gender
	de.to_date
INTO unique_titles
FROM retirement_titles as rt
LEFT JOIN dept_emp as de
ON rt.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')
ORDER BY 
	emp_no, 
	to_date DESC;

-- steps 16-22; count by title 
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;


-- Deliverable 2: The Employees Eligible for the Mentorship Program (30 points)
-- Deliverable 2 Instructions
-- Using the ERD you created in this module as a reference and your knowledge of SQL queries, 
-- create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965 and December 31, 1965.

SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
	de.from_date,
	de.to_date,
	titles.title
INTO mentorship_eligibility
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
LEFT JOIN titles
ON e.emp_no = titles.emp_no
WHERE de.to_date = ('9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no