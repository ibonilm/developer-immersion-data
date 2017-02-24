/* 
Before execute the script, find and replace the name of the data base to be used as source to populate the DWH  
[Expenses] --> [Expenses]
*/

USE [ExpensesDWH]
GO

/* DIM TABLES */

-- [dwh].[DimProduct]
TRUNCATE TABLE [dwh].[DimProduct]

INSERT INTO [dwh].[DimProduct]
           ([IdProduct]
           ,[Product]
           ,[Description]
           ,[Price]
           ,[Available]
           ,[IdCategory]
           ,[ProductCategory])

SELECT p.[Id] as IdProduct
      ,p.[Title] as Product
      ,[Description]
      ,[Price]
      ,[Available]
      ,[ProductCategoryId] as IdCategory
	  ,c.Title as ProductCategory
FROM [Expenses].[Catalog].[Product] p
left join [Expenses].[Catalog].[ProductCategory] c
	on p.[ProductCategoryId] = c.Id


-- Unknown member
INSERT INTO [dwh].[DimProduct]
           ([IdProduct]
           ,[Product]
           ,[Description]
           ,[Price]
           ,[Available]
           ,[IdCategory]
           ,[ProductCategory])
VALUES (-1, 'Unknown', 'Unknown', 0, 0, -1, 'Unknown')



-- [dwh].[DimCostCenter]
TRUNCATE TABLE [dwh].[DimCostCenter]

INSERT INTO [dwh].[DimCostCenter]
           ([IdCostCenter]
           ,[CostCenter]
           ,[Description])
SELECT [Id] as IdCostCenter
      ,[Code] as CostCenter
      ,[Description]
FROM [Expenses].[Expense].[CostCenter]

INSERT INTO [dwh].[DimCostCenter]
           ([IdCostCenter]
           ,[CostCenter]
           ,[Description])
VALUES (-1, 'Unknown', 'Unknown')


-- [dwh].[DimEmployee]
TRUNCATE TABLE [dwh].[DimEmployee]

INSERT INTO [dwh].[DimEmployee]
           ([IdEmployee]
           ,[FirstName]
           ,[LastName]
           ,[Email]
           ,[Identifier]
           ,[JobTitle]
           ,[IdTeam]
           ,[TeamName]
           ,[IsTeamManager])

SELECT e.[Id] as IdEmployee
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[Identifier]
      ,[JobTitle]
      ,[TeamId] as IdTeam
	  ,[TeamName]
      ,[IsTeamManager]
FROM [Expenses].[Expense].[Employee] e
LEFT JOIN [Expenses].[Expense].[Team] t
	on e.TeamId = t.Id

-- Unkown
INSERT INTO [dwh].[DimEmployee]
           ([IdEmployee]
           ,[FirstName]
           ,[LastName]
           ,[Email]
           ,[Identifier]
           ,[JobTitle]
           ,[IdTeam]
           ,[TeamName]
           ,[IsTeamManager])
VALUES
	(-1, 'Unknown',  'Unknown',  'Unknown',  'Unknown',  'Unknown', -1,  'Unknown', 0) 


-- [dwh].[DimExpenseCategory]
TRUNCATE TABLE [dwh].[DimExpenseCategory]

INSERT INTO [dwh].[DimExpenseCategory]
           ([IdExpenseCategory]
           ,[ExpenseCategory]
           ,[Description])
SELECT [Id] as IdExpenseCategory
      ,[Title] as ExpenseCategory
      ,[Description]
 FROM [Expenses].[Expense].[ExpenseCategory]

 -- Unknown
 INSERT INTO [dwh].[DimExpenseCategory]
           ([IdExpenseCategory]
           ,[ExpenseCategory]
           ,[Description])
VALUES 
	(-1, 'Unknown', 'Unknown')


-- [dwh].[DimCalendar]

TRUNCATE TABLE [dwh].[DimCalendar];

Declare @StartDate date
Set @StartDate = '20140101';

Declare @EndDate date
Set @EndDate = '20181231'; 

WITH CTE_Dates AS
(
SELECT @StartDate AS [Date]
UNION ALL
SELECT DATEADD(dd, 1, [Date]) FROM CTE_Dates WHERE DATEADD(dd, 1, [Date]) <= @EndDate
)

INSERT INTO [dwh].[DimCalendar]
		([IdCalendar]
		,[Date]
		,[MonthOfYear]
		,[MonthName]
		,[QuarterOfYear]
		,[QuarterName]
		,[Year]
		,[YearName]
		,[YearMonth]
		,[YearMonthName]
		,[YearQuarter]
		,[YearQuarterName])
 
