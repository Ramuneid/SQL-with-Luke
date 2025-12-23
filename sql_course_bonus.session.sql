SELECT
    job_via,
    COUNT (job_id) AS darbo_platforma
FROM job_postings_fact
WHERE job_country = 'Lithuania' AND EXTRACT( YEAR FROM job_posted_date) = 2025
GROUP BY job_via
ORDER BY darbo_platforma DESC;