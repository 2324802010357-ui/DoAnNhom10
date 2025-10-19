using DoAnNhom10.Models;
using System;
using System.Linq;
using System.Web.Mvc;

namespace DoAnNhom10.Controllers
{
    public class HomeController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        // ==========================
        // Trang chủ
        // ==========================
        public ActionResult Index()
        {
            // 4 sản phẩm nổi bật (Featured)
            var featuredProducts = db.Products
                .Where(p => p.Featured == true)
                .OrderByDescending(p => p.BasePrice)
                .Take(4)
                .ToList();

            // 4 sản phẩm bán chạy (BestSeller)
            var bestSellers = db.Products
                .Where(p => p.BestSeller == true)
                .OrderByDescending(p => p.ProductID)
                .Take(4)
                .ToList();

            ViewBag.FeaturedProducts = featuredProducts;
            ViewBag.BestSellers = bestSellers;

            return View();
        }

        // ==========================
        // Danh mục từ trang chủ
        // ==========================

        // Thời trang nam
        public ActionResult Nam()
        {
            return RedirectToAction("Index", "Products", new { category = "nam" });
        }

        // Thời trang nữ
        public ActionResult Nu()
        {
            return RedirectToAction("Index", "Products", new { category = "nu" });
        }

        // Giày nam
        public ActionResult GiayNam()
        {
            return RedirectToAction("Index", "Products", new { category = "giaynam" });
        }

        // Giày nữ
        public ActionResult GiayNu()
        {
            return RedirectToAction("Index", "Products", new { category = "giaynu" });
        }

        // ==========================
        // Trang About & Contact
        // ==========================
        public ActionResult About()
        {
            ViewBag.Message = "Giới thiệu về cửa hàng thời trang Shop Fashion 2025.";
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Liên hệ với Shop Fashion 2025 để được hỗ trợ.";
            return View();
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
