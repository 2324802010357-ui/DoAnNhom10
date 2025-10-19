using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class ProductsController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        // =============================
        // GET: Products (Danh sách sản phẩm)
        // =============================
        public ActionResult Index(string search, string category, string sort)
        {
            var query = db.Products
                .Include(p => p.Brand)
                .Include(p => p.Category)
                .Include(p => p.ProductImages)
                .AsQueryable();

            // --- Lọc theo danh mục ---
            if (!string.IsNullOrEmpty(category))
            {
                category = category.ToLower();

                switch (category)
                {
                    case "ao":
                        query = query.Where(p =>
                            (p.CategoryID == 1 || p.CategoryID == 2) &&
                            p.Name.Contains("Áo"));
                        break;

                    case "quan":
                        query = query.Where(p =>
                            (p.CategoryID == 1 || p.CategoryID == 2) &&
                            p.Name.Contains("Quần"));
                        break;

                    case "giay":
                        query = query.Where(p => p.CategoryID == 3 || p.CategoryID == 4);
                        break;

                    // Danh mục mở rộng cho trang chủ
                    case "nam":
                        query = query.Where(p => p.Gender == "Nam");
                        break;

                    case "nu":
                        query = query.Where(p => p.Gender == "Nữ");
                        break;

                    case "giaynam":
                        query = query.Where(p => p.Category.Name.Contains("Giày") && p.Gender == "Nam");
                        break;

                    case "giaynu":
                        query = query.Where(p => p.Category.Name.Contains("Giày") && p.Gender == "Nữ");
                        break;
                }
            }

            // --- Tìm kiếm ---
            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(p => p.Name.Contains(search));
            }

            // --- Sắp xếp ---
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

            // Giữ giá trị tìm kiếm, sắp xếp, danh mục hiện tại
            ViewBag.CurrentSearch = search;
            ViewBag.CurrentCategory = category;
            ViewBag.CurrentSort = sort;

            return View(query.ToList());
        }

        // =============================
        // GET: Products/Details/5
        // =============================
        public ActionResult Details(int? id)
        {
            if (id == null)
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            var product = db.Products
                .Include(p => p.Brand)
                .Include(p => p.Category)
                .Include(p => p.ProductImages)
                .FirstOrDefault(p => p.ProductID == id);

            if (product == null)
                return HttpNotFound();

            return View(product);
        }

        // =============================
        // Tạo mới sản phẩm
        // =============================
        public ActionResult Create()
        {
            ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name");
            ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ProductID,Name,Description,BasePrice,CategoryID,BrandID,Gender")] Product product)
        {
            if (ModelState.IsValid)
            {
                db.Products.Add(product);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.BrandID = new SelectList(db.Brands, "BrandID", "Name", product.BrandID);
            ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "Name", product.CategoryID);
            return View(product);
        }

        // =============================
        // API Gợi ý tìm kiếm (Autocomplete)
        // =============================
        [HttpGet]
        public JsonResult SearchSuggestions(string term, string category)
        {
            if (string.IsNullOrWhiteSpace(term))
                return Json(new List<string>(), JsonRequestBehavior.AllowGet);

            var query = db.Products.AsQueryable();

            // Lọc theo danh mục (khớp với Index)
            if (!string.IsNullOrEmpty(category))
            {
                category = category.ToLower();

                switch (category)
                {
                    case "ao":
                        query = query.Where(p =>
                            (p.CategoryID == 1 || p.CategoryID == 2) &&
                            p.Name.Contains("Áo"));
                        break;

                    case "quan":
                        query = query.Where(p =>
                            (p.CategoryID == 1 || p.CategoryID == 2) &&
                            p.Name.Contains("Quần"));
                        break;

                    case "giay":
                        query = query.Where(p => p.CategoryID == 3 || p.CategoryID == 4);
                        break;

                    case "nam":
                        query = query.Where(p => p.Gender == "Nam");
                        break;

                    case "nu":
                        query = query.Where(p => p.Gender == "Nữ");
                        break;

                    case "giaynam":
                        query = query.Where(p => p.Category.Name.Contains("Giày") && p.Gender == "Nam");
                        break;

                    case "giaynu":
                        query = query.Where(p => p.Category.Name.Contains("Giày") && p.Gender == "Nữ");
                        break;
                }
            }

            // Lọc theo từ khóa
            var suggestions = query
                .Where(p => p.Name.Contains(term))
                .OrderBy(p => p.Name)
                .Select(p => p.Name)
                .Take(8)
                .ToList();

            return Json(suggestions, JsonRequestBehavior.AllowGet);
        }

        // =============================
        // Dispose
        // =============================
        protected override void Dispose(bool disposing)
        {
            if (disposing)
                db.Dispose();
            base.Dispose(disposing);
        }
    }
}
