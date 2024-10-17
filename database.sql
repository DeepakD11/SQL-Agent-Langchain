
CREATE DATABASE SalesOrderSchema;

USE SalesOrderSchema;

CREATE TABLE Customer (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100),
  LastName VARCHAR(100),
  Email VARCHAR(255),
  Phone VARCHAR(20),
  BillingAddress TEXT,
  ShippingAddress TEXT,
  CustomerSince DATE,
  IsActive BOOLEAN
);

CREATE TABLE SalesOrder (
  SalesOrderID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  RequiredDate DATE,
  ShippedDate DATE,
  Status VARCHAR(50),
  Comments TEXT,
  PaymentMethod VARCHAR(50),
  IsPaid BOOLEAN,
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Product (
  ProductID INT AUTO_INCREMENT PRIMARY KEY,
  ProductName VARCHAR(255),
  Description TEXT,
  UnitPrice DECIMAL(10, 2),
  StockQuantity INT,
  ReorderLevel INT,
  Discontinued BOOLEAN
);

CREATE TABLE LineItem (
  LineItemID INT AUTO_INCREMENT PRIMARY KEY,
  SalesOrderID INT,
  ProductID INT,
  Quantity INT,
  UnitPrice DECIMAL(10, 2),
  Discount DECIMAL(10, 2),
  TotalPrice DECIMAL(10, 2),
  FOREIGN KEY (SalesOrderID) REFERENCES SalesOrder(SalesOrderID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Employee (
  EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100),
  LastName VARCHAR(100),
  Email VARCHAR(255),
  Phone VARCHAR(20),
  HireDate DATE,
  Position VARCHAR(100),
  Salary DECIMAL(10, 2)
);

CREATE TABLE Supplier (
  SupplierID INT AUTO_INCREMENT PRIMARY KEY,
  CompanyName VARCHAR(255),
  ContactName VARCHAR(100),
  ContactTitle VARCHAR(50),
  Address TEXT,
  Phone VARCHAR(20),
  Email VARCHAR(255)
);

CREATE TABLE InventoryLog (
  LogID INT AUTO_INCREMENT PRIMARY KEY,
  ProductID INT,
  ChangeDate DATE,
  QuantityChange INT,
  Notes TEXT,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
   