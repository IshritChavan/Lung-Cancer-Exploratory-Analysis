--Adding a table to our Lung Cancer Database--
CREATE TABLE lung_cancer_data (
	id SERIAL PRIMARY KEY,
    gender VARCHAR(5),
    age INTEGER,
    smoking INTEGER,
    yellow_fingers INTEGER,
    anxiety INTEGER,
    peer_pressure INTEGER,
    chronic_disease INTEGER,
    fatigue INTEGER,
    allergy INTEGER,
    wheezing INTEGER,
    alcohol_consuming INTEGER,
    coughing INTEGER,
    shortness_of_breath INTEGER,
    swallowing_difficulty INTEGER,
    chest_pain INTEGER,
    lung_cancer VARCHAR(5)
);

SELECT * 
	FROM lung_cancer_data;

SELECT
    id,
    gender,
    age,
    CASE smoking
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS smoking_status,
    CASE yellow_fingers
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS yellow_fingers_status,
    CASE anxiety
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS anxiety_status,
    CASE peer_pressure
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS peer_pressure_status,
    CASE chronic_disease
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS chronic_disease_status,
    CASE fatigue
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS fatigue_status,
    CASE allergy
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS allergy_status,
    CASE wheezing
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS wheezing_status,
    CASE alcohol_consuming
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS alcohol_consuming_status,
    CASE coughing
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS coughing_status,
    CASE shortness_of_breath
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS shortness_of_breath_status,
    CASE swallowing_difficulty
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS swallowing_difficulty_status,
    CASE chest_pain
        WHEN 1 THEN 0  -- No
        WHEN 2 THEN 1  -- Yes
        ELSE NULL
    END AS chest_pain_status,
    CASE lung_cancer
        WHEN 'NO' THEN 0  -- No
        WHEN 'YES' THEN 1  -- Yes
        ELSE NULL
    END AS lung_cancer_status
FROM lung_cancer_data;




--QUERY 1:How to assess who is at risk of getting lung cancer? Adding a "Risk Score" to determine an arbitrary value for risk of Lung Cancer--
	-- Step 1: Add the new column
	ALTER TABLE lung_cancer_data
	ADD COLUMN risk_score INTEGER;

	-- Step 2: Using an arbitrary and approximate measure of calculating the risk score
	UPDATE lung_cancer_data
	SET risk_score = (smoking * 2) + (yellow_fingers * 1) + (anxiety * 1) + 
	                 (chronic_disease * 2) + (fatigue * 1) + (wheezing * 2) + 
	                 (alcohol_consuming * 1) + (coughing * 2) + 
	                 (shortness_of_breath * 2) + (swallowing_difficulty * 2) + 
	                 (chest_pain * 2);

	-- Step 3: Displaying the data
	SELECT *
	FROM lung_cancer_data;
	LIMIT 20;


--Query 2: Calculate highest Average Risk Score for Individuals with Lung Cancer by Age Group--
SELECT 
    CASE
        WHEN age BETWEEN 20 AND 30 THEN '20-30'
        WHEN age BETWEEN 31 AND 35 THEN '31-35'
        WHEN age BETWEEN 36 AND 40 THEN '36-40'
        WHEN age BETWEEN 41 AND 45 THEN '41-45'
        WHEN age BETWEEN 46 AND 50 THEN '46-50'
        WHEN age BETWEEN 51 AND 55 THEN '51-55'
        WHEN age BETWEEN 56 AND 60 THEN '56-60'
        WHEN age BETWEEN 61 AND 65 THEN '61-65'
        WHEN age BETWEEN 66 AND 70 THEN '66-70'
        WHEN age BETWEEN 71 AND 75 THEN '71-75'
        WHEN age BETWEEN 76 AND 80 THEN '76-80'
        ELSE 'Above 80'
    END AS age_group,
    AVG(risk_score) AS average_risk_score
FROM 
    lung_cancer_data
WHERE 
    lung_cancer = 'YES'
GROUP BY 
    age_group
ORDER BY 
    average_risk_score DESC;


--Query 3: Find the number of Males & Females Average Risk Score by Gender and they are Smokers:
SELECT
    gender, AVG(risk_score) AS avg_risk_score,
    COUNT(*) AS count_with_lung_cancer_and_smoking
FROM lung_cancer_data
WHERE smoking = 1
  AND lung_cancer = 'YES'
GROUP BY gender
ORDER BY gender;


--Query 4: Compute the top 3 symptoms who have lung cancer for both Males and Females--
WITH symptoms_cte AS (
    SELECT 
        gender,
        symptom,
        SUM(total) AS total,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(total) DESC) AS rn
    FROM (
        SELECT 
            gender,
            'smoking' AS symptom, 
            SUM(CASE WHEN lung_cancer = 'YES' THEN smoking ELSE 0 END) AS total 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'yellow_fingers', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN yellow_fingers ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'anxiety', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN anxiety ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'chronic_disease', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN chronic_disease ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'fatigue', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN fatigue ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'wheezing', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN wheezing ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'alcohol_consuming', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN alcohol_consuming ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'coughing', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN coughing ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'shortness_of_breath', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN shortness_of_breath ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'swallowing_difficulty', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN swallowing_difficulty ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
        UNION ALL
        SELECT 
            gender,
            'chest_pain', 
            SUM(CASE WHEN lung_cancer = 'YES' THEN chest_pain ELSE 0 END) 
        FROM 
            lung_cancer_data 
        GROUP BY
            gender
    ) symptoms
    GROUP BY 
        gender, symptom
)
SELECT
    gender,
    symptom,
    total
