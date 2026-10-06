-- =====================================================================
-- 08_reporting_views.sql  |  Step 6: views that feed the Power BI report
-- Rule: DPMO is a ratio, so it is calculated HERE at every reporting level
-- (department, shift, manager, person). Power BI only shows it.
-- A ratio must never be summed or averaged across rows.
-- =====================================================================

-- Department, week by week
DROP VIEW IF EXISTS vw_department_week CASCADE;
CREATE VIEW vw_department_week AS
SELECT d.report_week,
       SUM(d.units_processed)                                                AS units_processed,
       SUM(d.escalations)                                                    AS escalations,
       SUM(d.incorrect_escalations)                                          AS incorrect_escalations,
       ROUND(100.0 * SUM(d.incorrect_escalations) / NULLIF(SUM(d.escalations), 0), 2) AS incorrect_escalation_pct,
       ROUND(1000000.0 * SUM(d.incorrect_escalations) / SUM(d.units_processed), 0)    AS dpmo,
       5000                                                                  AS dpmo_threshold,
       SUM(d.over_escalation_flag)                                           AS people_over_escalating,
       SUM(CASE WHEN d.dpmo > 5000 THEN 1 ELSE 0 END)                        AS people_above_threshold,
       (SELECT COUNT(*) FROM audit_results a WHERE a.audit_week = d.report_week)  AS audits_done,
       (SELECT COUNT(*) FROM audit_results a WHERE a.audit_week = d.report_week AND a.errors_found > 0) AS audits_failed
FROM person_week_dpmo d
GROUP BY d.report_week;

-- By shift
DROP VIEW IF EXISTS vw_shift_week;
CREATE VIEW vw_shift_week AS
SELECT report_week, shift,
       SUM(units_processed)       AS units_processed,
       SUM(escalations)           AS escalations,
       SUM(incorrect_escalations) AS incorrect_escalations,
       ROUND(1000000.0 * SUM(incorrect_escalations) / SUM(units_processed), 0) AS dpmo
FROM person_week_dpmo
GROUP BY report_week, shift;

-- By manager
DROP VIEW IF EXISTS vw_manager_week;
CREATE VIEW vw_manager_week AS
SELECT report_week, manager_login, shift,
       COUNT(*)                   AS people,
       SUM(units_processed)       AS units_processed,
       SUM(escalations)           AS escalations,
       SUM(incorrect_escalations) AS incorrect_escalations,
       ROUND(1000000.0 * SUM(incorrect_escalations) / SUM(units_processed), 0) AS dpmo,
       SUM(CASE WHEN dpmo > 5000 THEN 1 ELSE 0 END) AS people_above_threshold
FROM person_week_dpmo
GROUP BY report_week, manager_login, shift;

-- Incorrect escalations: change over the reporting period
DROP VIEW IF EXISTS vw_incorrect_trend;
CREATE VIEW vw_incorrect_trend AS
SELECT report_week,
       incorrect_escalations,
       incorrect_escalations - LAG(incorrect_escalations) OVER (ORDER BY report_week) AS change_vs_prev_week,
       ROUND(100.0 * (incorrect_escalations - LAG(incorrect_escalations) OVER (ORDER BY report_week))
             / NULLIF(LAG(incorrect_escalations) OVER (ORDER BY report_week), 0), 1)  AS change_vs_prev_week_pct,
       SUM(incorrect_escalations) OVER (ORDER BY report_week ROWS UNBOUNDED PRECEDING) AS cumulative_incorrect
FROM vw_department_week;

-- Segments: tenure group x employment type
DROP VIEW IF EXISTS vw_segment_week;
CREATE VIEW vw_segment_week AS
SELECT report_week, tenure_group, employment_type,
       COUNT(*)                   AS people,
       SUM(units_processed)       AS units_processed,
       SUM(incorrect_escalations) AS incorrect_escalations,
       ROUND(1000000.0 * SUM(incorrect_escalations) / SUM(units_processed), 0) AS dpmo
FROM person_week_dpmo
GROUP BY report_week, tenure_group, employment_type;

-- Top offenders: whole period and the last 4 weeks, with audit history
DROP VIEW IF EXISTS vw_top_offenders;
CREATE VIEW vw_top_offenders AS
WITH last_week AS (SELECT MAX(report_week) AS w FROM calendar_weeks),
person AS (
    SELECT d.login, d.manager_login, d.shift, d.employment_type,
           SUM(d.units_processed)       AS units_processed,
           SUM(d.escalations)           AS escalations,
           SUM(d.incorrect_escalations) AS incorrect_escalations,
           ROUND(1000000.0 * SUM(d.incorrect_escalations) / SUM(d.units_processed), 0) AS dpmo_period,
           ROUND(1000000.0 * SUM(CASE WHEN d.report_week > l.w - 4 THEN d.incorrect_escalations ELSE 0 END)
                 / NULLIF(SUM(CASE WHEN d.report_week > l.w - 4 THEN d.units_processed ELSE 0 END), 0), 0) AS dpmo_last_4_weeks,
           SUM(d.audit_flag)            AS weeks_flagged
    FROM person_week_dpmo d CROSS JOIN last_week l
    GROUP BY d.login, d.manager_login, d.shift, d.employment_type
),
audits AS (
    SELECT login, COUNT(*) AS audits_done,
           SUM(CASE WHEN audit_result = 'FAILED' THEN 1 ELSE 0 END) AS audits_failed,
           MAX(disciplinary_step) AS current_disciplinary_step
    FROM corrective_actions GROUP BY login
)
SELECT RANK() OVER (ORDER BY p.incorrect_escalations DESC) AS offender_rank,
       p.*,
       COALESCE(a.audits_done, 0)               AS audits_done,
       COALESCE(a.audits_failed, 0)             AS audits_failed,
       COALESCE(a.current_disciplinary_step, 0) AS current_disciplinary_step
FROM person p
LEFT JOIN audits a ON a.login = p.login;

-- Corrective actions log
DROP VIEW IF EXISTS vw_corrective_actions;
CREATE VIEW vw_corrective_actions AS
SELECT audit_id, audit_week, login, manager_login, shift,
       escalations_checked, errors_found, audit_result,
       corrective_action, disciplinary_step, logged_in_audit_system, follow_up_audit_week
FROM corrective_actions;

-- Person x week detail (for drill-through)
DROP VIEW IF EXISTS vw_person_week;
CREATE VIEW vw_person_week AS
SELECT report_week, login, manager_login, shift, employment_type, tenure_group,
       units_processed, escalations, incorrect_escalations,
       ROUND(100 * escalation_rate, 2)      AS escalation_rate_pct,
       ROUND(100 * peer_escalation_rate, 2) AS peer_escalation_rate_pct,
       over_escalation_flag, dpmo, audit_flag
FROM person_week_dpmo;
