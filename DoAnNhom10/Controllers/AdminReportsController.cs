using System.Linq;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class AdminReportsController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        // Trang thống kê sản phẩm đã bán
        public ActionResult SoldProducts()
        {
            if (Session["USER_ROLE"]?.ToString() != "Admin")
                return RedirectToAction("Login", "Account");

            // Lấy dữ liệu từ OrderItems + Product
            var soldProducts = db.OrderItems
                .Where(o => o.Product != null)
                .GroupBy(o => new { ProductID = (int)o.ProductID, ProductName = o.Product.Name })
                .Select(g => new SoldProductViewModel
                {
                    ProductID = g.Key.ProductID,
                    ProductName = g.Key.ProductName,
                    TotalSold = g.Sum(x => (int)x.Quantity),
                    TotalRevenue = g.Sum(x => (decimal)(x.Quantity * x.UnitPrice))
                })
                .OrderByDescending(x => x.TotalRevenue)
                .ToList();

            ViewBag.TotalRevenue = soldProducts.Sum(x => x.TotalRevenue);
            return View(soldProducts);
        }
    }
}
