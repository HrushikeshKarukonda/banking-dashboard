
create database Power_BI2;

use Power_BI2;

-- Drop tables if they exist (order due to FK dependencies)
IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions;
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;

-- Customers Table
CREATE TABLE Customers (
    CustomerID     INT PRIMARY KEY,
    Name           NVARCHAR(100),
    Gender         VARCHAR(10) NULL,
    DateOfBirth    VARCHAR(20),          -- to allow mixed formats
    Address        NVARCHAR(200) NULL,
    Email          NVARCHAR(100) NULL,
    Phone          VARCHAR(20),
    AccountID      INT                   -- Not a true FK: dirty data test
);

-- Accounts Table
CREATE TABLE Accounts (
    AccountID   INT PRIMARY KEY,
    CustomerID  INT,                     -- Not a strict FK: allow mismatches
    Type        NVARCHAR(20),
    OpenDate    VARCHAR(20),             -- for mixed formats
    Balance     DECIMAL(18,2)
);

-- Transactions Table
CREATE TABLE Transactions (
    TransactionID    INT,
    AccountID        INT,                -- Can be mismatched for demo
    TransactionDate  VARCHAR(20),        -- Allow mixed formats
    Type             VARCHAR(20),
    Amount           DECIMAL(18,2),
    Description      NVARCHAR(200) NULL,
    Currency         VARCHAR(10)

    -- Not enforcing PK to allow duplicates
);

-- Optionally, create a unique index on TransactionID + AccountID if desired (not included here to allow duplicates)

INSERT INTO Customers (CustomerID, Name, Gender, DateOfBirth, Address, Email, Phone, AccountID) VALUES
(1, 'Ajay Sharma', 'M', '1980-11-04', '123 Main St', NULL, '9891000001', 101),
(2, 'priya singh', NULL, '21-07-1975', '22B Park Road', 'priya@sample.com', '9891000002', 102),
(3, 'Sarah Khan', 'F', '1989/02/20', '', 'sarahkhan@email.com', '9891000003', 103),
(4, 'Mark Lee', 'M', '1995-05-14', '456 North Rd', 'markl@email.com', '9891000004', 104),
(5, 'NAdea KUmar', 'F', '04-12-1982', NULL, NULL, '9891000005', 105);


-- Accounts (outlier balances, inconsistent type case, mixed date formats, invalid CustomerID)
INSERT INTO Accounts (AccountID, CustomerID, Type, OpenDate, Balance) VALUES
(101, 1, 'SAVINGS',    '03/14/2013',      10000.00),
(102, 2, 'current',    '2011-06-20',    -157874.40),
(103, 3, 'Savings',    '2019/11/02',      0.00),
(104, 4, 'CURRENT',    '21-07-2018',        50.00),
(105, 99, 'Savings',   '07-05-2016',       14.75)      -- CustomerID 99 doesn't exist

-- Generate 10,000 synthetic transactions in MySQL (AUTO_INCREMENT TransactionID)
INSERT INTO Transactions (
    AccountID, TransactionDate, Type, Amount, Description, Currency
)
SELECT
    -- Some non-matching AccountIDs
    CASE WHEN seq % 20 = 0 THEN 9999 ELSE 101 + (seq % 100) END AS AccountID,
    
    -- Mixed date formats stored as string (dirty data)
    CASE 
        WHEN seq % 3 = 0 THEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL seq % 365 DAY), '%Y/%m/%d')
        ELSE DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL seq % 365 DAY), '%d-%m-%Y')
    END AS TransactionDate,
    
    -- Inconsistent Type capitalization
    CASE WHEN seq % 2 = 0 THEN 'Credit' ELSE 'DEBIT' END AS Type,
    
    -- Amount with negatives and outliers
    CASE 
        WHEN seq % 1000 = 0 THEN -99999.99
        WHEN seq % 250 = 0 THEN 1000000.99
        ELSE (FLOOR(RAND()*5000)) * (CASE WHEN seq % 2 = 0 THEN 1 ELSE -1 END)
    END AS Amount,
    
    -- NULLs for descriptions, inconsistent case
    CASE 
        WHEN seq % 50 = 0 THEN NULL
        ELSE CASE WHEN seq % 2 = 0 THEN 'payment' ELSE 'Salary Credit' END
    END AS Description,
    
    -- Mixed currency cases
    CASE 
        WHEN seq % 3 = 0 THEN 'usd'
        WHEN seq % 5 = 0 THEN 'INR'
        ELSE 'USD'
    END AS Currency
