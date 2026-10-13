-- =====================================================================
-- 01_seed_synthetic_data.sql  |  Creates SYNTHETIC data (PostgreSQL)
-- No real data. Numbers are tuned to look like the real situation:
-- ~25% of escalations are incorrect before the programme starts in week 4,
-- then the share falls week by week.
-- (generate_series / random() are PostgreSQL functions; this file is only
--  for building the demo data, the analysis files do not depend on them.)
-- =====================================================================
SELECT setseed(0.42);

-- 12 reporting weeks
INSERT INTO calendar_weeks
SELECT w, DATE '2026-01-05' + (w-1)*7, DATE '2026-01-05' + (w-1)*7 + 6
FROM generate_series(1,12) w;

-- 6 managers: 3 per shift
INSERT INTO managers VALUES
 ('mgr_01','DAY'),('mgr_02','DAY'),('mgr_03','DAY'),
 ('mgr_04','NIGHT'),('mgr_05','NIGHT'),('mgr_06','NIGHT');

-- 72 associates, 12 per manager. ~20% join during the period (new hires).
INSERT INTO employees
SELECT 'assoc_' || LPAD(i::TEXT,3,'0'),
       'mgr_0' || (((i-1)/12)+1),
       CASE WHEN ((i-1)/12)+1 <= 3 THEN 'DAY' ELSE 'NIGHT' END,
       CASE WHEN random() < 0.2
            THEN DATE '2026-01-05' + (floor(random()*56))::INT          -- joins in weeks 1-8
            ELSE DATE '2026-01-05' - (7 + floor(random()*280))::INT END,  -- already in process
       CASE WHEN random() < 0.6 THEN 'PERMANENT' ELSE 'AGENCY' END
FROM generate_series(1,72) i;

-- Hidden behaviour profile per associate (used only to generate data)
DROP TABLE IF EXISTS _profile;
CREATE TEMP TABLE _profile AS
SELECT login,
       over_esc,
       0.025 + random()*0.02                                    AS base_esc_rate,
       CASE WHEN over_esc THEN 0.04 + random()*0.05 ELSE 0 END  AS extra_esc_rate,
       CASE WHEN over_esc THEN 0.38 + random()*0.22
            ELSE 0.06 + random()*0.10 END                       AS base_wrong_share
FROM (SELECT login, random() < 0.18 AS over_esc FROM employees) x;

-- Programme effect: no change in weeks 1-3, then a steady fall from week 4
DROP TABLE IF EXISTS _week_factor;
CREATE TEMP TABLE _week_factor AS
SELECT report_week,
       CASE WHEN report_week <= 3 THEN 1.0
            ELSE GREATEST(0.07, 1 - 0.135*(report_week-3)) END AS f
FROM calendar_weeks;

-- One row per unit graded (associate x week x n units)
DROP TABLE IF EXISTS _units;
CREATE TEMP TABLE _units AS
SELECT row_number() OVER () + 1000000                          AS unit_id,
       aw.login, aw.report_week,
       aw.week_start + (random()*5)::INT + (random()*0.45 + CASE WHEN e.shift='DAY' THEN 0.27 ELSE 0.77 END) * INTERVAL '1 day' AS grade_ts,
       random() AS r_esc, random() AS r_grade, random() AS r_wrong,
       aw.esc_rate, aw.wrong_share
FROM (
  SELECT e.login, w.report_week, cw.week_start,
         (400 + floor(random()*300))::INT AS n_units,
         p.base_esc_rate + p.extra_esc_rate * w.f AS esc_rate,
         LEAST(0.95, (p.base_wrong_share
           + CASE WHEN cw.week_start - e.process_start_date <= 35 THEN 0.08 ELSE 0 END) * w.f) AS wrong_share
  FROM employees e
  JOIN _profile p      ON p.login = e.login
  CROSS JOIN _week_factor w
  JOIN calendar_weeks cw ON cw.report_week = w.report_week
  WHERE e.process_start_date <= cw.week_end
) aw
JOIN employees e ON e.login = aw.login
CROSS JOIN LATERAL generate_series(1, aw.n_units) g;

-- CR grading
INSERT INTO cr_grading
SELECT unit_id, grade_ts, login,
       CASE WHEN r_esc < esc_rate THEN 'ESCALATED'
            WHEN r_grade < 0.30   THEN 'DISCOUNTED_SALE'
            ELSE 'SELLABLE_AS_NEW' END
FROM _units;

-- ~0.8% re-scans: same unit graded again a few minutes later (duplicates)
INSERT INTO cr_grading
SELECT unit_id, grade_ts + INTERVAL '7 minutes', login, grade_outcome
FROM cr_grading WHERE random() < 0.008;

-- CD receiving: every graded unit was received on this site first
INSERT INTO cd_receiving
SELECT unit_id, grade_ts - (2 + random()*28) * INTERVAL '1 hour', 'PROCESS_ON_SITE', 'SITE_A'
FROM _units;

-- ...plus units that were transferred to another returns site (never graded here)
INSERT INTO cd_receiving
SELECT 5000000 + g, TIMESTAMP '2026-01-05' + random()*84 * INTERVAL '1 day',
       'TRANSFER_OTHER_SITE', 'SITE_B'
FROM generate_series(1, 160000) g;

-- PS review: every escalated unit gets a verdict
INSERT INTO ps_review
SELECT unit_id, grade_ts + (1 + random()*20) * INTERVAL '1 hour',
       'ps_' || LPAD((1 + floor(random()*8))::INT::TEXT, 2, '0'),
       CASE WHEN r_wrong < wrong_share THEN 'INCORRECT_ESCALATION' ELSE 'CORRECT_ESCALATION' END
FROM _units WHERE r_esc < esc_rate;

-- ~0.3% double reviews (same verdict logged twice)
INSERT INTO ps_review
SELECT unit_id, review_ts + INTERVAL '3 minutes', ps_login, verdict
FROM ps_review WHERE random() < 0.003;

ANALYZE;
