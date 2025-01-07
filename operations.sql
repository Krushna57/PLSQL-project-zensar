--SQL to aggregate and analyze feedback by rating, product, or region.
--1. Aggregate Feedback by Rating
SELECT 
    rating,
    COUNT(*) AS feedback_count,
    AVG(rating) AS average_rating
FROM 
    Feedback
GROUP BY 
    rating
ORDER BY 
    feedback_count DESC;

--2. Aggregate Feedback by Product
SELECT 
    p.name,
    COUNT(f.feedback_id) AS feedback_count,
    AVG(f.rating) AS average_rating
FROM 
    Feedback f
JOIN 
    Product p ON f.product_id = p.product_id
GROUP BY 
    p.name
ORDER BY 
    feedback_count DESC;

--3. Aggregate Feedback by Region
SELECT 
    r.region_name,
    (SELECT COUNT(*) 
     FROM Feedback f 
     JOIN Customer c ON f.customer_id = c.customer_id
     WHERE c.region_id = r.region_id) AS feedback_count,
    (SELECT AVG(f.rating) 
     FROM Feedback f 
     JOIN Customer c ON f.customer_id = c.customer_id
     WHERE c.region_id = r.region_id) AS average_rating
FROM 
    Region r
ORDER BY 
    feedback_count DESC;

--4. Aggregate Feedback by Product and Region
SELECT 
    p.name AS product_name,
    r.region_name,
    (SELECT COUNT(*) 
     FROM Feedback f 
     JOIN Customer c ON f.customer_id = c.customer_id
     WHERE f.product_id = p.product_id 
     AND c.region_id = r.region_id) AS feedback_count,
    (SELECT AVG(f.rating) 
     FROM Feedback f 
     JOIN Customer c ON f.customer_id = c.customer_id
     WHERE f.product_id = p.product_id 
     AND c.region_id = r.region_id) AS average_rating
FROM 
    Product p
JOIN 
    Region r ON r.region_id BETWEEN 1 AND 10
ORDER BY 
    feedback_count DESC;


--5. Find Most Common Complaints (By Rating)

SELECT 
    f.rating,
    DBMS_LOB.SUBSTR(f.comments, 4000) AS comment_text,
    COUNT(DBMS_LOB.SUBSTR(f.comments, 4000)) AS complaint_count
FROM 
    Feedback f
GROUP BY 
    f.rating, DBMS_LOB.SUBSTR(f.comments, 4000)
ORDER BY 
    complaint_count DESC;


--6. Find Common Complaints in a Specific Region

SELECT 
    f.rating,
    DBMS_LOB.SUBSTR(f.comments, 4000) AS comment_text, 
    COUNT(DBMS_LOB.SUBSTR(f.comments, 4000)) AS complaint_count
FROM 
    Feedback f
JOIN 
    Customer c ON f.customer_id = c.customer_id
JOIN 
    Region r ON c.region_id = r.region_id
WHERE 
    r.region_name = 'North Region'  
GROUP BY 
    f.rating, DBMS_LOB.SUBSTR(f.comments, 4000)
ORDER BY 
    complaint_count DESC;



--after insert trigger on the feedback table ***********************************
CREATE OR REPLACE TRIGGER feedback_insert_trigger
AFTER INSERT ON Feedback
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (customer_id, action_type, action_timestamp, modified_by, old_value, new_value)
    VALUES (
        :new.customer_id,               
        'INSERT',                       
        SYSDATE,                         
        'admin',                         
        NULL,                            
        'New Feedback: ' || :new.rating || ' - ' || :new.comments 
    );
END;

--before update trigger on the feedback table 

CREATE OR REPLACE TRIGGER feedback_update_trigger
BEFORE UPDATE ON Feedback
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (customer_id, action_type, action_timestamp, modified_by, old_value, new_value)
    VALUES (
        :new.customer_id,                
        'UPDATE',                        
        SYSDATE,                        
        'admin',                         
        'Old Feedback: ' || :old.rating || ' - ' || :old.comments, 
        'Updated Feedback: ' || :new.rating || ' - ' || :new.comments 
    );
END;

update feedback set rating=3 where feedback_id = 1;
select * from feedback;

--BEFORE delete trigger on the feedback table
CREATE OR REPLACE TRIGGER feedback_delete_trigger
BEFORE DELETE ON Feedback
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (customer_id, action_type, action_timestamp, modified_by, old_value, new_value)
    VALUES (
        :OLD.customer_id,               
        'DELETE',                       
        SYSDATE,                         
        'admin',                        
        'Deleted Feedback: ' || :OLD.rating || ' - ' || :OLD.comments, 
        NULL                             
    );
END;


--PL/SQL functions to identify the most common complaints.
CREATE OR REPLACE PROCEDURE get_most_common_complaint(
    p_product_id IN INT DEFAULT NULL,  
    p_common_complaint OUT VARCHAR2  
) IS
BEGIN
    p_common_complaint := 'No complaints found';

    SELECT comments
    INTO p_common_complaint
    FROM (
        SELECT comments, COUNT(*) AS comment_count
        FROM Feedback
        WHERE (p_product_id IS NULL OR product_id = p_product_id)
        GROUP BY comments
        ORDER BY comment_count DESC
    )
    WHERE ROWNUM = 1; 

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_common_complaint := 'No complaints found';
    WHEN OTHERS THEN
        p_common_complaint := 'An error occurred';
END get_most_common_complaint;

set serveroutput on
DECLARE
    v_complaint VARCHAR2(255); 
BEGIN
    get_most_common_complaint(p_product_id => 101, p_common_complaint => v_complaint);
    DBMS_OUTPUT.PUT_LINE('Most common complaint for product 101: ' || v_complaint);
END;


set serveroutput on
DECLARE
    v_complaint VARCHAR2(255);
BEGIN
    get_most_common_complaint(p_common_complaint => v_complaint);
    DBMS_OUTPUT.PUT_LINE('Most common complaint: ' || v_complaint);
END;


