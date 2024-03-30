/*Using CASE*/
SELECT COUNT(job_id) AS num_of_jobs,
  CASE
    WHEN salary_year_avg < 60000  THEN 'Low Salary'
    WHEN salary_year_avg >= 60000 THEN 'High Salary'
    ELSE 'Not Stated'
  END AS salary_category
  /*
  CASE
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
  END AS location_category
  */
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY salary_category

/*Using Subqueries*/
SELECT *
FROM(
  SELECT * 
  FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date) = 4
) AS April_jobs

/*Using CTEs*/

WITH May_jobs AS(
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date) = 5
)
SELECT * FROM May_jobs

/*Subquery Example*/

SELECT company_id, name AS company_name
FROM company_dim
WHERE company_id IN (
  SELECT company_id
  FROM job_postings_fact
  WHERE job_no_degree_mention = True
  ORDER BY company_id
)


/*QUERY TO SELECT THE COMPANY WITH THE HIGHEST JOB OPENINGS*/

/*Using Subqueries*/
SELECT company_id, name as company_name
FROM company_dim
WHERE company_id = (
	SELECT company_id
	FROM(
	SELECT company_id, count(*) AS num_openings
	FROM job_postings_fact
	GROUP BY company_id
	ORDER BY num_openings desc
	LIMIT 1
	) AS most_openings
);

/*Using CTES*/
WITH company_job_count AS (
SELECT company_id, count(*) AS total_jobs
FROM job_postings_fact
GROUP BY company_id
	)
	
SELECT company_dim.company_id, company_dim.name AS company_name, company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count 
	ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;
