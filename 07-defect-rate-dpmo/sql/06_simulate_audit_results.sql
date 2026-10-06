-- =====================================================================
-- 06_simulate_audit_results.sql  |  SYNTHETIC stand-in for the auditors
-- In real life an auditor stands next to the associate and checks their
-- escalations live, then records the result. Here we simulate that record:
-- the chance of an error in the audit follows the person's real incorrect
-- share in the flagged week.
-- =====================================================================
DROP TABLE IF EXISTS audit_results;
SELECT setseed(0.7);

CREATE TABLE audit_results AS
SELECT ROW_NUMBER() OVER (ORDER BY q.audit_week, q.login)            AS audit_id,
       q.audit_week, q.flagged_week, q.login, q.manager_login, q.shift,
       'auditor_0' || (1 + FLOOR(random()*3))::INT                   AS auditor_login,
       x.checked                                                      AS escalations_checked,
       (SELECT COUNT(*) FROM generate_series(1, x.checked) g
        WHERE random() < 1.0 * d.incorrect_escalations / NULLIF(d.escalations, 0))  AS errors_found
FROM audit_queue q
JOIN person_week_dpmo d ON d.login = q.login AND d.report_week = q.flagged_week
CROSS JOIN LATERAL (SELECT (12 + FLOOR(random()*14))::INT AS checked) x;
