USE [master];

PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [ExpensesDWH]
GO
PRINT N'Creating [ExpensesInmemory]...';


GO
ALTER DATABASE [ExpensesDWH]
    ADD FILEGROUP [ExpensesInmemory] CONTAINS MEMORY_OPTIMIZED_DATA;


GO
ALTER DATABASE [ExpensesDWH]
    ADD FILE (name='expenses_file1', filename='c:\data_expensesdwh_file') 
	TO FILEGROUP [ExpensesInmemory];

USE [ExpensesDWH];


GO

PRINT N'Creating [config]...';


GO
CREATE SCHEMA [config]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [dwh]...';


GO
CREATE SCHEMA [dwh]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [dwh].[FactExpense]...';


GO
CREATE TABLE [dwh].[FactExpense] (
    [IdExpense]         INT             NOT NULL,
    [IdCalendar]        INT             NOT NULL,
    [IdExpenseCategory] SMALLINT        NOT NULL,
    [IdCostCenter]      SMALLINT        NOT NULL,
    [IdEmployee]        INT             NOT NULL,
    [IdReport]          INT             NOT NULL,
    [Amount]            DECIMAL (10, 2) NOT NULL,
    PRIMARY KEY NONCLUSTERED ([IdExpense] ASC),
    INDEX [ExpenseCCI] CLUSTERED COLUMNSTORE
)
WITH (MEMORY_OPTIMIZED = ON);


GO
PRINT N'Creating [dwh].[FactPurchase]...';


GO
CREATE TABLE [dwh].[FactPurchase] (
    [IdPurchaseOrderItem] INT        NOT NULL,
    [IdPurchaseOrder]     INT        NOT NULL,
    [IdProduct]           INT        NOT NULL,
    [IdEmployee]          INT        NOT NULL,
    [IdCalendar]          INT        NOT NULL,
    [Price]               FLOAT (53) NOT NULL,
    [ItemsNumber]         INT        NOT NULL,
    [LineAmount]          FLOAT (53) NOT NULL
);


GO
PRINT N'Creating [dwh].[DimProduct]...';


GO
CREATE TABLE [dwh].[DimProduct] (
    [IdProduct]       INT            NOT NULL,
    [Product]         NVARCHAR (50)  NOT NULL,
    [Description]     NVARCHAR (500) NOT NULL,
    [Price]           FLOAT (53)     NOT NULL,
    [Available]       BIT            NOT NULL,
    [IdCategory]      SMALLINT       NOT NULL,
    [ProductCategory] NVARCHAR (50)  NULL
);


GO
PRINT N'Creating [dwh].[DimExpenseCategory]...';


GO
CREATE TABLE [dwh].[DimExpenseCategory] (
    [IdExpenseCategory] SMALLINT       NOT NULL,
    [ExpenseCategory]   NVARCHAR (50)  NOT NULL,
    [Description]       NVARCHAR (250) NOT NULL
);


GO
PRINT N'Creating [dwh].[DimEmployee]...';


GO
CREATE TABLE [dwh].[DimEmployee] (
    [IdEmployee]    INT            NOT NULL,
    [FirstName]     NVARCHAR (50)  NOT NULL,
    [LastName]      NVARCHAR (50)  NOT NULL,
    [Email]         NVARCHAR (60)  NOT NULL,
    [Identifier]    NVARCHAR (50)  NOT NULL,
    [JobTitle]      NVARCHAR (50)  NOT NULL,
    [IdTeam]        INT            NOT NULL,
    [TeamName]      NVARCHAR (100) NULL,
    [IsTeamManager] BIT            NOT NULL
);


GO
PRINT N'Creating [dwh].[DimCostCenter]...';


GO
CREATE TABLE [dwh].[DimCostCenter] (
    [IdCostCenter] SMALLINT       NOT NULL,
    [CostCenter]   NVARCHAR (50)  NOT NULL,
    [Description]  NVARCHAR (200) NULL
);


GO
PRINT N'Creating [dwh].[DimCalendar]...';


GO
CREATE TABLE [dwh].[DimCalendar] (
    [IdCalendar]      INT          NOT NULL,
    [Date]            DATE         NULL,
    [MonthOfYear]     SMALLINT     NULL,
    [MonthName]       VARCHAR (20) NULL,
    [QuarterOfYear]   SMALLINT     NULL,
    [QuarterName]     VARCHAR (20) NULL,
    [Year]            SMALLINT     NULL,
    [YearName]        VARCHAR (10) NULL,
    [YearMonth]       INT          NULL,
    [YearMonthName]   VARCHAR (30) NULL,
    [YearQuarter]     INT          NULL,
    [YearQuarterName] VARCHAR (30) NULL,
    CONSTRAINT [PK_DimCalendar] PRIMARY KEY CLUSTERED ([IdCalendar] ASC)
);


GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
