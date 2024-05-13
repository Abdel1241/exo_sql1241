CREATE OR REPLACE FUNCTION GET_NB_WORKERS(factory_id NUMBER) RETURN NUMBER AS
    total_workers NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_workers
    FROM WORKERS_FACTORY_1 wf1
    JOIN ROBOTS_FROM_FACTORY rf ON wf1.id = rf.factory_id
    WHERE rf.factory_id = factory_id;
    
    RETURN total_workers;
END;

CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER AS
    total_robots NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_robots
    FROM (
        SELECT robot_id
        FROM ROBOTS_HAS_SPARE_PARTS
        GROUP BY robot_id
        HAVING COUNT(spare_part_id) > 3
    );
    
    RETURN total_robots;
END;

CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 AS
    supplier_name VARCHAR2(100);
BEGIN
    SELECT name INTO supplier_name
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1;
    
    RETURN supplier_name;
END;

CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(nb_workers NUMBER, factory_id NUMBER) AS
BEGIN
    FOR i IN 1..nb_workers LOOP
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, first_day)
        VALUES (
            'worker_f_' || i,
            'worker_l_' || i,
            TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J')
        );
    END LOOP;
    COMMIT;
END;

