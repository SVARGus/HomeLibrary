<%@ Page Title="Редактирование книги" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookEdit.aspx.cs" Inherits="HomeLibrary.WebForms.BookEdit" ValidateRequest="false" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1><asp:Literal ID="LitPageTitle" runat="server" /></h1>

    <div class="row">
        <div class="col-md-8">
            <div class="mb-3">
                <label class="form-label">Название *</label>
                <asp:TextBox ID="TxtTitle" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="RfvTitle" runat="server" ControlToValidate="TxtTitle"
                    ErrorMessage="Введите название" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Автор *</label>
                <asp:TextBox ID="TxtAuthor" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="RfvAuthor" runat="server" ControlToValidate="TxtAuthor"
                    ErrorMessage="Введите автора" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label class="form-label">Год издания</label>
                        <asp:TextBox ID="TxtPublishYear" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label class="form-label">ISBN</label>
                        <asp:TextBox ID="TxtISBN" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label class="form-label">Кол-во страниц</label>
                        <asp:TextBox ID="TxtPageCount" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Жанр</label>
                        <asp:TextBox ID="TxtGenre" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Издательство</label>
                        <asp:TextBox ID="TxtPublisher" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Описание</label>
                <asp:TextBox ID="TxtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>

            <div class="mb-3">
                <label class="form-label">Оглавление</label>
                <asp:HiddenField ID="HidTableOfContents" runat="server" />

                <div id="toc-chapters"></div>

                <button type="button" id="btn-add-chapter" class="btn btn-sm btn-outline-primary mt-2">
                    + Добавить главу
                </button>
            </div>

            <div class="mt-3">
                <asp:Button ID="BtnSave" runat="server" Text="Сохранить" CssClass="btn btn-primary" OnClick="BtnSave_Click" OnClientClick="return tocBeforeSubmit();" />
                <a href="Books" class="btn btn-secondary">Отмена</a>
            </div>
        </div>
    </div>

    <script type="text/javascript">
    (function () {
        var hidden = document.getElementById('<%= HidTableOfContents.ClientID %>');
        var container = document.getElementById('toc-chapters');

        if (hidden.value) parseXml(hidden.value);

        document.getElementById('btn-add-chapter').addEventListener('click', function () {
            addChapter('', '');
        });

        container.addEventListener('click', function (e) {
            if (e.target.closest('.btn-remove-chapter')) {
                e.target.closest('.toc-chapter').remove();
            } else if (e.target.closest('.btn-add-section')) {
                var sections = e.target.closest('.toc-chapter').querySelector('.toc-sections');
                addSection(sections, '', '', '');
            } else if (e.target.closest('.btn-remove-section')) {
                e.target.closest('.toc-section').remove();
            }
        });

        window.tocBeforeSubmit = function () {
            hidden.value = buildXml();
            return true;
        };

        function parseXml(str) {
            try {
                var doc = new DOMParser().parseFromString(str, 'text/xml');
                if (doc.querySelector('parsererror')) return;
                var root = doc.documentElement;
                if (root.tagName !== 'TableOfContents') return;
                root.querySelectorAll(':scope > Chapter').forEach(function (ch) {
                    var chEl = addChapter(
                        ch.getAttribute('Number') || '',
                        ch.getAttribute('Title') || ''
                    );
                    var secContainer = chEl.querySelector('.toc-sections');
                    ch.querySelectorAll(':scope > Section').forEach(function (sec) {
                        addSection(secContainer,
                            sec.getAttribute('Number') || '',
                            sec.getAttribute('Title') || '',
                            sec.getAttribute('Page') || ''
                        );
                    });
                });
            } catch (e) { }
        }

        function addChapter(number, title) {
            var div = document.createElement('div');
            div.className = 'card mb-2 toc-chapter';
            div.innerHTML =
                '<div class="card-body p-2">' +
                '  <div class="d-flex gap-2 mb-2">' +
                '    <input type="text" class="form-control form-control-sm ch-number" placeholder="№" value="' + esc(number) + '" style="width:70px" />' +
                '    <input type="text" class="form-control form-control-sm ch-title" placeholder="Название главы" value="' + esc(title) + '" />' +
                '    <button type="button" class="btn btn-sm btn-outline-danger btn-remove-chapter" title="Удалить главу">&times;</button>' +
                '  </div>' +
                '  <div class="toc-sections ms-4"></div>' +
                '  <button type="button" class="btn btn-sm btn-outline-secondary btn-add-section ms-4 mt-1">+ Раздел</button>' +
                '</div>';
            container.appendChild(div);
            return div;
        }

        function addSection(secContainer, number, title, page) {
            var div = document.createElement('div');
            div.className = 'd-flex gap-2 mb-1 toc-section';
            div.innerHTML =
                '<input type="text" class="form-control form-control-sm sec-number" placeholder="№" value="' + esc(number) + '" style="width:70px" />' +
                '<input type="text" class="form-control form-control-sm sec-title" placeholder="Название раздела" value="' + esc(title) + '" />' +
                '<input type="text" class="form-control form-control-sm sec-page" placeholder="Стр." value="' + esc(page) + '" style="width:80px" />' +
                '<button type="button" class="btn btn-sm btn-outline-danger btn-remove-section" title="Удалить">&times;</button>';
            secContainer.appendChild(div);
        }

        function buildXml() {
            var chapters = container.querySelectorAll('.toc-chapter');
            if (chapters.length === 0) return '';
            var xml = '<TableOfContents>\n';
            chapters.forEach(function (ch) {
                var num = xmlAttr(ch.querySelector('.ch-number').value);
                var title = xmlAttr(ch.querySelector('.ch-title').value);
                var sections = ch.querySelectorAll('.toc-section');
                if (sections.length === 0) {
                    xml += '  <Chapter Number="' + num + '" Title="' + title + '" />\n';
                } else {
                    xml += '  <Chapter Number="' + num + '" Title="' + title + '">\n';
                    sections.forEach(function (sec) {
                        var sn = xmlAttr(sec.querySelector('.sec-number').value);
                        var st = xmlAttr(sec.querySelector('.sec-title').value);
                        var sp = xmlAttr(sec.querySelector('.sec-page').value);
                        var attrs = 'Number="' + sn + '" Title="' + st + '"';
                        if (sp) attrs += ' Page="' + sp + '"';
                        xml += '    <Section ' + attrs + ' />\n';
                    });
                    xml += '  </Chapter>\n';
                }
            });
            xml += '</TableOfContents>';
            return xml;
        }

        function xmlAttr(s) {
            return (s || '').trim().replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }

        function esc(s) {
            return (s || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }
    })();
    </script>
</asp:Content>
