# SQL PROJECT WITH LUKE FOR DATA NERDS IN LITHUANIA 🤓

Welcome to my SQL Portfolio Project, which is the result of the hard work of Luke Barousse and some of mine. In this project, I explore the data job market with a focus on data analyst roles in Lithuania. Think of it as a friendly detective mission: finding the top paying jobs, the most wanted skills, and where great pay meets high demand in data analytics (and data jobs in general).

📂 Check out my SQL queries here: [project_SQL folder](/project_sql/)

---

## Why this project happened?

I built this project because I wanted a clearer picture of the data analyst job market in Lithuania. My goal was to figure out which skills show up the most and which ones tend to come with higher salaries, so I can focus my learning and job search with more confidence.

The data for this analysis is from Luke Barousse’s SQL Course ([course link](https://www.lukebarousse.com/sql)). It includes job titles, salaries, locations, and required skills.

---

### Here are the questions I wanted to answer:

- What are the top paying data jobs in Lithuania?
- What skills are required for these top paying jobs?
- What skills are most in demand for data analysts in Lithuania?
- Which skills are associated with higher salaries?

---

## 🛠️ Tools Used

- **SQL (Structured Query Language)**: helped me query the database and answer the questions  
- **PostgreSQL**: where the data lived and where all the querying happened  
- **Visual Studio Code**: my workspace for writing and running queries  
- **ChatGPT**: support for learning, stress management, and grammar cleanup  

---

## 📊 What Does The Data Say?

Each query focuses on a specific part of the Lithuania data analyst job market. Here’s how I approached it:

---

### 1. Top Paying Data Jobs in Lithuania

To find the highest paying roles, I filtered to Lithuania and kept only job postings with an annual salary listed. Then I sorted by salary and grabbed the top 10.

```sql
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
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_country = 'Lithuania'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

#### 🔍 Results: Top 10 Paying Data Jobs in Lithuania

| Job ID   | Job Title                                      | Location                                             | Schedule  | Avg. Salary (€) | Company Name     | Posted Date |
|----------|------------------------------------------------|------------------------------------------------------|-----------|-----------------|------------------|--------------|
| 1533609  | Senior Data Scientist – Price Optimization Modeling | Anywhere                                          | Full-time | 166,860         | CVS Health       | 2025-04-19   |
| 1502273  | Senior Data Scientist - AI                     | Anywhere                                             | Full-time | 166,860         | CVS Health       | 2025-04-01   |
| 505870   | Data Scientist (AI Team)                       | Vilnius, Vilnius City Municipality, Lithuania        | Full-time | 157,500         | Hostinger        | 2023-08-18   |
| 683228   | Analytics Engineer                             | Lithuania                                            | Full-time | 155,000         | Hostinger        | 2023-11-07   |
| 1423003  | Senior Data Scientist- LLM                     | Anywhere                                             | Full-time | 150,000         | Binance          | 2025-02-27   |
| 94892    | Data Engineer                                  | Vilnius, Vilnius city municipality, Lithuania        | Full-time | 147,500         | Baltic Amadeus   | 2023-01-31   |
| 618209   | Senior Revenue Data Manager                    | Vilnius, Vilnius City Municipality, Lithuania        | Full-time | 125,000         | Wolt             | 2023-10-07   |
| 430732   | Data Analyst                                   | Vilnius, Vilnius City Municipality, Lithuania        | Full-time | 100,500         | Devbridge        | 2023-07-14   |
| 350462   | Data Analyst                                   | Vilnius, Vilnius City Municipality, Lithuania        | Full-time | 100,500         | Softeta          | 2023-06-06   |
| 370984   | Data Engineer                                  | Vilnius, Vilnius City Municipality, Lithuania        | Full-time | 96,773          | Devbridge        | 2023-06-16   |

---

### 2. Skills for Top Paying Jobs

Next, I joined job postings with the skills tables to see which skills show up in the best paying roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
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
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

#### 🔍 Results: Skills for Top Paying Jobs (Top 10 Rows)

| Job ID  | Job Title                                              | Location   | Avg. Salary (€) | Skill     |
|--------:|--------------------------------------------------------|------------|----------------:|-----------|
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | SQL       |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | Python    |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | R         |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | Go        |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | Databricks |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | AWS       |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | GCP       |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | GitHub    |
| 1533609 | Senior Data Scientist – Price Optimization Modeling     | Anywhere   | 166,860         | GitLab    |
| 505870  | Data Scientist (AI Team)                                | Vilnius    | 157,500         | SQL       |

**Key takeaway:**  
Top paying roles consistently require **SQL and Python**, while cloud platforms (**AWS, GCP**) and tooling (**Databricks, GitHub/GitLab**) appear frequently in the highest‑salary positions.

---

### 3. In Demand Skills for Data Analysts

This query highlights the skills that appear most often in Lithuania data analyst postings that allow working from home.

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_country = 'Lithuania'
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

#### 🔍 Results: Top 5 In-Demand Skills for Remote Data Analysts in Lithuania

| Skill    | Demand Count |
|----------|--------------|
| SQL      | 53           |
| Python   | 32           |
| Tableau  | 27           |
| Looker   | 17           |
| Excel    | 15           |

**Insight:**  
SQL leads the pack in remote data analyst job postings in Lithuania, followed closely by Python and Tableau. This shows that strong core analytics and BI skills remain the most valuable for remote-friendly roles.

---

### 4. Skills Based on Salary

Here I calculated the average salary for postings that mention each skill, so I could see which skills tend to be linked to higher pay in Lithuania.

```sql
SELECT
    skills_dim.skills AS skill,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_country = 'Lithuania'
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC;
```

#### 💰 Results: Skills Ranked by Average Salary

| Skill     | Avg. Salary (€) |
|-----------|------------------|
| Looker    | 125,000          |
| Alteryx   | 125,000          |
| Go        | 125,000          |
| Tableau   | 100,500          |
| Power BI  | 100,500          |
| Python    | 100,500          |
| SQL       | 100,500          |
| Outlook   | 86,400           |
| SAP       | 86,400           |
| Excel     | 86,400           |

**Insight:**  
Niche tools like **Looker**, **Alteryx**, and programming language **Go** are associated with the **highest-paying roles**. Meanwhile, core skills like **SQL**, **Python**, and **Tableau** remain valuable and widely used in high-salary positions.

---

## 📘 What I Learned

- Complex query building using **CTEs (`WITH`)**
- Data aggregation with **`GROUP BY`, `COUNT()`, and `AVG()`**
- Analytical thinking by turning real job market questions into queries that return clear answers

---

## 💡 Most Interesting Part: The Insights

- Top paying data jobs in Lithuania showed a wide salary range, with the highest at **€166,860**  
- Skills for top paying jobs often included **SQL**, reinforcing how crucial it is for higher earning roles  
- Most in-demand skills also included SQL — so it shows up **both in pay and demand**  
- Skills with higher salaries included more **specialized tools** like **Looker** and **Alteryx**, suggesting niche tools can bring a premium

---

## ✅ Conclusion: SQL Is FUN And Useful

This project helped me level up my SQL skills and understand the Lithuania data analyst market more clearly. The results give me a smarter way to prioritize what to learn next and what roles to target. It’s also a good reminder that in data, **learning never really stops** – it just gets more interesting.
