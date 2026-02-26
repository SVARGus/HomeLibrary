using System;
using System.Configuration;
using System.Web.UI;
using HomeLibrary.Common.Dal;
using HomeLibrary.Common.Helpers;

namespace HomeLibrary.WebForms
{
    public partial class BookDetails : Page
    {
        protected int BookId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out BookId))
            {
                Response.Redirect("~/Books");
                return;
            }

            if (!IsPostBack)
            {
                LoadBook();
            }
        }

        private void LoadBook()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["HomeLibrary"].ConnectionString;
            var repository = new BookRepository(connectionString);
            var book = repository.GetById(BookId);

            if (book == null)
            {
                Response.Redirect("~/Books");
                return;
            }

            LitTitle.Text = Server.HtmlEncode(book.Title);
            LitAuthor.Text = Server.HtmlEncode(book.Author);
            LitPublishYear.Text = book.PublishYear?.ToString();
            LitISBN.Text = Server.HtmlEncode(book.ISBN);
            LitGenre.Text = Server.HtmlEncode(book.Genre);
            LitPublisher.Text = Server.HtmlEncode(book.Publisher);
            LitPageCount.Text = book.PageCount?.ToString();
            LitDescription.Text = Server.HtmlEncode(book.Description);
            LitCreatedDate.Text = book.CreatedDate.ToString("dd.MM.yyyy HH:mm");

            if (book.ModifiedDate.HasValue)
            {
                PhModifiedDate.Visible = true;
                LitModifiedDate.Text = book.ModifiedDate.Value.ToString("dd.MM.yyyy HH:mm");
            }

            if (!string.IsNullOrEmpty(book.TableOfContents))
            {
                PhTableOfContents.Visible = true;
                LitTableOfContents.Text = TableOfContentsHelper.ToHtml(book.TableOfContents);
            }
        }
    }
}
