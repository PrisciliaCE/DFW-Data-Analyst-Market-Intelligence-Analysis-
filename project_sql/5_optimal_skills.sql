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
    INNER JOIN skills_job_dim sjd ON sjd.job_id = jp.job_id
    WHERE jp.job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
),

skills_demand AS (
    SELECT 
        s.skill_id,
        s.skills AS skill_name,
        COUNT(*) AS skill_count
    FROM dfw_data_analyst d
    INNER JOIN skills_dim s ON s.skill_id = d.skill_id
    GROUP BY s.skill_id, s.skills
    HAVING COUNT(*) > 10
),

skills_salary AS (
    SELECT 
        s.skill_id,
        ROUND(AVG(d.salary_year_avg), 0) AS avg_salary
    FROM dfw_data_analyst d
    INNER JOIN skills_dim s ON s.skill_id = d.skill_id
    GROUP BY s.skill_id
)

SELECT 
    sd.skill_id,
    sd.skill_name,
    sd.skill_count,
    ss.avg_salary
FROM skills_demand sd
INNER JOIN skills_salary ss ON sd.skill_id = ss.skill_id
ORDER BY ss.avg_salary DESC, sd.skill_count DESC
LIMIT 15;
