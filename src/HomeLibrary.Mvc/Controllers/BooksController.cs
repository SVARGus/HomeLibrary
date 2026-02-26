using Microsoft.AspNetCore.Mvc;
using HomeLibrary.Common.Dal;
using HomeLibrary.Common.Models;

namespace HomeLibrary.Mvc.Controllers
{
    public class BooksController : Controller
    {
        private readonly BookRepository _repository;

        public BooksController(BookRepository repository)
        {
            _repository = repository;
        }

        // GET: Books
        public IActionResult Index()
        {
            var books = _repository.GetAll(pageNumber: 1, pageSize: 100);
            return View(books);
        }

        // GET: Books/Details/5
        public IActionResult Details(int id)
        {
            var book = _repository.GetById(id);
            if (book == null)
                return NotFound();

            return View(book);
        }

        // GET: Books/Create
        public IActionResult Create()
        {
            return View(new Book());
        }

        // POST: Books/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Book book)
        {
            if (!ModelState.IsValid)
                return View(book);

            _repository.Insert(book);
            return RedirectToAction(nameof(Index));
        }

        // GET: Books/Edit/5
        public IActionResult Edit(int id)
        {
            var book = _repository.GetById(id);
            if (book == null)
                return NotFound();

            return View(book);
        }

        // POST: Books/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(Book book)
        {
            if (!ModelState.IsValid)
                return View(book);

            _repository.Update(book);
            return RedirectToAction(nameof(Index));
        }

        // GET: Books/Delete/5
        public IActionResult Delete(int id)
        {
            var book = _repository.GetById(id);
            if (book == null)
                return NotFound();

            return View(book);
        }

        // POST: Books/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            _repository.Delete(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
