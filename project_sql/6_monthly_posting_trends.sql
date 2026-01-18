WITH dallas_top15 AS (
    SELECT * FROM (VALUES
        ('Dallas, TX'), ('Fort Worth, TX'), ('Arlington, TX'), ('Plano, TX'),
        ('Irving, TX'), ('Garland, TX'), ('Frisco, TX'), ('McKinney, TX'),
        ('Denton, TX'), ('Grand Prairie, TX'), ('Richardson, TX'), ('Carrollton, TX'),
        ('Lewisville, TX'), ('Allen, TX'), ('Grapevine, TX')
    ) AS t(city)
)

SELECT 
    TO_CHAR(DATE_TRUNC('month', jp.job_posted_date), 'Month') AS months_of_2023,
    COUNT(*) AS num_postings
FROM job_postings_fact jp
INNER JOIN dallas_top15 d15 ON jp.job_location = d15.city
WHERE jp.job_title_short = 'Data Analyst' 
  AND salary_year_avg IS NOT NULL
  AND jp.job_posted_date >= '2023-01-01'
  AND jp.job_posted_date < '2024-01-01'
GROUP BY DATE_TRUNC('month', jp.job_posted_date)
ORDER BY DATE_TRUNC('month', jp.job_posted_date);
