/* 
   Analysis: Top-Paying Data Analyst Jobs and Skills (2023)
   Scope: Dallas–Fort Worth Metroplex 
          - Dallas, Fort Worth, Arlington, Plano, Irving,
            Garland, Frisco, McKinney, Denton, Grand Prairie, 
            Richardson, Carrollton, Lewisville, Allen, Grapevine

   - Identify the top 20 highest-paying Data Analyst roles across
     the DFW metroplex in 2023.
   - Exclude job postings without salary information to ensure
     accurate, compensation-driven analysis.
   - Extract and aggregate the skills associated with each
     top-paying role to identify common high-value skill sets.

   Objective:
   Highlight the most lucrative Data Analyst opportunities in the
   DFW job market and uncover the skills most frequently linked to
   higher compensation, supporting data-driven career planning
   and skill development.
*/

WITH dallas_top15 AS (
    SELECT * FROM (VALUES
        ('Dallas, TX'), ('Fort Worth, TX'), ('Arlington, TX'), ('Plano, TX'),
        ('Irving, TX'), ('Garland, TX'), ('Frisco, TX'), ('McKinney, TX'),
        ('Denton, TX'), ('Grand Prairie, TX'), ('Richardson, TX'), ('Carrollton, TX'),
        ('Lewisville, TX'), ('Allen, TX'), ('Grapevine, TX')
    ) AS t(city)
),
dfw_data_analyst AS (
    SELECT
        jp.job_id,
        jp.job_title,
        jp.job_location,
        salary_year_avg,
        name AS company_name 
    FROM
        job_postings_fact jp
    LEFT JOIN company_dim ON jp.company_id = company_dim.company_id
    INNER JOIN dallas_top15 d15 ON jp.job_location = d15.city
    WHERE
        jp.job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL
)


-- Top paying skills
SELECT 
    d.*,
    STRING_AGG(s.skills, ', ') AS required_skills
FROM 
    dfw_data_analyst d
INNER JOIN skills_job_dim ON d.job_id = skills_job_dim.job_id
INNER JOIN skills_dim AS s ON skills_job_dim.skill_id = s.skill_id
GROUP BY
    d.job_id,
    d.job_title,
    d.job_location,
    d.company_name,
    d.salary_year_avg
ORDER BY salary_year_avg DESC
LIMIT 20;