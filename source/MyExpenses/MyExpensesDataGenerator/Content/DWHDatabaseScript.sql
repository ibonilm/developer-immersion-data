USE [master]
GO
/****** Object:  Database [ExpensesDWH]    Script Date: 27/09/2016 13:44:38 ******/
CREATE DATABASE [ExpensesDWH]
GO
ALTER DATABASE [ExpensesDWH] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ExpensesDWH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ExpensesDWH] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ExpensesDWH] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ExpensesDWH] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ExpensesDWH] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ExpensesDWH] SET ARITHABORT OFF 
GO
ALTER DATABASE [ExpensesDWH] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ExpensesDWH] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ExpensesDWH] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ExpensesDWH] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ExpensesDWH] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ExpensesDWH] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ExpensesDWH] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ExpensesDWH] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ExpensesDWH] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ExpensesDWH] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ExpensesDWH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ExpensesDWH] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ExpensesDWH] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ExpensesDWH] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ExpensesDWH] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ExpensesDWH] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ExpensesDWH] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ExpensesDWH] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ExpensesDWH] SET  MULTI_USER 
GO
ALTER DATABASE [ExpensesDWH] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ExpensesDWH] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ExpensesDWH] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ExpensesDWH] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ExpensesDWH] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ExpensesDWH', N'ON'
GO
ALTER DATABASE [ExpensesDWH] SET QUERY_STORE = OFF
GO
USE [ExpensesDWH]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [ExpensesDWH]
GO
/****** Object:  Schema [config]    Script Date: 27/09/2016 13:44:39 ******/
CREATE SCHEMA [config]
GO
/****** Object:  Schema [dwh]    Script Date: 27/09/2016 13:44:39 ******/
CREATE SCHEMA [dwh]
GO
/****** Object:  Table [dwh].[DimCalendar]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[DimCalendar](
	[IdCalendar] [int] NOT NULL,
	[Date] [date] NULL,
	[MonthOfYear] [smallint] NULL,
	[MonthName] [varchar](20) NULL,
	[QuarterOfYear] [smallint] NULL,
	[QuarterName] [varchar](20) NULL,
	[Year] [smallint] NULL,
	[YearName] [varchar](10) NULL,
	[YearMonth] [int] NULL,
	[YearMonthName] [varchar](30) NULL,
	[YearQuarter] [int] NULL,
	[YearQuarterName] [varchar](30) NULL,
 CONSTRAINT [PK_DimCalendar] PRIMARY KEY CLUSTERED 
(
	[IdCalendar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[DimCostCenter]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[DimCostCenter](
	[IdCostCenter] [smallint] NOT NULL,
	[CostCenter] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[DimEmployee]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[DimEmployee](
	[IdEmployee] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](60) NOT NULL,
	[Identifier] [nvarchar](50) NOT NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[IdTeam] [int] NOT NULL,
	[TeamName] [nvarchar](100) NULL,
	[IsTeamManager] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[DimExpenseCategory]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[DimExpenseCategory](
	[IdExpenseCategory] [smallint] NOT NULL,
	[ExpenseCategory] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[DimProduct]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[DimProduct](
	[IdProduct] [int] NOT NULL,
	[Product] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[Price] [float] NOT NULL,
	[Available] [bit] NOT NULL,
	[IdCategory] [smallint] NOT NULL,
	[ProductCategory] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[FactExpense]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[FactExpense](
	[IdExpense] [int] IDENTITY(1,1) NOT NULL,
	[IdCalendar] [int] NOT NULL,
	[IdExpenseCategory] [smallint] NOT NULL,
	[IdCostCenter] [smallint] NOT NULL,
	[IdEmployee] [int] NOT NULL,
	[IdReport] [int] NOT NULL,
	[Amount] DECIMAL(10, 2) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dwh].[FactPurchase]    Script Date: 27/09/2016 13:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dwh].[FactPurchase](
	[IdPurchaseOrderItem] [int] NOT NULL,
	[IdPurchaseOrder] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
	[IdEmployee] [int] NOT NULL,
	[IdCalendar] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[ItemsNumber] [int] NOT NULL,
	[LineAmount] [float] NOT NULL
) ON [PRIMARY]

GO

USE [master]
GO
ALTER DATABASE [ExpensesDWH] SET  READ_WRITE 
GO
