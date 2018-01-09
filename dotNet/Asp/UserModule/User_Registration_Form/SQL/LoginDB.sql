USE [master]
GO

CREATE DATABASE [LoginDB]

GO

USE [LoginDB]
GO

/****** Object:  Table [dbo].[Users]    Script Date: 01/03/2014 16:36:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](20) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](30) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [LoginDB]
GO

/****** Object:  StoredProcedure [dbo].[Insert_User]    Script Date: 01/03/2014 16:36:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Insert_User 'Mudassar2', '12345', 'mudassar@aspsnippets.com'
CREATE PROCEDURE [dbo].[Insert_User]
	@Username NVARCHAR(20),
	@Password NVARCHAR(20),
	@Email NVARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS(SELECT UserId FROM Users WHERE Username = @Username)
	BEGIN
		SELECT -1 -- Username exists.
	END
	ELSE IF EXISTS(SELECT UserId FROM Users WHERE Email = @Email)
	BEGIN
		SELECT -2 -- Email exists.
	END
	ELSE
	BEGIN
		INSERT INTO [Users]
			   ([Username]
			   ,[Password]
			   ,[Email]
			   ,[CreatedDate])
		VALUES
			   (@Username
			   ,@Password
			   ,@Email
			   ,GETDATE())
		
		SELECT SCOPE_IDENTITY() -- UserId			   
     END
END

GO


