-- ============================================
-- Скрипт создания базы данных HomeLibrary
-- Версия: 1.0
-- ============================================

USE [master]
GO

-- Создание базы данных, если она ещё не существует
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'HomeLibrary')
BEGIN
    CREATE DATABASE [HomeLibrary]
    COLLATE Cyrillic_General_CI_AS;
    PRINT N'База данных HomeLibrary успешно создана.';
END
ELSE
BEGIN
    PRINT N'База данных HomeLibrary уже существует.';
END
GO

USE [HomeLibrary]
GO
