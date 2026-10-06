-- =====================================================================
-- 00_schema.sql  |  Tables for the defect-rate (DPMO) project
-- Engine: PostgreSQL 16 (analysis queries are written to also run on
-- Amazon Redshift with no or minimal changes).
--
-- The flow of one returned unit:
--   CD  = receiving dock: unit is received and routed
--         (process on this site, or transfer to another returns site)
--   CR  = condition review: an associate grades the unit
--         (sellable as new / discounted sale / escalated)
--   PS  = escalation review: a reviewer checks if the escalation
--         was correct or not
-- =====================================================================

DROP TABLE IF EXISTS corrective_actions, audit_results, audit_queue,
  person_week_dpmo, person_week_flags, base_units,
  ps_review, cr_grading, cd_receiving, employees, managers, calendar_weeks CASCADE;

CREATE TABLE calendar_weeks (
  report_week   INT PRIMARY KEY,          -- 1..12
  week_start    DATE NOT NULL,
  week_end      DATE NOT NULL
);

CREATE TABLE managers (
  manager_login VARCHAR(20) PRIMARY KEY,
  shift         VARCHAR(10) NOT NULL      -- DAY / NIGHT
);

CREATE TABLE employees (
  login              VARCHAR(20) PRIMARY KEY,
  manager_login      VARCHAR(20) NOT NULL REFERENCES managers(manager_login),
  shift              VARCHAR(10) NOT NULL,
  process_start_date DATE NOT NULL,       -- first day in the CR process
  employment_type    VARCHAR(10) NOT NULL -- PERMANENT / AGENCY
);

-- CD: receiving dock
CREATE TABLE cd_receiving (
  unit_id          BIGINT NOT NULL,
  received_ts      TIMESTAMP NOT NULL,
  routing_decision VARCHAR(25) NOT NULL,  -- PROCESS_ON_SITE / TRANSFER_OTHER_SITE
  destination_site VARCHAR(20) NOT NULL   -- SITE_A (this site) / SITE_B
);

-- CR: condition review (grading). A unit can be scanned twice (re-grade),
-- so duplicates are possible and must be removed in the analysis.
CREATE TABLE cr_grading (
  unit_id       BIGINT NOT NULL,
  grade_ts      TIMESTAMP NOT NULL,
  login         VARCHAR(20) NOT NULL,
  grade_outcome VARCHAR(20) NOT NULL      -- SELLABLE_AS_NEW / DISCOUNTED_SALE / ESCALATED
);

-- PS: escalation review
CREATE TABLE ps_review (
  unit_id    BIGINT NOT NULL,
  review_ts  TIMESTAMP NOT NULL,
  ps_login   VARCHAR(20) NOT NULL,
  verdict    VARCHAR(25) NOT NULL         -- CORRECT_ESCALATION / INCORRECT_ESCALATION
);
