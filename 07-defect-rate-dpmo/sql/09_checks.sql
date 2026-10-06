-- =====================================================================
-- 09_checks.sql  |  Final checks: do the numbers agree at every level?
-- Every row should return check_ok = true.
-- =====================================================================
SELECT 'units: base vs department view' AS check_name,
       (SELECT COUNT(*) FROM base_units) = (SELECT SUM(units_processed) FROM vw_department_week) AS check_ok
UNION ALL
SELECT 'incorrect escalations: PS (deduplicated) vs department view',
       (SELECT COUNT(*) FROM (SELECT DISTINCT unit_id FROM ps_review WHERE verdict = 'INCORRECT_ESCALATION') x)
     = (SELECT SUM(incorrect_escalations) FROM vw_department_week)
UNION ALL
SELECT 'shift view adds up to department',
       (SELECT SUM(incorrect_escalations) FROM vw_shift_week) = (SELECT SUM(incorrect_escalations) FROM vw_department_week)
UNION ALL
SELECT 'manager view adds up to department',
       (SELECT SUM(units_processed) FROM vw_manager_week) = (SELECT SUM(units_processed) FROM vw_department_week)
UNION ALL
SELECT 'one row per person per week',
       (SELECT COUNT(*) FROM person_week_dpmo) = (SELECT COUNT(*) FROM (SELECT DISTINCT login, report_week FROM person_week_dpmo) x)
UNION ALL
SELECT 'every audit has an action record',
       (SELECT COUNT(*) FROM audit_results) = (SELECT COUNT(*) FROM corrective_actions);
