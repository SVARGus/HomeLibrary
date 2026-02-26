using System;
using System.Configuration;
using System.Web.UI;
using HomeLibrary.Common.Dal;

namespace HomeLibrary.WebForms
{
    public partial class Books : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindBooks();
            }
        }

        private void BindBooks()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["HomeLibrary"].ConnectionString;
            var repository = new BookRepository(connectionString);
            BooksRepeater.DataSource = repository.GetAll(pageNumber: 1, pageSize: 100);
            BooksRepeater.DataBind();
        }
    }
}
