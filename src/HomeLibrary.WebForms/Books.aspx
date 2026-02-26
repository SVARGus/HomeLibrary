<%@ Page Title="Книги" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="HomeLibrary.WebForms.Books" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Книги</h1>

    <p>
        <a href="BookEdit" class="btn btn-primary">Добавить книгу</a>
    </p>

    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Название</th>
                <th>Автор</th>
                <th>Год</th>
                <th>Жанр</th>
                <th>ISBN</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
            <asp:Repeater ID="BooksRepeater" runat="server">
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("Title") %></td>
                        <td><%# Eval("Author") %></td>
                        <td><%# Eval("PublishYear") %></td>
                        <td><%# Eval("Genre") %></td>
                        <td><%# Eval("ISBN") %></td>
                        <td>
                            <a href='BookDetails?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-info">Просмотр</a>
                            <a href='BookEdit?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-warning">Изменить</a>
                            <a href='BookDelete?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-danger">Удалить</a>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
</asp:Content>
