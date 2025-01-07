CREATE TABLE Region (
    region_id INT PRIMARY KEY,
    region_name VARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    phone VARCHAR2(15),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);


CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50) NOT NULL,
    price NUMBER(10, 2) NOT NULL,
    release_date DATE NOT NULL
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    customer_id INT REFERENCES Customer(customer_id),
    product_id INT REFERENCES Product(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments CLOB,
    feedback_date DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE Audit_Log (
    log_id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    customer_id INT,
    action_type VARCHAR2(10),
    action_timestamp DATE DEFAULT SYSDATE,
    modified_by VARCHAR2(100),
    old_value VARCHAR2(255),
    new_value VARCHAR2(255),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);


