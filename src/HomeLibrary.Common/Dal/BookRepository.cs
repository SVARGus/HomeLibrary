using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using HomeLibrary.Common.Models;

namespace HomeLibrary.Common.Dal
{
    public class BookRepository
    {
        private readonly string _connectionString;

        public BookRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public List<Book> GetAll(int pageNumber = 1, int pageSize = 10)
        {
            var books = new List<Book>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("usp_Book_GetAll", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@PageNumber", pageNumber);
                command.Parameters.AddWithValue("@PageSize", pageSize);

                connection.Open();
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        books.Add(MapBook(reader));
                    }
                }
            }

            return books;
        }

        public Book GetById(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("usp_Book_GetById", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapBook(reader);
                    }
                }
            }

            return null;
        }

        public int Insert(Book book)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("usp_Book_Insert", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                AddBookParameters(command, book);

                var newIdParam = new SqlParameter("@NewId", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                command.Parameters.Add(newIdParam);

                connection.Open();
                command.ExecuteNonQuery();

                return (int)newIdParam.Value;
            }
        }

        public void Update(Book book)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("usp_Book_Update", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", book.Id);
                AddBookParameters(command, book);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        public void Delete(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("usp_Book_Delete", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        private static void AddBookParameters(SqlCommand command, Book book)
        {
            command.Parameters.AddWithValue("@Title", book.Title);
            command.Parameters.AddWithValue("@Author", book.Author);
            command.Parameters.AddWithValue("@PublishYear", (object)book.PublishYear ?? DBNull.Value);
            command.Parameters.AddWithValue("@ISBN", (object)book.ISBN ?? DBNull.Value);
            command.Parameters.AddWithValue("@Genre", (object)book.Genre ?? DBNull.Value);
            command.Parameters.AddWithValue("@Publisher", (object)book.Publisher ?? DBNull.Value);
            command.Parameters.AddWithValue("@PageCount", (object)book.PageCount ?? DBNull.Value);
            command.Parameters.AddWithValue("@Description", (object)book.Description ?? DBNull.Value);

            var xmlParam = new SqlParameter("@TableOfContents", SqlDbType.Xml)
            {
                Value = (object)book.TableOfContents ?? DBNull.Value
            };
            command.Parameters.Add(xmlParam);
        }

        private static Book MapBook(SqlDataReader reader)
        {
            return new Book
            {
                Id = reader.GetInt32(reader.GetOrdinal("Id")),
                Title = reader.GetString(reader.GetOrdinal("Title")),
                Author = reader.GetString(reader.GetOrdinal("Author")),
                PublishYear = reader.IsDBNull(reader.GetOrdinal("PublishYear"))
                    ? (int?)null
                    : reader.GetInt32(reader.GetOrdinal("PublishYear")),
                ISBN = reader.IsDBNull(reader.GetOrdinal("ISBN"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("ISBN")),
                Genre = reader.IsDBNull(reader.GetOrdinal("Genre"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("Genre")),
                Publisher = reader.IsDBNull(reader.GetOrdinal("Publisher"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("Publisher")),
                PageCount = reader.IsDBNull(reader.GetOrdinal("PageCount"))
                    ? (int?)null
                    : reader.GetInt32(reader.GetOrdinal("PageCount")),
                Description = reader.IsDBNull(reader.GetOrdinal("Description"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("Description")),
                TableOfContents = reader.IsDBNull(reader.GetOrdinal("TableOfContents"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("TableOfContents")),
                CreatedDate = reader.GetDateTime(reader.GetOrdinal("CreatedDate")),
                ModifiedDate = reader.IsDBNull(reader.GetOrdinal("ModifiedDate"))
                    ? (DateTime?)null
                    : reader.GetDateTime(reader.GetOrdinal("ModifiedDate"))
            };
        }
    }
}
