USE DBA
GO
-- table with masked columns
CREATE TABLE dbo.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL,
	Data DATETIME
);

-- inserting sample data
INSERT INTO dbo.Membership (FirstName, LastName, Phone, Email, DiscountCode, Data)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10, GETDATE()),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5, GETDATE()),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50, GETDATE()),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40, GETDATE());
GO

GRANT UNMASK TO relatorio;

REVOKE UNMASK TO relatorio;

EXECUTE AS USER = 'relatorio'

REVERT


ALTER TABLE dbo.Membership
ALTER COLUMN LastName ADD MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)');

ALTER TABLE dbo.Membership ALTER COLUMN LastName DROP MASKED;

SELECT * FROM Membership
