-- ============================================
-- Скрипт создания таблиц базы данных HomeLibrary
-- Версия: 1.0
-- ============================================

USE [HomeLibrary]
GO

SET QUOTED_IDENTIFIER ON
GO

-- Таблица книг домашней библиотеки
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Books]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Books]
    (
        [Id]              INT            IDENTITY(1,1) NOT NULL,
        [Title]           NVARCHAR(500)  NOT NULL,
        [Author]          NVARCHAR(300)  NOT NULL,
        [PublishYear]     INT            NULL,
        [ISBN]            NVARCHAR(20)   NULL,
        [Genre]           NVARCHAR(100)  NULL,
        [Publisher]       NVARCHAR(200)  NULL,
        [PageCount]       INT            NULL,
        [Description]     NVARCHAR(MAX)  NULL,
        [TableOfContents] XML            NULL,
        [CreatedDate]     DATETIME2(7)   NOT NULL CONSTRAINT [DF_Books_CreatedDate] DEFAULT (GETDATE()),
        [ModifiedDate]    DATETIME2(7)   NULL,

        CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [CK_Books_PublishYear] CHECK ([PublishYear] IS NULL OR [PublishYear] > 0),
        CONSTRAINT [CK_Books_PageCount] CHECK ([PageCount] IS NULL OR [PageCount] > 0)
    );

    PRINT N'Таблица Books успешно создана.';
END
ELSE
BEGIN
    PRINT N'Таблица Books уже существует.';
END
GO

-- Уникальный filtered-индекс по ISBN (допускает несколько NULL, но не дубли)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'UQ_Books_ISBN' AND object_id = OBJECT_ID(N'[dbo].[Books]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UQ_Books_ISBN]
        ON [dbo].[Books] ([ISBN] ASC)
        WHERE [ISBN] IS NOT NULL;

    PRINT N'Индекс UQ_Books_ISBN создан.';
END
GO

-- Индекс для поиска по автору
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_Books_Author' AND object_id = OBJECT_ID(N'[dbo].[Books]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Books_Author]
        ON [dbo].[Books] ([Author] ASC);

    PRINT N'Индекс IX_Books_Author создан.';
END
GO

-- Индекс для поиска по названию
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_Books_Title' AND object_id = OBJECT_ID(N'[dbo].[Books]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Books_Title]
        ON [dbo].[Books] ([Title] ASC);

    PRINT N'Индекс IX_Books_Title создан.';
END
GO
