/***What are the top-paying analyst jobs, and what skills are required in Lithuania?** 
- Identify the top 10 highest-paying jobs and the specific skills required for these roles.
- Filters for roles with specified salaries.
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries.*/
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_country = 'Lithuania'
    ORDER BY
        salary_year_avg DESC
)
SELECT
    top_paying_jobs.job_id,
    job_title,
    job_location,
    salary_year_avg,
    skills
FROM
    top_paying_jobs
	INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
	INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC