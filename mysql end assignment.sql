-- 1. DATABASE & TABLE CREATION
DROP DATABASE IF EXISTS ecomm;
CREATE DATABASE ecomm;
USE ecomm;

CREATE TABLE customer_churn(
    CustomerID INT PRIMARY KEY,
    Churn BIT,
    Tenure INT,
    PreferredLoginDevice VARCHAR(20),
    CityTier INT,
    WarehouseToHome INT,
    PreferredPaymentMode VARCHAR(20),
    Gender VARCHAR(10),
    HourSpendOnApp INT,
    NumberOfDeviceRegistered INT,
    PreferredOrderCat VARCHAR(20),
    SatisfactionScore INT,
    MaritalStatus VARCHAR(10),
    NumberOfAddress INT,
    Complain BIT,
    OrderAmountHikeFromlastYear INT,
    CouponUsed INT,
    OrderCount INT,
    DaySinceLastOrder INT,
    CashbackAmount INT
);

-- DATA INSERTION (Sample Data)
INSERT INTO customer_churn (CustomerID, Churn, Tenure, PreferredLoginDevice, CityTier, WarehouseToHome, PreferredPaymentMode, Gender, HourSpendOnApp, NumberOfDeviceRegistered, PreferredOrderCat, SatisfactionScore, MaritalStatus, NumberOfAddress, Complain, OrderAmountHikeFromlastYear, CouponUsed, OrderCount, DaySinceLastOrder, CashbackAmount) VALUES
(50001, 1, 4, 'Mobile Phone', 3, 6, 'Debit Card', 'Female', 3, 3, 'Laptop & Accessory', 2, 'Single', 9, 1, 11, 1, 1, 5, 160),
(50002, NULL, 1, 'Phone', 1, 8, 'UPI', 'Male', 3, 3, 'Mobile Phone', 3, 'Single', 7, 1, 15, 0, 1, 0, 121),
(50003, NULL, 1, 'Phone', 1, 30, 'Debit Card', 'Male', 2, 4, 'Mobile', 3, 'Single', 6, 1, 14, 0, 1, 3, 120),
(50004, 1, 0, 'Phone', 3, 15, 'Debit Card', 'Male', 2, 4, 'Laptop & Accessory', 5, 'Single', 8, 0, 23, 0, 1, 3, 134),
(50005, 1, 0, 'Phone', 1, 12, 'CC', 'Male', NULL, 3, 'Mobile', 5, 'Single', 3, 0, 11, 1, 1, 3, 130),
(50006, 1, 0, 'Computer', 1, 22, 'Debit Card', 'Female', 3, 5, 'Mobile Phone', 5, 'Single', 2, 1, 22, 4, 6, 7, 139),
(50007, 1, NULL, 'Phone', 3, 11, 'Cash on Delivery', 'Male', 2, 3, 'Laptop & Accessory', 2, 'Divorced', 4, 0, 14, 0, 1, 0, 121),
(50008, 1, NULL, 'Phone', 1, 6, 'CC', 'Male', 3, 3, 'Mobile', 2, 'Divorced', 3, 1, 16, 2, 2, 0, 123),
(50009, 1, 13, 'Phone', 3, 9, 'E wallet', 'Male', NULL, 4, 'Mobile', 3, 'Divorced', 2, 1, 14, 0, 1, 2, 127),
(50010, 1, NULL, 'Phone', 1, 31, 'Debit Card', 'Male', 2, 5, 'Mobile', 3, 'Single', 2, 0, 12, 1, 1, 1, 123),
(50011, 1, 4, 'Mobile Phone', 1, 18, 'Cash on Delivery', 'Female', 2, 3, 'Others', 3, 'Divorced', 2, 0, NULL, 9, 15, 8, 295),
(50012, 1, 11, 'Mobile Phone', 1, 6, 'Debit Card', 'Male', 3, 4, 'Fashion', 3, 'Single', 10, 1, 13, 0, 1, 0, 154),
(50013, 1, 0, 'Phone', 1, 11, 'COD', 'Male', 2, 3, 'Mobile', 3, 'Single', 2, 1, 13, 2, 2, 2, 134),
(50014, 1, 0, 'Phone', 1, 15, 'CC', 'Male', 3, 4, 'Mobile', 3, 'Divorced', 1, 1, 17, 0, 1, 0, 134),
(50015, 1, 9, 'Mobile Phone', 3, 15, 'Credit Card', 'Male', 3, 4, 'Fashion', 2, 'Single', 2, 0, 16, 0, 4, 7, 196),
(50016, 1, NULL, 'Phone', 2, 12, 'UPI', 'Male', 3, 3, 'Mobile', 5, 'Married', 5, 1, 22, 1, 1, 2, 121),
(50017, 1, 0, 'Computer', 1, 12, 'Debit Card', 'Female', NULL, 4, 'Mobile', 2, 'Single', 2, 1, 18, 1, 1, 0, 129),
(50018, 1, 0, 'Mobile Phone', 3, 11, 'E wallet', 'Male', 2, 4, 'Laptop & Accessory', 3, 'Single', 2, 1, 11, 1, 1, 3, 157),
(50019, 1, 0, 'Computer', 1, 13, 'Debit Card', 'Male', 3, 5, 'Laptop & Accessory', 3, 'Single', 2, 1, 24, 1, 1, 6, 161),
(50020, 1, 19, 'Mobile Phone', 1, 20, 'Debit Card', 'Female', 3, 3, 'Mobile Phone', 4, 'Divorced', 10, 1, 18, 1, 4, 3, 150);

SET SQL_SAFE_UPDATES = 0;

