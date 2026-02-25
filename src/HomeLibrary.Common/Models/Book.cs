using System;

namespace HomeLibrary.Common.Models
{
    public class Book
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Author { get; set; }

        public int? PublishYear { get; set; }

        public string ISBN { get; set; }

        public string Genre { get; set; }

        public string Publisher { get; set; }

        public int? PageCount { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// Оглавление книги в формате XML.
        /// </summary>
        public string TableOfContents { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime? ModifiedDate { get; set; }
    }
}
