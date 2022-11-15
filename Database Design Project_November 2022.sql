/*
BUILDING A DATABASE FROM SCRATCH FOR MAVEN BEAR BUILDERS

This is a project for Maven Bear Builders, an online retail store which has just launched their first product. I will be working with the company to help build their data infrastructure to grow their business by creating schemas
and tables, load large datasets to the database, use automation to keep things running smoothly, and tackle some serious issues like secuirty, backup and recovery.

The objectives of this project includes the following:

- Build and maintain the Maven Bear Builder Database
- Ensure data integrity and data quality within the database.
- Enhancing the Database as at when required.
- Leverage automation and backup to plan for long term success.

*/

-- The first step in this process is to create the Database Schema
CREATE SCHEMA mavenbearbuilders;

-- The first record to be entered into our database is the customers'orders and the details of each order. We will proceed by creating an Order Items table.
CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
created_at TIMESTAMP,
order_id INT,
price_usd FLOAT,
cogs_usd FLOAT,
website_session_id INT
);

-- The second table to be created will capture the records of itmes refunded by customers and all records will be entered into the Order Item Refund Table below.
CREATE TABLE order_item_refund (
order_item_refund_id INT PRIMARY KEY,
created_at TIMESTAMP,
order_item_id INT,
order_id INT,
refund_amount_usd FLOAT
);

-- The company provided the raw data stored so far which will be imported into our database schema.
-- We will proceed to import data for the Month of March and April for the year 2012.
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/01.order_items_2012_March.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/02.order_items_2012_April.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- We will also import data for the Order Items Refund Table for the Month of April.
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/03.order_item_refunds_2012_April.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Let's have a preview of the tables created so far
SELECT * FROM order_items;
SELECT * FROM order_item_refund;

-- One of the new staff of the company messed up the order item refund table which were all customer inquiries and not customer returns. These items will be removed from the Order Item Refund Table with the query below.
DELETE FROM order_item_refund
	WHERE order_item_refund_id IN (6, 7, 8, 9, 10);
    
-- Loading the remaining Data for the Year 2012 into the Order Items Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/04.order_items_2012_May-Dec.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading the remaining Data for the Year 2012 into the Order Items Refund Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/05.order_item_refunds_May-Dec.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Let's have a preview of the tables created so far
SELECT * FROM order_items;
SELECT * FROM order_item_refund;

/*
The company is about to launch a new product called The Forever Love Bear to complement The Original Mr. Fuzzy. I was required to create a Products table in the Database which is going each product name and the time each product
was launched.
*/

CREATE TABLE products (
product_id INT PRIMARY KEY,
created_at TIMESTAMP,
product_name VARCHAR(250)
);

-- The next step will be to insert the given records into the Product Table.
INSERT INTO products VALUES
(1, '20-03-09 09:00:00', 'The Original Mr. Fuzzy'),
(2, '2013-01-06 13:00:00', 'Forever Love Bear');

-- Previewing the products Table
SELECT * FROM products;

/* The company requested for linking the items sold on the order items table with the products table to track the sales of each product because the company will begin the sale of multiple products pretty soon. My job here will be 
to alter the order items table to add a column for the products sold and specify the relationship of the order item table and products table. The product_id in the product table is the Primary Key of the the same table and this
column will serve as a Foreign Key for the order items table.
*/

ALTER TABLE order_items
	ADD product_id INT;
    
-- Currently, the product_id column returns Null following its creation. However, all of the sales in our database at the moment are for product 1. Therefore, we will proceed to update each row in the product_id column to 1.
UPDATE order_items
	SET product_id = 1
	WHERE order_item_id BETWEEN 1 AND 2586;
    
-- Previewing the Order Items Table to confirm the adjustments made.
SELECT * FROM order_items;

