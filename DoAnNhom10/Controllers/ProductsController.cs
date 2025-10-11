using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class ProductsController : Controller
    {
        private ShopQuanAoNhom10Entities db = new ShopQuanAoNhom10Entities();

        // GET: Products
        public ActionResult Index(string search, string category, string sort)
        {
            try
            {
                // Start with all products and include related data
                var query = db.Products
                    .Include(p => p.Brand)
                    .Include(p => p.Category)
                    .Include(p => p.ProductImages)
                    .AsQueryable();

                // Apply search filter
                if (!string.IsNullOrEmpty(search))
                {
                    query = query.Where(p => p.Name.Contains(search) || 
                                           p.Description.Contains(search));
                }

                // Apply category filter
                if (!string.IsNullOrEmpty(category) && category != "all")
                {
                    query = query.Where(p => p.Category.Name.ToLower().Contains(category.ToLower()));
                }

                // Apply sorting
                switch (sort)
                {
                    case "name":
                        query = query.OrderBy(p => p.Name);
                        break;
                    case "price-asc":
                        query = query.OrderBy(p => p.BasePrice);
                        break;
                    case "price-desc":
                        query = query.OrderByDescending(p => p.BasePrice);
                        break;
                    case "newest":
                        query = query.OrderByDescending(p => p.ProductID);
                        break;
                    default:
                        query = query.OrderBy(p => p.Name);
                        break;
                }

                var products = query.ToList();
                
                // Pass filter parameters to view
                ViewBag.CurrentSearch = search;
                ViewBag.CurrentCategory = category;
                ViewBag.CurrentSort = sort;
                
                return View(products);
            }
            catch (Exception ex)
            {
                // If database is not available, return empty list
                ViewBag.ErrorMessage = "Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.";
                return View(new List<Product>());
            }
        }

        // GET: Products/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            try
            {
                Product product = db.Products
                    .Include(p => p.Brand)
                    .Include(p => p.Category)
                    .Include(p => p.ProductImages)
                    .FirstOrDefault(p => p.ProductID == id);

                if (product == null)
                {
                    return HttpNotFound();
                }

                return View(product);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = "Không thể tải thông tin sản phẩm.";
                return View();
            }
        }

        // GET: Products/Create
        public ActionResult Create()
        {
            try
            {
                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name");
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name");
                return View();
            }
            catch
            {
                ViewBag.ErrorMessage = "Không thể tải form tạo sản phẩm.";
                return View();
            }
        }

        // POST: Products/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ProductID,Name,Description,BasePrice,CategoryID,BrandID")] Product product)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.Products.Add(product);
                    db.SaveChanges();
                    TempData["SuccessMessage"] = "Tạo sản phẩm thành công!";
                    return RedirectToAction("Index");
                }

                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product.BrandID);
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product.CategoryID);
                return View(product);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = "Có lỗi xảy ra khi tạo sản phẩm.";
                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product?.BrandID);
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product?.CategoryID);
                return View(product);
            }
        }

        // GET: Products/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            try
            {
                Product product = db.Products.Find(id);
                if (product == null)
                {
                    return HttpNotFound();
                }

                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product.BrandID);
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product.CategoryID);
                return View(product);
            }
            catch
            {
                ViewBag.ErrorMessage = "Không thể tải thông tin sản phẩm để chỉnh sửa.";
                return View();
            }
        }

        // POST: Products/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ProductID,Name,Description,BasePrice,CategoryID,BrandID")] Product product)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.Entry(product).State = EntityState.Modified;
                    db.SaveChanges();
                    TempData["SuccessMessage"] = "Cập nhật sản phẩm thành công!";
                    return RedirectToAction("Index");
                }

                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product.BrandID);
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product.CategoryID);
                return View(product);
            }
            catch
            {
                ViewBag.ErrorMessage = "Có lỗi xảy ra khi cập nhật sản phẩm.";
                ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product?.BrandID);
                ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product?.CategoryID);
                return View(product);
            }
        }

        // GET: Products/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            try
            {
                Product product = db.Products.Find(id);
                if (product == null)
                {
                    return HttpNotFound();
                }
                return View(product);
            }
            catch
            {
                ViewBag.ErrorMessage = "Không thể tải thông tin sản phẩm để xóa.";
                return View();
            }
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                Product product = db.Products.Find(id);
                if (product != null)
                {
                    db.Products.Remove(product);
                    db.SaveChanges();
                    TempData["SuccessMessage"] = "Xóa sản phẩm thành công!";
                }
                return RedirectToAction("Index");
            }
            catch
            {
                TempData["ErrorMessage"] = "Có lỗi xảy ra khi xóa sản phẩm.";
                return RedirectToAction("Index");
            }
        }

        // AJAX: Get products for search
        [HttpGet]
        public JsonResult SearchProducts(string term)
        {
            try
            {
                var products = db.Products
                    .Where(p => p.Name.Contains(term))
                    .Select(p => new { 
                        id = p.ProductID, 
                        name = p.Name, 
                        price = p.BasePrice 
                    })
                    .Take(10)
                    .ToList();

                return Json(products, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                return Json(new List<object>(), JsonRequestBehavior.AllowGet);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}