-- 2. DATA CLEANING
UPDATE customer_churn
SET 
    WarehouseToHome = ROUND((SELECT AVG(WarehouseToHome) FROM (SELECT * FROM customer_churn) AS temp)),
    HourSpendOnApp = ROUND((SELECT AVG(HourSpendOnApp) FROM (SELECT * FROM customer_churn) AS temp)),
    OrderAmountHikeFromlastYear = ROUND((SELECT AVG(OrderAmountHikeFromlastYear) FROM (SELECT * FROM customer_churn) AS temp)),
    DaySinceLastOrder = ROUND((SELECT AVG(DaySinceLastOrder) FROM (SELECT * FROM customer_churn) AS temp))
WHERE WarehouseToHome IS NULL 
   OR HourSpendOnApp IS NULL 
   OR OrderAmountHikeFromlastYear IS NULL 
   OR DaySinceLastOrder IS NULL;

UPDATE customer_churn
SET 
    Tenure = (SELECT Tenure FROM (SELECT Tenure FROM customer_churn WHERE Tenure IS NOT NULL GROUP BY Tenure ORDER BY COUNT(*) DESC LIMIT 1) AS temp),
    CouponUsed = (SELECT CouponUsed FROM (SELECT CouponUsed FROM customer_churn WHERE CouponUsed IS NOT NULL GROUP BY CouponUsed ORDER BY COUNT(*) DESC LIMIT 1) AS temp),
    OrderCount = (SELECT OrderCount FROM (SELECT OrderCount FROM customer_churn WHERE OrderCount IS NOT NULL GROUP BY OrderCount ORDER BY COUNT(*) DESC LIMIT 1) AS temp)
WHERE Tenure IS NULL OR CouponUsed IS NULL OR OrderCount IS NULL;

DELETE FROM customer_churn 
WHERE WarehouseToHome > 100;

UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

UPDATE customer_churn
SET PreferredOrderCat = 'Mobile Phone'
WHERE PreferredOrderCat = 'Mobile';

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

-- 3. DATA TRANSFORMATION
ALTER TABLE customer_churn 
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

ALTER TABLE customer_churn 
ADD COLUMN ComplaintReceived VARCHAR(10);

UPDATE customer_churn
SET ComplaintReceived = CASE 
    WHEN Complain = 1 THEN 'Yes'
    ELSE 'No'
END;

ALTER TABLE customer_churn 
ADD COLUMN ChurnStatus VARCHAR(20);

UPDATE customer_churn
SET ChurnStatus = CASE 
    WHEN Churn = 1 THEN 'Churned'
    ELSE 'Active'
END;

ALTER TABLE customer_churn 
DROP COLUMN Churn,
DROP COLUMN Complain;

-- 4. DATA EXPLORATION & ANALYSIS 
SELECT ChurnStatus, COUNT(*) as CustomerCount FROM customer_churn GROUP BY ChurnStatus;
SELECT AVG(Tenure) AS AvgTenure, SUM(CashbackAmount) AS TotalCashback FROM customer_churn WHERE ChurnStatus = 'Churned';
SELECT (COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0 / COUNT(*)) AS ComplaintPercentage FROM customer_churn WHERE ChurnStatus = 'Churned';
SELECT CityTier, COUNT(*) as ChurnCount FROM customer_churn WHERE ChurnStatus = 'Churned' AND PreferredOrderCat = 'Laptop & Accessory' GROUP BY CityTier ORDER BY ChurnCount DESC LIMIT 1;
SELECT PreferredPaymentMode, COUNT(*) as Count FROM customer_churn WHERE ChurnStatus = 'Active' GROUP BY PreferredPaymentMode ORDER BY Count DESC LIMIT 1;
SELECT SUM(OrderAmountHikeFromlastYear) AS TotalHike FROM customer_churn WHERE MaritalStatus = 'Single' AND PreferredLoginDevice = 'Mobile Phone';
SELECT AVG(NumberOfDeviceRegistered) AS AvgDevices FROM customer_churn WHERE PreferredPaymentMode = 'UPI';
SELECT CityTier, COUNT(*) as TotalCustomers FROM customer_churn GROUP BY CityTier ORDER BY TotalCustomers DESC LIMIT 1;
SELECT Gender, SUM(CouponUsed) AS TotalCoupons FROM customer_churn GROUP BY Gender ORDER BY TotalCoupons DESC LIMIT 1;
SELECT PreferredOrderCat, COUNT(*) AS CustomerCount, MAX(HoursSpentOnApp) AS MaxHours FROM customer_churn GROUP BY PreferredOrderCat;
SELECT SUM(OrderCount) AS TotalOrders FROM customer_churn WHERE PreferredPaymentMode = 'Credit Card' AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);
SELECT AVG(SatisfactionScore) AS AvgSatisfaction FROM customer_churn WHERE ComplaintReceived = 'Yes';
SELECT PreferredOrderCat, COUNT(*) as Count FROM customer_churn WHERE CouponUsed > 5 GROUP BY PreferredOrderCat ORDER BY Count DESC LIMIT 1;
SELECT PreferredOrderCat, AVG(CashbackAmount) AS AvgCashback FROM customer_churn GROUP BY PreferredOrderCat ORDER BY AvgCashback DESC LIMIT 3;
SELECT DISTINCT PreferredPaymentMode FROM customer_churn WHERE Tenure = 10 AND OrderCount > 500;
SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus;
SELECT * FROM customer_churn WHERE MaritalStatus = 'Married' AND CityTier = 1 AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);

-- 5. CUSTOMER RETURNS TABLE 
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

SELECT 
    cr.ReturnID, 
    cr.ReturnDate, 
    cr.RefundAmount,
    cc.*
FROM customer_returns cr
JOIN customer_churn cc ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned' 
AND cc.ComplaintReceived = 'Yes';