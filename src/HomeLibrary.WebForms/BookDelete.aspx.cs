using System;
using System.Configuration;
using System.Web.UI;
using HomeLibrary.Common.Dal;

namespace HomeLibrary.WebForms
{
    public partial class BookDelete : Page
    {
        private int BookId;

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
            var repository = CreateRepository();
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
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["id"], out int id))
            {
                var repository = CreateRepository();
                repository.Delete(id);
            }

            Response.Redirect("~/Books");
        }

        private BookRepository CreateRepository()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["HomeLibrary"].ConnectionString;
            return new BookRepository(connectionString);
        }
    }
}