SELECT CAST(CONVERT(VARCHAR(8), [Date], 112) AS INTEGER) as [IdCalendar]
	,[Date] as [Date]
	,MONTH([Date]) as [MonthOfYear]
	,DATENAME(MONTH, [Date]) as [MonthName]
	,DATEPART(QUARTER, [Date]) as [QuarterOfYear]
	,'Q' + Convert(varchar, DATEPART(QUARTER, [Date])) as [QuarterName]
	,YEAR([Date]) as [Year]
	,DATENAME(YEAR, [Date]) as [YearName]
	,YEAR([Date])*100 + MONTH([Date]) as [YearMonth]
	,DATENAME(YEAR, [Date]) + ' - ' + DATENAME(MONTH, [Date])  as [YearMonthName]
	,YEAR([Date])*10 + DATEPART(QUARTER, [Date]) as [YearQuarter]
	,DATENAME(YEAR, [Date]) + ' - ' + 'Q' + Convert(varchar, DATEPART(QUARTER, [Date]))  as [YearQuarterName]
FROM CTE_Dates

OPTION (MAXRECURSION 0);


-- Unknown member
Declare @Unknown date
Set @Unknown = '1900-01-01'

INSERT INTO [dwh].[DimCalendar]
			([IdCalendar]
			,[Date]
			,[MonthOfYear]
			,[MonthName]
			,[QuarterOfYear]
			,[QuarterName]
			,[Year]
			,[YearName]
			,[YearMonth]
			,[YearMonthName]
			,[YearQuarter]
			,[YearQuarterName])

	Select CAST(CONVERT(VARCHAR(8), @Unknown, 112) AS INTEGER) as [IdCalendar]
	,@Unknown as [Date] 
	,MONTH(@Unknown) as [MonthOfYear]
	,DATENAME(MONTH, @Unknown) as [MonthName]
	,DATEPART(QUARTER, @Unknown) as [QuarterOfYear]
	,'Q' + Convert(varchar, DATEPART(QUARTER, @Unknown)) as [QuarterName]
	,YEAR(@Unknown) as [Year]
	,DATENAME(YEAR, @Unknown) as [YearName]
	,YEAR(@Unknown)*100 + MONTH(@Unknown) as [YearMonth]
	,DATENAME(YEAR, @Unknown) + ' - ' + DATENAME(MONTH, @Unknown)  as [YearMonthName]
	,YEAR(@Unknown)*10 + DATEPART(QUARTER, @Unknown) as [YearQuarter]
	,DATENAME(YEAR, @Unknown) + ' - ' + 'Q' + Convert(varchar, DATEPART(QUARTER, @Unknown))  as [YearQuarterName]


	

/* FACT TABLES */

--  [dwh].[FactPurchase]
TRUNCATE TABLE [dwh].[FactPurchase]

INSERT INTO [dwh].[FactPurchase]
           ([IdPurchaseOrderItem]
           ,[IdPurchaseOrder]
           ,[IdProduct]
           ,[IdEmployee]
           ,[IdCalendar]
           ,[Price]
           ,[ItemsNumber]
           ,[LineAmount])

SELECT poi.[Id] as IdPurchaseOrderItem
      ,[PurchaseHistoryId] as IdPurchaseOrder
      ,IsNull(p.IdProduct, -1) as IdProduct
	  ,IsNull(e.IdEmployee, -1) as IdEmployee
	  ,IsNull(cal.IdCalendar, 19000101) as IdCalendar
      ,poi.[Price]
      ,[ItemsNumber]
	  ,poi.[Price] * [ItemsNumber] as LineAmount
FROM [Expenses].[Purchase].[PurchaseOrderItem] poi
inner join [Expenses].[Purchase].[PurchaseOrder] po
	on po.[Id] = poi.PurchaseHistoryId
left join [dwh].[DimProduct] p
	on poi.[ProductId] = p.IdProduct
left join [dwh].[DimEmployee] e
	on po.EmployeeId = e.IdEmployee
left join [dwh].[DimCalendar] cal
	on convert(int, convert(varchar(10), poi.[PurchaseDate], 112)) = cal.IdCalendar


--  [dwh].[FactExpense]

TRUNCATE TABLE [dwh].[FactExpense]

Declare @RowsToBeCreated int
Set @RowsToBeCreated = 2000000

WHILE (Select count(*) from [dwh].[FactExpense]) < @RowsToBeCreated
BEGIN

       INSERT INTO [dwh].[FactExpense]
           ([IdCalendar]
           ,[IdExpenseCategory]
           ,[IdCostCenter]
           ,[IdEmployee]
           ,[IdReport]
           ,[Amount])

       SELECT IsNull(cal.IdCalendar, 19000101) as IdCalendar
               ,1+floor(5 * RAND(convert(varbinary, newid()))) as IdExpenseCategory
               ,1+floor(2 * RAND(convert(varbinary, newid()))) as IdCostCenter
               ,1+floor(100 * RAND(convert(varbinary, newid()))) as IdEmployee
               ,[ExpenseReportId] as IdReport
               ,Case when [Amount]> 9999999 then 10 else [Amount] * floor(5 * RAND(convert(varbinary, newid()))) End as Amount
       FROM [Expenses].[Expense].[Expense] e
       left join [dwh].[DimCalendar] cal
             on convert(int, convert(varchar(10), e.[Date], 112)) = cal.IdCalendar


END