-- The company have provided us with more data for Q1 2013 for the order items table and order item refund table, and we will import them into the database accordingly.
-- Loading Q1 2013 Data into the Order Item Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/06.order_items_2013_Jan-Mar.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading Q1 2013 Data into the Order Item Refund Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/07.order_item_refunds_2013_Jan-Mar.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- The dataset for Q2 2013 have been provided as well and will be uploaded accordingly.
-- Loading Q2 2013 Data into the Order Item Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/08.order_items_2013_Apr-June.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading Q2 2013 Data into the Order Item Refund Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/09.order_item_refunds_2013_Apr-June.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Order Items Table and Order Item Refund table to confirm all import exercises were carried out successfully.
SELECT * FROM order_items;
SELECT * FROM order_item_refund;

/*
The company is going to start cross-selling products and will want to track whether each item sold is the primary item (the first item put into the user's shopping cart) or a cross-sold item. My task will be to add a column to
the order items table to track this development. The column will be testing for if the column is a primary item and will give a response of 1 (True) or 0 (False).
This column will be useful in tracking if an order contains more than one item or not.
*/

-- Updating the structure of the Order Items Table
ALTER TABLE order_items
	ADD COLUMN primary_item INT;
    
-- Updating all primary_item values to 1
UPDATE order_items
	SET primary_item = 1
    WHERE order_item_id > 0;
    
-- Previewing the order item table to confirm the updates.
SELECT * FROM order_items;

-- The company will proceed to launch two new products and this would be added to our database accordingly.
-- Inserting two new products to the Product Table
INSERT INTO products VALUES
(3, '2013-12-12 09:00:00', 'The Birthday Sugar Panda'),
(4, '2014-02-05 10:00:00', 'The Hudson River Mini Bear');

-- Previewing the products table to see the changes made
SELECT * FROM products;

-- Importing the remaining data into the Order Item Table for the year 2013.
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/10.order_items_2013_Jul-Dec.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Importing the remaining data into the Order Item Refund Table for the year 2013.
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/11.order_item_refunds_2013_Jul-Dec.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing all the tables currently in our dataset.
SELECT * FROM Products;
SELECT * FROM order_items;
SELECT * FROM order_item_refund;

/*The expansion of the company have been a great sight to behold so far. Furthermore, the company would want to have an order summary tables which summarizes all the records from the Order Items table. The idea here is to
populate the order summary table using an aggregation of the data from the order items table. I will begin by creating the table then follow it up by inserting the data from the order items table into the order summary table.
*/

-- Creating an Order Summary Table
CREATE TABLE order_summary (
order_id INT PRIMARY KEY,
created_at TIMESTAMP,
website_session_id INT,
primary_product_id INT,
items_purchased INT,
price_usd FLOAT,
cogs_usd FLOAT
);

-- Populating the Order Summary Table
INSERT INTO order_summary
SELECT 
	order_id,
	MIN(created_at) created_at,
    MIN(website_session_id) website_session_id,
    SUM(CASE WHEN primary_item = 1 THEN product_id
        ELSE NULL
        END) primary_product_id,
	COUNT(order_id) items_purchased,
    SUM(price_usd) price_usd,
    SUM(cogs_usd) cogs_usd
FROM order_items
GROUP BY order_id
ORDER BY order_id;

-- Previewing the Order Summary Table to confirm the updates
SELECT * FROM order_summary;


/*
The next task is to automate entries into the order summary table using the order item table to remove any writing of queries manually going forward. The idea will be to create trigger that insert entries into the order summary
table upon any new entry entered into the order items table.
*/
DROP TRIGGER IF EXISTS order_summary_auto_update;

CREATE TRIGGER order_summary_auto_update
	AFTER INSERT ON order_items
    FOR EACH ROW
    
	REPLACE INTO order_summary
	SELECT 
		order_id,
		MIN(created_at) created_at,
		MIN(website_session_id) website_session_id,
		SUM(CASE WHEN primary_item = 1 THEN product_id
			ELSE NULL
			END) primary_product_id,
		COUNT(order_id) items_purchased,
		SUM(price_usd) price_usd,
		SUM(cogs_usd) cogs_usd
	FROM order_items
	WHERE order_id = NEW.order_id
	GROUP BY order_id
	ORDER BY order_id;
    
