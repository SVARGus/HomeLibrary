<%@ Page Title="Удалить книгу" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookDelete.aspx.cs" Inherits="HomeLibrary.WebForms.BookDelete" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Удалить книгу</h1>

    <div class="alert alert-danger">
        Вы уверены, что хотите удалить эту книгу?
    </div>

    <div class="card">
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">Название</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitTitle" runat="server" /></dd>

                <dt class="col-sm-3">Автор</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitAuthor" runat="server" /></dd>

                <dt class="col-sm-3">Год издания</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitPublishYear" runat="server" /></dd>

                <dt class="col-sm-3">ISBN</dt>
                <dd class="col-sm-9"><asp:Literal ID="LitISBN" runat="server" /></dd>
            </dl>
        </div>
    </div>

    <div class="mt-3">
        <asp:Button ID="BtnDelete" runat="server" Text="Удалить" CssClass="btn btn-danger" OnClick="BtnDelete_Click" />
        <a href="Books" class="btn btn-secondary">Отмена</a>
    </div>
</asp:Content>
