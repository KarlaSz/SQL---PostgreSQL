-----------------------
--SQL start
-----------------------
SELECT 
    p.id,
    p.name,
    CASE
        WHEN p.age < 18 THEN 'Minor'
        WHEN p.age BETWEEN 18 AND 65 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group
FROM 
    persons p;
-----------------------
--SQL END
-----------------------


-----------------------
--SQL start
-----------------------
    SELECT 
    u.id,
    u.name,
    item.value AS item_value
FROM 
    users u,
    LATERAL jsonb_array_elements(u.items->'items') AS item(value)
WHERE 
    u.id = 1;

-----------------------
--SQL END
-----------------------


-----------------------
--SQL start
-----------------------