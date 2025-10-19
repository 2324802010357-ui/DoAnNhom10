using System.Linq;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class AdminCategoriesController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        public ActionResult Index()
        {
            if (Session["USER_ROLE"]?.ToString() != "Admin")
                return RedirectToAction("Login", "Account");

            return View(db.Categories.ToList());
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Category category)
        {
            if (ModelState.IsValid)
            {
                db.Categories.Add(category);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(category);
        }

        public ActionResult Edit(int id)
        {
            var c = db.Categories.Find(id);
            return View(c);
        }

        [HttpPost]
        public ActionResult Edit(Category category)
        {
            if (ModelState.IsValid)
            {
                db.Entry(category).State = System.Data.Entity.EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(category);
        }

        public ActionResult Delete(int id)
        {
            var c = db.Categories.Find(id);
            if (c != null)
            {
                db.Categories.Remove(c);
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