-- Loading Jan-Feb 2014 Data into the Order Item Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/12.order_items_2014_Jan-Feb.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading Jan-Feb 2014 Data into the Order Item Refund Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/13.order_item_refunds_2014_Jan-Feb.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Tables to confirm all changes
SELECT * FROM order_items;
SELECT * FROM order_item_refund;
SELECT * FROM order_summary;

/*
The Marketing Lead have provided website sessions data obtained from the website to tie to our database in order to understand which source of marketing the sales are coming from. I will proceed to create a table that captures 
all the data provided.
*/
-- Creating the website table                 
CREATE TABLE website_sessions (
website_session_id INT PRIMARY KEY NOT NULL,
created_at TIMESTAMP NOT NULL,
user_id INT NOT NULL,
is_repeat_session INT,
utm_source VARCHAR(250) NULL,
utm_campaign VARCHAR(250) NULL,
utm_content  VARCHAR(250) NULL,
device_type VARCHAR(250),
http_referer VARCHAR(250)
);

-- Loading data into the website sessison table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/14.website_sessions_2014_Jan.csv" INTO TABLE website_sessions
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/15.website_sessions_2014_Feb.csv" INTO TABLE website_sessions
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the website session table
SELECT * FROM website_sessions;

-- The Marketing Lead have also requested for a creation of a virtual table that shows the website sessions monthly. I will therefore proceed to create a view to capture this information
CREATE VIEW monthly_sessions AS
SELECT
	YEAR(created_at) year,
	MONTHNAME(created_at) month,
	utm_source,
	utm_campaign,
     COUNT(website_session_id) number_of_sessions
FROM website_sessions
GROUP BY utm_source, utm_campaign, month
ORDER BY month DESC;

-- The CEO would love to have a tool in the database for pulling together the total orders and revenue for a given period of time. This can be created using the stored procedure function in SQL.
-- Creating the stored procedure
DROP PROCEDURE IF EXISTS total_order_and_revenue;

 -- Changing the delimiter so it does not affect the query
DELIMITER //

CREATE PROCEDURE total_order_and_revenue
(IN start_date TIMESTAMP, IN end_date TIMESTAMP)

BEGIN 
	SELECT 
		COUNT(order_id) total_order,
		ROUND(SUM(price_usd), 2) total_revenue
	FROM order_summary
	WHERE created_at BETWEEN start_date AND end_date;
END //

-- Reinstating the Delimiter
DELIMITER ; 

-- Querying the stored procedure to confirm its working fine.
CALL total_order_and_revenue('2013-11-01 00:00:00', '2013-12-31 23:59:00');

/*
The Website Manager have provided additional data to import into our database. These data contains webpage activities per session by the customers. The task will be to create a table that capture all of these data and import
the given data into our database.
*/
-- Creating the webpage view table
CREATE TABLE website_pageviews (
	website_pageview_id INT PRIMARY KEY NOT NULL, 
    created_at TIMESTAMP NOT NULL,
    website_session_id INT NOT NULL,
    pageview_url VARCHAR(250) NOT NULL
);

-- Loading data into the Website Pageviews Table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/16.website_pageviews_2014_Feb.csv" INTO TABLE website_pageviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Table
SELECT * FROM website_pageviews;

