use assignment5db

-- Create Bank Schema
CREATE SCHEMA bank;
GO

-- Create Customer Table

CREATE TABLE bank.Customer (
    Cld INT PRIMARY KEY,
    CName NVARCHAR(50) NOT NULL,
    CEmail NVARCHAR(100) NOT NULL UNIQUE,
    Contact NVARCHAR(255) NOT NULL UNIQUE,
    CPwd AS RIGHT(CName, 2) + LEFT(Contact, 2) PERSISTED
);


-- Create MailInfo Table
CREATE TABLE bank.MailInfo (
    MailTo NVARCHAR(200),
    MailDate DATE,
    MailMessage NVARCHAR(500)
);

-- Create trgMailToCust Trigger
CREATE TRIGGER bank.trgMailToCust
ON bank.Customer
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert records into MailInfo table for each newly added customer
    INSERT INTO bank.MailInfo (MailTo, MailDate, MailMessage)
    SELECT 
        CEmail,
        GETDATE() AS MailDate,
        'Your net banking password is: ' + CPwd + '. It is valid up to 2 days only. Update it.' AS MailMessage
    FROM inserted;
END;


-- Insert Sample Data into Customer Table
INSERT INTO bank.Customer (Cld, CName, CEmail, Contact)
VALUES
    (1001, 'ram', 'ram@gmail.com', '9234567890'),
    (1002, 'krishna', 'krishna@gmail.com', '9876543210'),
    (1003, 'hari', 'hari@gmail.com', '9551234567');


-- Check Records in Customer Table
SELECT * FROM bank.Customer;


-- Check Records in MailInfo Table
SELECT * FROM bank.MailInfo;

