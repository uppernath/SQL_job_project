/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' and job_work_from_home = True and salary_year_avg IS NOT NULL
ORDER BY
     salary_year_avg desc
LIMIT 10
  )

SELECT top_paying_jobs.*,
        skills
FROM top_paying_jobs
JOIN skills_job_dim
ON top_paying_jobs.job_id = skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;

/*Here's the breakdown of the most demanded skills for data analysts in 2023, based on job postings:
SQL is leading with a bold count of 8.
Python follows closely with a bold count of 7.
Tableau is also highly sought after, with a bold count of 6.
Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.*/