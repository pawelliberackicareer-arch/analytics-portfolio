-- =====================================================================
-- 03_base_units.sql  |  Step 2: join the three process stages
--   CD (received on this site) -> CR (graded, latest grade only)
--   + employee data (manager, shift, tenure, employment type)
-- Output: base_units = one row per graded unit
-- =====================================================================
DROP TABLE IF EXISTS base_units;

CREATE TABLE base_units AS
WITH cd AS (
    -- only units that stayed on this site; transfers to another site are not graded here
    SELECT unit_id, MIN(received_ts) AS received_ts
    FROM cd_receiving
    WHERE routing_decision = 'PROCESS_ON_SITE'
    GROUP BY unit_id
),
cr_ranked AS (
    -- a unit can be scanned twice: keep the latest grade only
    SELECT unit_id, grade_ts, login, grade_outcome,
           ROW_NUMBER() OVER (PARTITION BY unit_id ORDER BY grade_ts DESC) AS rn
    FROM cr_grading
)
SELECT cr.unit_id,
       cd.received_ts,
       cr.grade_ts,
       cw.report_week,
       cr.login,
       e.manager_login,
       e.shift,
       e.employment_type,
       (CAST(cr.grade_ts AS DATE) - e.process_start_date) / 7       AS tenure_weeks,   -- Redshift: DATEDIFF(week, e.process_start_date, cr.grade_ts)
       CASE WHEN (CAST(cr.grade_ts AS DATE) - e.process_start_date) / 7 > 5
            THEN 'VETERAN' ELSE 'NEW' END                            AS tenure_group,  -- > 5 weeks in the process = veteran
       cr.grade_outcome,
       CASE WHEN cr.grade_outcome = 'ESCALATED' THEN 1 ELSE 0 END    AS is_escalated
FROM cr_ranked cr
JOIN cd               ON cd.unit_id = cr.unit_id
JOIN employees e      ON e.login = cr.login
JOIN calendar_weeks cw ON CAST(cr.grade_ts AS DATE) BETWEEN cw.week_start AND cw.week_end
WHERE cr.rn = 1;

-- Check: one row per unit (must return 0)
SELECT COUNT(*) - COUNT(DISTINCT unit_id) AS duplicate_rows FROM base_units;

-- Check: every distinct graded unit made it through the joins (both numbers must match)
SELECT (SELECT COUNT(DISTINCT unit_id) FROM cr_grading) AS graded_units,
       (SELECT COUNT(*) FROM base_units)                AS base_units;
