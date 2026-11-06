-- goit-rdb-hw-04: SQL queries

-- ========== 1. DDL: LibraryManagement ==========

CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

-- authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- genres table
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

-- books table (depends on authors and genres)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publication_year INT,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100)
);

-- borrowed_books table (depends on books and users)
CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 2. DML: test data ==========

INSERT INTO authors (author_name) VALUES 
('Taras Shevchenko'),
('Lesia Ukrainka'),
('Ivan Franko');

INSERT INTO genres (genre_name) VALUES 
('Poetry'),
('Drama'),
('Novel');

INSERT INTO books (title, publication_year, author_id, genre_id) VALUES 
('Kobzar', 1840, 1, 1),
('Lisova Pisnia', 1911, 2, 2),
('Zakhar Berkut', 1883, 3, 3);

INSERT INTO users (username, email) VALUES 
('ivan_student', 'ivan@example.com'),
('maria_reader', 'maria@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES 
(1, 1, '2024-01-15', '2024-02-15'),
(2, 2, '2024-02-01', NULL),
(3, 1, '2024-03-01', '2024-03-20');

-- ========== 3. INNER JOIN 8 tables (DB from HW-03) ==========

USE goit_rdb_hw_03;

SELECT 
    od.id AS order_detail_id,
    od.quantity,
    o.id AS order_id,
    o.date AS order_date,
    c.name AS customer_name,
    c.country AS customer_country,
    p.name AS product_name,
    p.price,
    cat.name AS category_name,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    sh.name AS shipper_name,
    sup.name AS supplier_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id;

-- ========== 4.1 COUNT rows ==========

SELECT COUNT(*) AS total_rows
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id;

-- ========== 4.2 INNER -> LEFT / RIGHT ==========

-- Простий приклад для порівняння типів JOIN:

-- INNER JOIN (тільки рядки зі співпадінням в обох таблицях)
SELECT COUNT(*) AS inner_join_count
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id;

-- LEFT JOIN (всі orders, навіть якщо немає відповідного employee)
SELECT COUNT(*) AS left_join_count
FROM orders o
LEFT JOIN employees e ON o.employee_id = e.employee_id;

-- RIGHT JOIN (всі employees, навіть якщо вони не обробляли замовлень)
SELECT COUNT(*) AS right_join_count
FROM orders o
RIGHT JOIN employees e ON o.employee_id = e.employee_id;

-- ========== 4.3 employee_id > 3 AND <= 10 ==========

SELECT 
    od.id AS order_detail_id,
    o.id AS order_id,
    e.employee_id,
    e.first_name,
    e.last_name,
    p.name AS product_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- ========== 4.4 GROUP BY category_name: COUNT, AVG(quantity) ==========

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
GROUP BY cat.name;

-- ========== 4.5 HAVING AVG(quantity) > 21 ==========

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21;

-- ========== 4.6 ORDER BY count DESC ==========

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC;

-- ========== 4.7 LIMIT 4 OFFSET 1 ==========

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;