FROM symptoms_cte
WHERE rn <= 3
ORDER BY gender Desc, total DESC;







--Query 5: Impact of Peer Pressure and Alcohol Consumption & how it affects Risk Scores:
SELECT
    CASE peer_pressure
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Unknown'
    END AS peer_pressure_label,
    CASE alcohol_consuming
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Unknown'
    END AS alcohol_consuming_label,
    AVG(risk_score) AS avg_risk_score
FROM lung_cancer_data
GROUP BY peer_pressure, alcohol_consuming
ORDER BY peer_pressure, alcohol_consuming;


--Query 6: Determine the correlation between smoking and Lung Cancer.
SELECT 
    CORR(smoking, 
         CASE 
             WHEN lung_cancer = 'YES' THEN 2 
             ELSE 1 
         END) AS smoking_lung_cancer_correlation
FROM 
    lung_cancer_data;












--temporary queries for practice-----
SELECT
    gender,
    CASE
        WHEN age BETWEEN 0 AND 19 THEN '0-19'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age BETWEEN 60 AND 69 THEN '60-69'
        WHEN age >= 70 THEN '70+'
        ELSE 'Unknown'
    END AS age_group,
    lung_cancer,
    COUNT(*) AS count
FROM lung_cancer_data
GROUP BY gender , age_group, lung_cancer
ORDER BY gender, age_group, lung_cancer;

--Query 4: Identify the top 3 symptoms associated with lung cancer--
SELECT symptom, SUM(total) AS total 
FROM (
    SELECT 
        'smoking' AS symptom, 
        SUM(CASE WHEN lung_cancer = 'YES' THEN smoking ELSE 0 END) AS total 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'yellow_fingers', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN yellow_fingers ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'anxiety', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN anxiety ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'chronic_disease', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN chronic_disease ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'fatigue', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN fatigue ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'wheezing', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN wheezing ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'alcohol_consuming', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN alcohol_consuming ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'coughing', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN coughing ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'shortness_of_breath', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN shortness_of_breath ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'swallowing_difficulty', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN swallowing_difficulty ELSE 0 END) 
    FROM 
        lung_cancer_data 
    UNION ALL
    SELECT 
        'chest_pain', 
        SUM(CASE WHEN lung_cancer = 'YES' THEN chest_pain ELSE 0 END) 
    FROM 
        lung_cancer_data 
) symptoms
GROUP BY 
    symptom
ORDER BY 
    total DESC
LIMIT 3;

--PowerBI metrics--
SELECT 
    (SELECT COUNT(*) FROM lung_cancer_data) AS total_records,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE lung_cancer = 'YES') AS total_with_lung_cancer,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE lung_cancer = 'NO') AS total_without_lung_cancer,
    (SELECT AVG(risk_score) FROM lung_cancer_data) AS average_risk_score,
    (SELECT AVG(risk_score) FROM lung_cancer_data WHERE lung_cancer = 'YES') AS average_risk_score_with_lung_cancer,
    (SELECT AVG(risk_score) FROM lung_cancer_data WHERE lung_cancer = 'NO') AS average_risk_score_without_lung_cancer,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE gender = 'M') AS total_males,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE gender = 'F') AS total_females,
    (SELECT AVG(age) FROM lung_cancer_data) AS average_age,
    (SELECT AVG(age) FROM lung_cancer_data WHERE lung_cancer = 'YES') AS average_age_with_lung_cancer,
    (SELECT AVG(age) FROM lung_cancer_data WHERE lung_cancer = 'NO') AS average_age_without_lung_cancer,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE smoking = 1) AS total_smokers,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE smoking = 0) AS total_non_smokers,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE chronic_disease = 1) AS total_with_chronic_disease,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE chronic_disease = 0) AS total_without_chronic_disease,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE fatigue = 1) AS total_with_fatigue,
    (SELECT COUNT(*) FROM lung_cancer_data WHERE fatigue = 0) AS total_without_fatigue;


SELECT
    age_group,
    SUM(chronic_disease) AS chronic_disease_count
FROM (
    SELECT
        CASE
        WHEN age BETWEEN 20 AND 30 THEN '20-30'
        WHEN age BETWEEN 31 AND 35 THEN '31-35'
        WHEN age BETWEEN 36 AND 40 THEN '36-40'
        WHEN age BETWEEN 41 AND 45 THEN '41-45'
        WHEN age BETWEEN 46 AND 50 THEN '46-50'
        WHEN age BETWEEN 51 AND 55 THEN '51-55'
        WHEN age BETWEEN 56 AND 60 THEN '56-60'
        WHEN age BETWEEN 61 AND 65 THEN '61-65'
        WHEN age BETWEEN 66 AND 70 THEN '66-70'
        WHEN age BETWEEN 71 AND 75 THEN '71-75'
        WHEN age BETWEEN 76 AND 80 THEN '76-80'
        ELSE 'Above 80'
        END AS age_group,
        chronic_disease
    FROM lung_cancer_data
) AS age_groups_with_chronic_disease
GROUP BY age_group
ORDER BY age_group;







