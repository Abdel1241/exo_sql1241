CREATE OR REPLACE VIEW ALL_WORKERS AS
SELECT 
    id AS worker_id,
    first_name,
    last_name,
    age,
    COALESCE(first_day, start_date) AS start_date
FROM (
    SELECT * FROM WORKERS_FACTORY_1
    WHERE last_day IS NULL
    UNION
    SELECT worker_id AS id, first_name, last_name, NULL AS age, start_date, end_date FROM WORKERS_FACTORY_2
    WHERE end_date IS NULL
)
ORDER BY start_date DESC;

CREATE OR REPLACE VIEW ALL_WORKERS_ELAPSED AS
SELECT 
    worker_id,
    first_name,
    last_name,
    age,
    start_date,
    SYSDATE - start_date AS days_elapsed
FROM ALL_WORKERS;

CREATE OR REPLACE VIEW BEST_SUPPLIERS AS
SELECT 
    s.supplier_id,
    s.name,
    SUM(sb.quantity) AS total_pieces
FROM SUPPLIERS s
JOIN SUPPLIERS_BRING_TO_FACTORY_1 sb ON s.supplier_id = sb.supplier_id
GROUP BY s.supplier_id, s.name
HAVING SUM(sb.quantity) > 1000
ORDER BY total_pieces DESC;

CREATE OR REPLACE VIEW ROBOTS_FACTORIES AS
SELECT 
    r.id AS robot_id,
    r.model,
    f.main_location AS factory_location
FROM ROBOTS r
JOIN ROBOTS_FROM_FACTORY rf ON r.id = rf.robot_id
JOIN FACTORIES f ON rf.factory_id = f.id;

