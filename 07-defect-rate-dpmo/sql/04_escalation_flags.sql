-- =====================================================================
-- 04_escalation_flags.sql  |  Step 3: who escalates more than the rest?
-- For each associate and week:
--   escalation rate       = escalations / units processed
--   peer escalation rate  = the same rate for EVERYONE ELSE that week
--   flag                  = own rate is at least 10% higher than peers
-- =====================================================================
DROP TABLE IF EXISTS person_week_flags;

CREATE TABLE person_week_flags AS
WITH person_week AS (
    SELECT report_week, login, manager_login, shift, employment_type,
           MAX(tenure_group)                                            AS tenure_group,  -- 'VETERAN' > 'NEW'
           COUNT(*)                                                     AS units_processed,
           SUM(is_escalated)                                            AS escalations,
           SUM(CASE WHEN grade_outcome = 'DISCOUNTED_SALE' THEN 1 ELSE 0 END)  AS discounted_sale,
           SUM(CASE WHEN grade_outcome = 'SELLABLE_AS_NEW' THEN 1 ELSE 0 END)  AS sellable_as_new
    FROM base_units
    GROUP BY report_week, login, manager_login, shift, employment_type
),
with_peers AS (
    SELECT pw.*,
           SUM(escalations)     OVER (PARTITION BY report_week) AS week_escalations,
           SUM(units_processed) OVER (PARTITION BY report_week) AS week_units
    FROM person_week pw
)
SELECT report_week, login, manager_login, shift, employment_type, tenure_group,
       units_processed, escalations, discounted_sale, sellable_as_new,
       1.0 * escalations / units_processed                                         AS escalation_rate,
       1.0 * (week_escalations - escalations) / (week_units - units_processed)    AS peer_escalation_rate,
       CASE WHEN 1.0 * escalations / units_processed
                 >= 1.10 * (1.0 * (week_escalations - escalations) / (week_units - units_processed))
            THEN 1 ELSE 0 END                                                      AS over_escalation_flag
FROM with_peers;

-- Check: units in this table = units in base_units (must match)
SELECT (SELECT SUM(units_processed) FROM person_week_flags) AS units_in_flags,
       (SELECT COUNT(*) FROM base_units)                    AS units_in_base;

-- How many people are flagged each week?
SELECT report_week, SUM(over_escalation_flag) AS people_flagged, COUNT(*) AS people_working
FROM person_week_flags GROUP BY 1 ORDER BY 1;
