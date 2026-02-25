-- ============================================
-- Тестовые данные для таблицы Books
-- Версия: 1.0
-- ============================================

USE [HomeLibrary]
GO

SET QUOTED_IDENTIFIER ON
GO

-- Очистка таблицы перед вставкой тестовых данных
-- (раскомментировать при необходимости)
-- DELETE FROM [dbo].[Books];

DECLARE @NewId INT;

-- Книга 1: с полным XML-оглавлением
EXEC [dbo].[usp_Book_Insert]
    @Title           = N'Чистый код',
    @Author          = N'Роберт Мартин',
    @PublishYear     = 2008,
    @ISBN            = N'978-5-4461-0960-9',
    @Genre           = N'Программирование',
    @Publisher       = N'Питер',
    @PageCount       = 464,
    @Description     = N'Книга о принципах написания чистого, читаемого и поддерживаемого кода.',
    @TableOfContents = N'<TableOfContents>
  <Chapter Number="1" Title="Чистый код">
    <Section Number="1.1" Title="Да будет код" Page="3" />
    <Section Number="1.2" Title="Плохой код" Page="5" />
    <Section Number="1.3" Title="Цена хаоса" Page="8" />
  </Chapter>
  <Chapter Number="2" Title="Содержательные имена">
    <Section Number="2.1" Title="Используйте осмысленные имена" Page="22" />
    <Section Number="2.2" Title="Избегайте дезинформации" Page="25" />
  </Chapter>
  <Chapter Number="3" Title="Функции">
    <Section Number="3.1" Title="Компактность" Page="40" />
    <Section Number="3.2" Title="Правило одной операции" Page="42" />
  </Chapter>
</TableOfContents>',
    @NewId = @NewId OUTPUT;

PRINT N'Добавлена книга "Чистый код", Id = ' + CAST(@NewId AS NVARCHAR(10));

-- Книга 2: с кратким оглавлением
EXEC [dbo].[usp_Book_Insert]
    @Title           = N'Война и мир',
    @Author          = N'Лев Толстой',
    @PublishYear     = 1869,
    @ISBN            = N'978-5-17-084879-5',
    @Genre           = N'Роман',
    @Publisher       = N'АСТ',
    @PageCount       = 1408,
    @Description     = N'Роман-эпопея, описывающий русское общество в эпоху войн против Наполеона.',
    @TableOfContents = N'<TableOfContents>
  <Chapter Number="1" Title="Том первый">
    <Section Number="1.1" Title="Часть первая" Page="7" />
    <Section Number="1.2" Title="Часть вторая" Page="120" />
    <Section Number="1.3" Title="Часть третья" Page="230" />
  </Chapter>
  <Chapter Number="2" Title="Том второй">
    <Section Number="2.1" Title="Часть первая" Page="350" />
    <Section Number="2.2" Title="Часть вторая" Page="470" />
  </Chapter>
</TableOfContents>',
    @NewId = @NewId OUTPUT;

PRINT N'Добавлена книга "Война и мир", Id = ' + CAST(@NewId AS NVARCHAR(10));

-- Книга 3: без оглавления (проверка NULL в XML поле)
EXEC [dbo].[usp_Book_Insert]
    @Title           = N'Мастер и Маргарита',
    @Author          = N'Михаил Булгаков',
    @PublishYear     = 1967,
    @ISBN            = N'978-5-389-04926-6',
    @Genre           = N'Роман',
    @Publisher       = N'Азбука',
    @PageCount       = 480,
    @Description     = N'Один из самых известных романов русской литературы XX века.',
    @TableOfContents = NULL,
    @NewId = @NewId OUTPUT;

PRINT N'Добавлена книга "Мастер и Маргарита", Id = ' + CAST(@NewId AS NVARCHAR(10));

-- Книга 4: минимальные данные (только обязательные поля)
EXEC [dbo].[usp_Book_Insert]
    @Title  = N'Паттерны проектирования',
    @Author = N'Банда четырёх',
    @NewId  = @NewId OUTPUT;

PRINT N'Добавлена книга "Паттерны проектирования", Id = ' + CAST(@NewId AS NVARCHAR(10));

-- Проверка: вывод всех книг
EXEC [dbo].[usp_Book_GetAll];

-- Проверка: выборка из XML для первой книги
EXEC [dbo].[usp_Book_SelectFromXml] @Id = 1;
GO
