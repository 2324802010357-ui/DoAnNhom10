using System.Linq;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class AdminProductsController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        // Danh sách sản phẩm
        public ActionResult Index()
        {
            if (Session["USER_ROLE"]?.ToString() != "Admin")
                return RedirectToAction("Login", "Account");

            var products = db.Products.OrderByDescending(p => p.ProductID).ToList();
            return View(products);
        }

        // Thêm sản phẩm
        public ActionResult Create()
        {
            ViewBag.Categories = new SelectList(db.Categories, "CategoryID", "Name");
            ViewBag.Brands = new SelectList(db.Brands, "BrandID", "Name");
            return View();
        }

        [HttpPost]
        public ActionResult Create(Product product)
        {
            if (ModelState.IsValid)
            {
                db.Products.Add(product);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // Sửa sản phẩm
        public ActionResult Edit(int id)
        {
            var product = db.Products.Find(id);
            if (product == null) return HttpNotFound();

            ViewBag.Categories = new SelectList(db.Categories, "CategoryID", "Name", product.CategoryID);
            ViewBag.Brands = new SelectList(db.Brands, "BrandID", "Name", product.BrandID);
            return View(product);
        }

        [HttpPost]
        public ActionResult Edit(Product product)
        {
            if (ModelState.IsValid)
            {
                db.Entry(product).State = System.Data.Entity.EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // Xóa sản phẩm
        public ActionResult Delete(int id)
        {
            var product = db.Products.Find(id);
            if (product != null)
            {
                db.Products.Remove(product);
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
