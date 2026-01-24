ACID properties in SQL Server ensure reliable transactions by maintaining Atomicity, Consistency, Isolation, and Durability. Explore examples using tables like DimProduct and Sales to see them in action.

Here’s a clear explanation of ACID properties in SQL Server with a practical data example so you can see how they work in real transactions.

ACID Properties
ACID stands for:

Atomicity – A transaction is all or nothing. If any part fails, the whole transaction is rolled back.
Consistency – A transaction must leave the database in a valid state according to rules, constraints, and relationships.
Isolation – Transactions run independently without interfering with each other.
Durability – Once a transaction is committed, the changes are permanent, even if the system crashes.
Example in SQL Server
Let’s create a small example with a Bank database.

Sql

Copy code
-- Create sample tables
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolder NVARCHAR(50),
    Balance DECIMAL(10, 2) CHECK (Balance >= 0)
);

INSERT INTO Accounts VALUES
(1, 'Alice', 5000.00),
(2, 'Bob', 3000.00);
GO
1. Atomicity Example
If we transfer money from Alice to Bob, both debit and credit must succeed, or neither happens.

Sql

Copy code
BEGIN TRANSACTION;

BEGIN TRY
    -- Debit Alice
    UPDATE Accounts
    SET Balance = Balance - 1000
    WHERE AccountID = 1;

    -- Credit Bob
    UPDATE Accounts
    SET Balance = Balance + 1000
    WHERE AccountID = 2;

    COMMIT TRANSACTION; -- Both succeed
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION; -- If any fails, rollback
    PRINT 'Transaction failed. Rolled back.';
END CATCH;
If an error occurs (e.g., insufficient balance), no partial update happens.

2. Consistency Example
The CHECK (Balance >= 0) constraint ensures no account can have a negative balance.

Sql

Copy code
BEGIN TRANSACTION;
UPDATE Accounts
SET Balance = Balance - 6000 -- More than Alice has
WHERE AccountID = 1;
COMMIT TRANSACTION; -- This will fail due to constraint
The database remains consistent.

3. Isolation Example
Run these in two different sessions:

Session 1:

Sql

Copy code
BEGIN TRANSACTION;
UPDATE Accounts
SET Balance = Balance - 500
WHERE AccountID = 1;
-- Do not commit yet
Session 2:

Sql

Copy code
SELECT * FROM Accounts WHERE AccountID = 1;
Depending on the isolation level (READ COMMITTED, READ UNCOMMITTED, etc.), Session 2 may or may not see the uncommitted change.

4. Durability Example
Once committed:

Sql

Copy code
BEGIN TRANSACTION;
UPDATE Accounts
SET Balance = Balance + 200
WHERE AccountID = 2;
COMMIT TRANSACTION;
Even if SQL Server crashes right after, the committed change is permanently stored.

✅ Summary Table

Property	Ensures
Atomicity	All or nothing execution
Consistency	Valid state after transaction
Isolation	No interference between transactions
Durability	Changes persist after commit