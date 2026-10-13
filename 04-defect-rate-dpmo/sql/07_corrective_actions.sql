-- =====================================================================
-- 07_corrective_actions.sql  |  Step 5: what happens after the audit
--   - audit passed (0 errors)      -> no action
--   - errors found                 -> extra training + next disciplinary
--                                     step + entry in the internal audit log
--   - repeat cases get a stricter step each time
-- =====================================================================
DROP TABLE IF EXISTS corrective_actions;

CREATE TABLE corrective_actions AS
WITH failed AS (
    SELECT a.*,
           ROW_NUMBER() OVER (PARTITION BY login ORDER BY audit_week) AS failed_audit_no
    FROM audit_results a
    WHERE errors_found > 0
)
SELECT a.audit_id, a.audit_week, a.login, a.manager_login, a.shift,
       a.escalations_checked, a.errors_found,
       CASE WHEN a.errors_found = 0 THEN 'PASSED' ELSE 'FAILED' END              AS audit_result,
       COALESCE(f.failed_audit_no, 0)                                            AS failed_audit_no,
       CASE WHEN a.errors_found = 0       THEN 'No action'
            WHEN f.failed_audit_no = 1    THEN 'Retraining + documented coaching'
            WHEN f.failed_audit_no = 2    THEN 'Retraining + first written warning'
            ELSE                               'Retraining + final written warning' END AS corrective_action,
       CASE WHEN a.errors_found = 0 THEN 0 ELSE LEAST(f.failed_audit_no, 3) END  AS disciplinary_step,
       CASE WHEN a.errors_found > 0 THEN 'YES' ELSE 'NO' END                     AS logged_in_audit_system,
       CASE WHEN a.errors_found > 0 THEN a.audit_week + 2 END                    AS follow_up_audit_week
FROM audit_results a
LEFT JOIN failed f ON f.audit_id = a.audit_id;

-- Summary
SELECT audit_result, corrective_action, COUNT(*) AS cases
FROM corrective_actions GROUP BY 1, 2 ORDER BY 1, 2;
