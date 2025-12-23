/*What are the top-paying data jobs in Lithuania?
- Identify the top 10 highest-paying roles that are available, including remote opportunities.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying data job opportunities.*/

SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	name AS company_name,
	(job_posted_date)::DATE
FROM
	job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
	salary_year_avg IS NOT NULL
	AND job_country = 'Lithuania'
ORDER BY
	salary_year_avg DESC 
LIMIT 10
