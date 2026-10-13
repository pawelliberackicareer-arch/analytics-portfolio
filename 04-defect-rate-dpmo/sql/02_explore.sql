-- =====================================================================
-- 02_explore.sql  |  Step 1: look at the data before building anything
-- =====================================================================

-- What does one row look like in each table?
SELECT * FROM cd_receiving ORDER BY received_ts LIMIT 5;
SELECT * FROM cr_grading   ORDER BY grade_ts    LIMIT 5;
SELECT * FROM ps_review    ORDER BY review_ts   LIMIT 5;

-- How many rows, and how many distinct units? (row count > distinct units = duplicates)
SELECT 'cd_receiving' AS tbl, COUNT(*) AS row_count, COUNT(DISTINCT unit_id) AS distinct_units FROM cd_receiving
UNION ALL
SELECT 'cr_grading',   COUNT(*), COUNT(DISTINCT unit_id) FROM cr_grading
UNION ALL
SELECT 'ps_review',    COUNT(*), COUNT(DISTINCT unit_id) FROM ps_review;

-- How are units routed at the receiving dock?
SELECT routing_decision, destination_site, COUNT(*) AS units
FROM cd_receiving
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Grade outcomes in CR
SELECT grade_outcome, COUNT(*) AS units,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM cr_grading
GROUP BY 1
ORDER BY 2 DESC;

-- PS verdicts
SELECT verdict, COUNT(*) AS units FROM ps_review GROUP BY 1;
