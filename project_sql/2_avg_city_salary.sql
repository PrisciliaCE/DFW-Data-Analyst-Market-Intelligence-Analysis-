WITH dallas_top15 AS (
    SELECT * FROM (VALUES
        ('Dallas, TX'), ('Fort Worth, TX'), ('Arlington, TX'), ('Plano, TX'),
        ('Irving, TX'), ('Garland, TX'), ('Frisco, TX'), ('McKinney, TX'),
        ('Denton, TX'), ('Grand Prairie, TX'), ('Richardson, TX'), ('Carrollton, TX'),
        ('Lewisville, TX'), ('Allen, TX'), ('Grapevine, TX')
    ) AS t(city)
),


dfw_data_analyst AS (
    SELECT *    
    FROM job_postings_fact jp
    INNER JOIN dallas_top15 d15 ON jp.job_location = d15.city
    WHERE jp.job_title_short = 'Data Analyst' 
      AND salary_year_avg IS NOT NULL
)


-- Average salary in each city
SELECT
    job_location AS City,
    ROUND(AVG(salary_year_avg), 2) as Avg_salary,
    COUNT(job_location) AS Number_of_jobs
FROM dfw_data_analyst
GROUP BY job_location
ORDER BY Avg_salary DESC;
