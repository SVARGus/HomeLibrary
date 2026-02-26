using System;
using System.Configuration;
using System.Web.UI;
using HomeLibrary.Common.Dal;
using HomeLibrary.Common.Models;

namespace HomeLibrary.WebForms
{
    public partial class BookEdit : Page
    {
        private int? EditId
        {
            get
            {
                if (int.TryParse(Request.QueryString["id"], out int id))
                    return id;
                return null;
            }
        }

        private bool IsEditMode => EditId.HasValue;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LitPageTitle.Text = IsEditMode ? "Изменить книгу" : "Добавить книгу";
                BtnSave.CssClass = IsEditMode ? "btn btn-warning" : "btn btn-primary";

                if (IsEditMode)
                {
                    LoadBook();
                }
            }
        }

        private void LoadBook()
        {
            var repository = CreateRepository();
            var book = repository.GetById(EditId.Value);

            if (book == null)
            {
                Response.Redirect("~/Books");
                return;
            }

            TxtTitle.Text = book.Title;
            TxtAuthor.Text = book.Author;
            TxtPublishYear.Text = book.PublishYear?.ToString();
            TxtISBN.Text = book.ISBN;
            TxtGenre.Text = book.Genre;
            TxtPublisher.Text = book.Publisher;
            TxtPageCount.Text = book.PageCount?.ToString();
            TxtDescription.Text = book.Description;
            HidTableOfContents.Value = book.TableOfContents;
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            var book = new Book
            {
                Title = TxtTitle.Text.Trim(),
                Author = TxtAuthor.Text.Trim(),
                PublishYear = string.IsNullOrEmpty(TxtPublishYear.Text) ? (int?)null : int.Parse(TxtPublishYear.Text),
                ISBN = string.IsNullOrEmpty(TxtISBN.Text) ? null : TxtISBN.Text.Trim(),
                Genre = string.IsNullOrEmpty(TxtGenre.Text) ? null : TxtGenre.Text.Trim(),
                Publisher = string.IsNullOrEmpty(TxtPublisher.Text) ? null : TxtPublisher.Text.Trim(),
                PageCount = string.IsNullOrEmpty(TxtPageCount.Text) ? (int?)null : int.Parse(TxtPageCount.Text),
                Description = string.IsNullOrEmpty(TxtDescription.Text) ? null : TxtDescription.Text.Trim(),
                TableOfContents = string.IsNullOrEmpty(HidTableOfContents.Value) ? null : HidTableOfContents.Value
            };

            var repository = CreateRepository();

            if (IsEditMode)
            {
                book.Id = EditId.Value;
                repository.Update(book);
            }
            else
            {
                repository.Insert(book);
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
