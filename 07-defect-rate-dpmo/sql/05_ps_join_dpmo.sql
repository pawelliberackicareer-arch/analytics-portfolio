-- =====================================================================
-- 05_ps_join_dpmo.sql  |  Step 4: was the escalation right? -> DPMO
--   1. Join escalated units with the PS review (one verdict per unit)
--   2. DPMO = incorrect escalations / ALL units processed x 1,000,000
--      (all units, not only escalations)
--   3. Audit trigger: over-escalation flag AND DPMO > 5,000
-- =====================================================================
DROP TABLE IF EXISTS person_week_dpmo;
DROP TABLE IF EXISTS audit_queue;

CREATE TABLE person_week_dpmo AS
WITH ps_dedup AS (
    -- a few units were reviewed twice: keep the latest verdict
    SELECT unit_id, verdict, ps_login,
           ROW_NUMBER() OVER (PARTITION BY unit_id ORDER BY review_ts DESC) AS rn
    FROM ps_review
),
escalation_verdicts AS (
    SELECT b.report_week, b.login,
           COUNT(*)                                                           AS escalations_reviewed,
           SUM(CASE WHEN p.verdict = 'INCORRECT_ESCALATION' THEN 1 ELSE 0 END) AS incorrect_escalations
    FROM base_units b
    JOIN ps_dedup p ON p.unit_id = b.unit_id AND p.rn = 1
    WHERE b.is_escalated = 1
    GROUP BY b.report_week, b.login
)
SELECT f.*,
       COALESCE(v.escalations_reviewed, 0)                                    AS escalations_reviewed,
       COALESCE(v.incorrect_escalations, 0)                                   AS incorrect_escalations,
       ROUND(1000000.0 * COALESCE(v.incorrect_escalations, 0) / f.units_processed, 0) AS dpmo,
       CASE WHEN f.over_escalation_flag = 1
             AND 1000000.0 * COALESCE(v.incorrect_escalations, 0) / f.units_processed > 5000
            THEN 1 ELSE 0 END                                                 AS audit_flag
FROM person_week_flags f
LEFT JOIN escalation_verdicts v
       ON v.report_week = f.report_week AND v.login = f.login;

-- Audit queue: people to audit live at PS in the FOLLOWING week.
-- After an audit the person gets 2 weeks to apply the training, so the next
-- audit can happen 3 weeks later at the earliest (recursive CTE keeps this rule).
CREATE TABLE audit_queue AS
WITH RECURSIVE candidates AS (
    SELECT login, report_week + 1 AS audit_week, report_week AS flagged_week,
           ROW_NUMBER() OVER (PARTITION BY login ORDER BY report_week) AS rn
    FROM person_week_dpmo
    WHERE audit_flag = 1
      AND report_week < (SELECT MAX(report_week) FROM calendar_weeks)
),
chain (login, rn, audit_week, flagged_week, last_audit_week, is_audit) AS (
    SELECT login, rn, audit_week, flagged_week, audit_week, 1
    FROM candidates WHERE rn = 1
    UNION ALL
    SELECT c.login, c.rn, c.audit_week, c.flagged_week,
           CASE WHEN c.audit_week >= ch.last_audit_week + 3 THEN c.audit_week ELSE ch.last_audit_week END,
           CASE WHEN c.audit_week >= ch.last_audit_week + 3 THEN 1 ELSE 0 END
    FROM chain ch
    JOIN candidates c ON c.login = ch.login AND c.rn = ch.rn + 1
)
SELECT ch.audit_week, ch.flagged_week, d.login, d.manager_login, d.shift,
       d.dpmo, d.escalation_rate, d.peer_escalation_rate
FROM chain ch
JOIN person_week_dpmo d ON d.login = ch.login AND d.report_week = ch.flagged_week
WHERE ch.is_audit = 1;

-- Check: every escalation has a verdict (the two numbers must match)
SELECT (SELECT SUM(escalations)          FROM person_week_dpmo) AS escalations,
       (SELECT SUM(escalations_reviewed) FROM person_week_dpmo) AS escalations_with_verdict;
