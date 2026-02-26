<%@ Page Title="Просмотр книги" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookDetails.aspx.cs" Inherits="HomeLibrary.WebForms.BookDetails" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1><asp:Literal ID="LitTitle" runat="server" /></h1>

    <div class="card">
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">Автор</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitAuthor" runat="server" /></dd>

                <dt class="col-sm-3">Год издания</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitPublishYear" runat="server" /></dd>

                <dt class="col-sm-3">ISBN</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitISBN" runat="server" /></dd>

                <dt class="col-sm-3">Жанр</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitGenre" runat="server" /></dd>

                <dt class="col-sm-3">Издательство</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitPublisher" runat="server" /></dd>

                <dt class="col-sm-3">Кол-во страниц</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitPageCount" runat="server" /></dd>

                <dt class="col-sm-3">Описание</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitDescription" runat="server" /></dd>

                <dt class="col-sm-3">Дата создания</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitCreatedDate" runat="server" /></dd>

                <asp:PlaceHolder ID="PhModifiedDate" runat="server" Visible="false">
                    <dt class="col-sm-3">Дата изменения</dt>
                    <dd class="col-sm-9"><asp:Literal ID="LitModifiedDate" runat="server" /></dd>
                </asp:PlaceHolder>
            </dl>

            <asp:PlaceHolder ID="PhTableOfContents" runat="server" Visible="false">
                <h5>Оглавление</h5>
                <div class="border rounded p-3 bg-light">
                    <asp:Literal ID="LitTableOfContents" runat="server" />
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

    <div class="mt-3">
        <a href='BookEdit?id=<%= BookId %>' class="btn btn-warning">Изменить</a>
        <a href="Books" class="btn btn-secondary">К списку</a>
    </div>
</asp:Content>
