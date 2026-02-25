-- ============================================
-- Хранимые процедуры для таблицы Books
-- Версия: 1.0
-- ============================================

USE [HomeLibrary]
GO

SET QUOTED_IDENTIFIER ON
GO

-- ============================================
-- Получение списка книг с пагинацией
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_GetAll]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_GetAll];
GO

CREATE PROCEDURE [dbo].[usp_Book_GetAll]
    @PageNumber INT = 1,
    @PageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Title],
        [Author],
        [PublishYear],
        [ISBN],
        [Genre],
        [Publisher],
        [PageCount],
        [Description],
        [TableOfContents],
        [CreatedDate],
        [ModifiedDate]
    FROM [dbo].[Books]
    ORDER BY [Title] ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- ============================================
-- Получение книги по Id
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_GetById]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_GetById];
GO

CREATE PROCEDURE [dbo].[usp_Book_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Title],
        [Author],
        [PublishYear],
        [ISBN],
        [Genre],
        [Publisher],
        [PageCount],
        [Description],
        [TableOfContents],
        [CreatedDate],
        [ModifiedDate]
    FROM [dbo].[Books]
    WHERE [Id] = @Id;
END
GO

-- ============================================
-- Вставка новой книги
-- Возвращает Id созданной записи
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_Insert]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_Insert];
GO

CREATE PROCEDURE [dbo].[usp_Book_Insert]
    @Title           NVARCHAR(500),
    @Author          NVARCHAR(300),
    @PublishYear     INT            = NULL,
    @ISBN            NVARCHAR(20)   = NULL,
    @Genre           NVARCHAR(100)  = NULL,
    @Publisher       NVARCHAR(200)  = NULL,
    @PageCount       INT            = NULL,
    @Description     NVARCHAR(MAX)  = NULL,
    @TableOfContents XML            = NULL,
    @NewId           INT            = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [dbo].[Books]
        (
            [Title],
            [Author],
            [PublishYear],
            [ISBN],
            [Genre],
            [Publisher],
            [PageCount],
            [Description],
            [TableOfContents]
        )
        VALUES
        (
            @Title,
            @Author,
            @PublishYear,
            @ISBN,
            @Genre,
            @Publisher,
            @PageCount,
            @Description,
            @TableOfContents
        );

        SET @NewId = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ============================================
-- Обновление книги
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_Update]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_Update];
GO

CREATE PROCEDURE [dbo].[usp_Book_Update]
    @Id              INT,
    @Title           NVARCHAR(500),
    @Author          NVARCHAR(300),
    @PublishYear     INT            = NULL,
    @ISBN            NVARCHAR(20)   = NULL,
    @Genre           NVARCHAR(100)  = NULL,
    @Publisher       NVARCHAR(200)  = NULL,
    @PageCount       INT            = NULL,
    @Description     NVARCHAR(MAX)  = NULL,
    @TableOfContents XML            = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [dbo].[Books]
        SET
            [Title]           = @Title,
            [Author]          = @Author,
            [PublishYear]     = @PublishYear,
            [ISBN]            = @ISBN,
            [Genre]           = @Genre,
            [Publisher]       = @Publisher,
            [PageCount]       = @PageCount,
            [Description]     = @Description,
            [TableOfContents] = @TableOfContents,
            [ModifiedDate]    = GETDATE()
        WHERE [Id] = @Id;

        IF @@ROWCOUNT = 0
            THROW 50001, N'Книга с указанным Id не найдена.', 1;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ============================================
-- Удаление книги по Id
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_Delete]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_Delete];
GO

CREATE PROCEDURE [dbo].[usp_Book_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM [dbo].[Books]
        WHERE [Id] = @Id;

        IF @@ROWCOUNT = 0
            THROW 50001, N'Книга с указанным Id не найдена.', 1;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ============================================
-- Примеры выборки данных из XML поля
-- Демонстрация XQuery: .value(), .query(), .nodes()
-- ============================================
IF OBJECT_ID(N'[dbo].[usp_Book_SelectFromXml]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Book_SelectFromXml];
GO

CREATE PROCEDURE [dbo].[usp_Book_SelectFromXml]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Получение всего XML оглавления
    SELECT
        [Id],
        [Title],
        [TableOfContents].query('/TableOfContents') AS [FullContents]
    FROM [dbo].[Books]
    WHERE [Id] = @Id;

    -- 2. Извлечение названий глав через .nodes() и .value()
    SELECT
        b.[Id],
        b.[Title],
        ch.value('@Number', 'NVARCHAR(10)')  AS [ChapterNumber],
        ch.value('@Title',  'NVARCHAR(200)') AS [ChapterTitle]
    FROM [dbo].[Books] b
    CROSS APPLY b.[TableOfContents].nodes('/TableOfContents/Chapter') AS T(ch)
    WHERE b.[Id] = @Id;

    -- 3. Извлечение разделов внутри глав (вложенный .nodes())
    SELECT
        b.[Id],
        ch.value('@Number', 'NVARCHAR(10)')  AS [ChapterNumber],
        ch.value('@Title',  'NVARCHAR(200)') AS [ChapterTitle],
        sec.value('@Number', 'NVARCHAR(10)') AS [SectionNumber],
        sec.value('@Title',  'NVARCHAR(200)') AS [SectionTitle],
        sec.value('@Page',   'INT')           AS [Page]
    FROM [dbo].[Books] b
    CROSS APPLY b.[TableOfContents].nodes('/TableOfContents/Chapter') AS T(ch)
    CROSS APPLY ch.nodes('Section') AS S(sec)
    WHERE b.[Id] = @Id;
END
GO