FROM (
    -- Generate numbers 1 to 10000
    SELECT @rownum := @rownum + 1 AS seq
    FROM information_schema.tables t1,
         information_schema.tables t2,
         (SELECT @rownum := 0) r
    LIMIT 10000
) AS Numbers;

ALTER TABLE Customers MODIFY DateOfBirth VARCHAR(20);
UPDATE Customers
SET DateOfBirth = DATE_FORMAT(
    CASE
        WHEN DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN STR_TO_DATE(DateOfBirth, '%m/%d/%Y')
        WHEN DateOfBirth REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(DateOfBirth, '%Y-%m-%d')
        WHEN DateOfBirth REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' 
            THEN STR_TO_DATE(DateOfBirth, '%Y/%m/%d')
        WHEN DateOfBirth REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
            THEN STR_TO_DATE(DateOfBirth, '%d-%m-%Y')
        WHEN DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN STR_TO_DATE(DateOfBirth, '%d/%m/%Y')
        ELSE NULL
    END,
    '%m/%d/%Y'
)
WHERE DateOfBirth IS NOT NULL;

ALTER TABLE Accounts MODIFY OpenDate VARCHAR(20);
UPDATE Accounts
SET OpenDate = DATE_FORMAT(
    CASE
        WHEN OpenDate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN STR_TO_DATE(OpenDate, '%m/%d/%Y')
        WHEN OpenDate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(OpenDate, '%Y-%m-%d')
        WHEN OpenDate REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' 
            THEN STR_TO_DATE(OpenDate, '%Y/%m/%d')
        WHEN OpenDate REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
            THEN STR_TO_DATE(OpenDate, '%d-%m-%Y')
        WHEN OpenDate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN STR_TO_DATE(OpenDate, '%d/%m/%Y')
        ELSE NULL
    END,
    '%m/%d/%Y'
)
WHERE OpenDate IS NOT NULL;

ALTER TABLE Transactions MODIFY Transactiondate VARCHAR(20);

UPDATE Transactions
SET Transactiondate = DATE_FORMAT(
    CASE
        WHEN Transactiondate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(Transactiondate, '%m/%d/%Y')
        WHEN Transactiondate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(Transactiondate, '%Y-%m-%d')
        WHEN Transactiondate REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' THEN STR_TO_DATE(Transactiondate, '%Y/%m/%d')
        WHEN Transactiondate REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(Transactiondate, '%d-%m-%Y')
        WHEN Transactiondate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(Transactiondate, '%d/%m/%Y')
        ELSE NULL
    END, '%m/%d/%Y'
)
WHERE Transactiondate IS NOT NULL;

CREATE TABLE CombinedBankingDataset AS
SELECT
    t.TransactionID,
    t.AccountID AS Transaction_AccountID,
    t.TransactionDate,
    t.Type AS TransactionType,
    t.Amount,
    t.Description,
    t.Currency,
    a.AccountID AS Account_AccountID,
    a.CustomerID AS Account_CustomerID,
    a.Type AS AccountType,
    a.OpenDate,
    a.Balance,
    c.CustomerID,
    c.Name,
    c.Gender,
    c.DateOfBirth,
    c.Address,
    c.Email,
    c.Phone
FROM
    Transactions t
    LEFT JOIN Accounts a ON t.AccountID = a.AccountID
    LEFT JOIN Customers c ON a.CustomerID = c.CustomerID;
    
select * from CombinedBankingDataset;

SELECT * FROM power_bi2.combinedbankingdataset;
select * from accounts;
select * from customers;
select * from transactions;