-- The company have provided data for the Months of March and April 2014 for items ordered, website sessions, website pageviews and items returned by customers. I will proceed to import the data into our dataset accordingly.
-- Loading March and April 2014 data into order items tables
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/17.order_items_2014_Mar.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/18.order_items_2014_Apr.csv" INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading March and April 2014 data into order items refund tables
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/19.order_item_refunds_2014_Mar.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/20.order_item_refunds_2014_Apr.csv" INTO TABLE order_item_refund
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading March and April 2014 data into website sessions table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/21.website_sessions_2014_Mar.csv" INTO TABLE website_sessions
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/22.website_sessions_2014_Apr.csv" INTO TABLE website_sessions
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Loading March and April 2014 data into website pageviews table
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/23.website_pageviews_2014_Mar.csv" INTO TABLE website_pageviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/24.website_pageviews_2014_Apr.csv" INTO TABLE website_pageviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing all the tables updated
SELECT * FROM order_items;
SELECT * FROM order_item_refund;
SELECT * FROM order_summary;
SELECT * FROM website_pageviews;
SELECT * FROM website_sessions;

/*
The company is looking to add chat support to the website. There is a need to design a database plan to track which customers and sessions utilize chat, and which chat representatives serve each customer. I will proceed to 
identify the tables that are to be created, write the necessary queries to create the tables, define the relationship within the new and existing tables while ensuring data quality and data integrity.

Looking at the objectives of the company in this regards, the following tables are going to be created:
- users table that tracks the information of customers that will be making use of the chat support feature 
- support member table that shows the list of employees assigned the role pf chat support
- chat session table which will keep track of each chat sessions
- chat message table that will keep records of individual messages during each chat session.
*/
-- Creating the users Table
CREATE TABLE users (
	user_id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL,
    first_name VARCHAR(250) NOT NULL,
    last_name VARCHAR(250) NOT NULL
);

-- Creating the support member Table
CREATE TABLE support_member (
	support_member_id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL,
    first_name VARCHAR(250) NOT NULL,
    last_name VARCHAR(250) NOT NULL
);

-- Creating the chat session table
CREATE TABLE chat_session (
	chat_session_id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL,
    user_id INT NOT NULL,
    support_member_id INT NOT NULL,
    website_session_id INT NOT NULL
);

-- Creating the chat messages table 
CREATE TABLE chat_message (
	chat_message_id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL,
    chat_session_id INT NOT NULL,
    user_id INT,
    support_member_id INT
    );


-- Creating a stored procedure to allow the CEO to pull a count of chats handled by a chat representative for a given period of time.

DROP PROCEDURE IF EXISTS chats_handled

DELIMITER //

CREATE PROCEDURE chats_handled
(IN support_staff INT, IN start_date TIMESTAMP, IN end_date TIMESTAMP)

BEGIN
	SELECT 
        COUNT(chat_session_id) no_of_chats_handled
	FROM chat_session
    WHERE created_at BETWEEN start_date AND end_date
		AND support_member_id = support_staff;
END //

DELIMITER ;

/*
The company asked that we create a view that shows the monthly order volume and revenue over the years, and a view that shows the monthly website traffic for a potential acquiring company looking to acquire Maven Bear Builders.
*/
-- Creating the Monthly Order Volume and Revenue View
DROP VIEW IF EXISTS monthly_order_and_revenue;

CREATE VIEW monthly_order_and_revenue AS
	SELECT 
		YEAR(created_at) years,
		MONTHNAME(created_at) months,
        COUNT(order_id) total_order,
        ROUND(SUM(price_usd), 2) total_revenue
	FROM order_summary
    GROUP BY 1,2;
    
-- Previewing the Monthly_Order_and_Revenue view
SELECT * FROM monthly_order_and_revenue;

-- Creating the monthly website traffic view
DROP VIEW IF EXISTS monthly_website_traffic;

CREATE VIEW monthly_website_traffic AS
SELECT
	YEAR(created_at) years,
    MONTHNAME(created_at) months,
    COUNT(website_session_id) monthly_traffic
    FROM website_sessions
    GROUP BY 1,2;
    
-- Previewing the Monthly Website Traffic Table
SELECT * FROM monthly_website_traffic;
        
-- The Entire Database will be backed up using MYSQL Dump
-- Thank you!


                


                
                



                
                
            












