-- Run the whole project in order (psql):  psql -d <database> -f run_all.sql
\i 00_schema.sql
\i 01_seed_synthetic_data.sql
\i 02_explore.sql
\i 03_base_units.sql
\i 04_escalation_flags.sql
\i 05_ps_join_dpmo.sql
\i 06_simulate_audit_results.sql
\i 07_corrective_actions.sql
\i 08_reporting_views.sql
\i 09_checks.sql
