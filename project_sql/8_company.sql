WITH dallas_top15 AS (
    SELECT * FROM (VALUES
        ('Dallas, TX'), ('Fort Worth, TX'), ('Arlington, TX'), ('Plano, TX'),
        ('Irving, TX'), ('Garland, TX'), ('Frisco, TX'), ('McKinney, TX'),
        ('Denton, TX'), ('Grand Prairie, TX'), ('Richardson, TX'), ('Carrollton, TX'),
        ('Lewisville, TX'), ('Allen, TX'), ('Grapevine, TX')
    ) AS t(city)
)

SELECT
    c.name AS company_name,
    COUNT(jp.job_id) AS num_postings
FROM job_postings_fact jp
LEFT JOIN company_dim c ON jp.company_id = c.company_id
INNER JOIN dallas_top15 d15 ON jp.job_location = d15.city
WHERE jp.job_title_short = 'Data Analyst'
  AND jp.salary_year_avg IS NOT NULL
GROUP BY c.name
ORDER BY num_postings DESC;