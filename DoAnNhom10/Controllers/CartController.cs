using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class CartController : Controller
    {
        private ShopQuanAoNhom10Entities db = new ShopQuanAoNhom10Entities();

        private List<CartItem> Cart
        {
            get
            {
                var cart = Session["CART"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                    Session["CART"] = cart;
                }
                return cart;
            }
            set { Session["CART"] = value; }
        }

        // Xem giỏ hàng
        public ActionResult Index()
        {
            return View(Cart);
        }

        // ✅ Thêm sản phẩm vào giỏ hàng (cho phép GET từ nút bấm)
        [HttpGet]
        public ActionResult AddToCart(int id, int qty = 1)
        {
            var product = db.Products.Find(id);
            if (product == null) return HttpNotFound();

            var cart = Cart;
            var item = cart.FirstOrDefault(x => x.ProductID == id);
            if (item == null)
            {
                // Tìm hình ảnh đầu tiên của sản phẩm
                var firstImage = product.ProductImages.FirstOrDefault();
                var imageUrl = firstImage != null ? firstImage.Url : "~/Content/images/placeholder.png";

                cart.Add(new CartItem
                {
                    ProductID = product.ProductID,
                    ProductName = product.Name,
                    Price = product.BasePrice,
                    Quantity = qty,
                    ImageUrl = imageUrl
                });
            }
            else
            {
                item.Quantity += qty;
            }
            Cart = cart;

            TempData["SuccessMessage"] = $"Đã thêm {product.Name} vào giỏ hàng!";
            return RedirectToAction("Index");
        }

        // ✅ Cập nhật số lượng (Traditional POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Update(int id, int qty)
        {
            var cart = Cart;
            var item = cart.FirstOrDefault(x => x.ProductID == id);
            if (item != null) 
            {
                if (qty > 0)
                {
                    item.Quantity = qty;
                    TempData["SuccessMessage"] = $"Đã cập nhật số lượng {item.ProductName}!";
                }
                else
                {
                    cart.Remove(item);
                    TempData["SuccessMessage"] = $"Đã xóa {item.ProductName} khỏi giỏ hàng!";
                }
            }
            Cart = cart;
            return RedirectToAction("Index");
        }

        // ✅ NEW: Cập nhật số lượng qua AJAX
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult UpdateQuantityAjax(int id, int qty)
        {
            try
            {
                var cart = Cart;
                var item = cart.FirstOrDefault(x => x.ProductID == id);
                
                if (item != null && qty > 0 && qty <= 99)
                {
                    item.Quantity = qty;
                    Cart = cart;
                    
                    // Calculate new totals
                    var totalQuantity = cart.Sum(x => x.Quantity);
                    var subtotal = cart.Sum(x => x.Total);
                    var shippingFee = subtotal >= 500000 ? 0 : 30000;
                    var finalTotal = subtotal + shippingFee;
                    
                    return Json(new
                    {
                        success = true,
                        message = "Cập nhật thành công",
                        data = new
                        {
                            itemTotal = item.Total,
                            totalQuantity = totalQuantity,
                            subtotal = subtotal,
                            shippingFee = shippingFee,
                            finalTotal = finalTotal,
                            freeShippingRemaining = subtotal < 500000 ? 500000 - subtotal : 0
                        }
                    });
                }
                else
                {
                    return Json(new
                    {
                        success = false,
                        message = "Số lượng không hợp lệ"
                    });
                }
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = "Có lỗi xảy ra: " + ex.Message
                });
            }
        }

        // ✅ Xóa sản phẩm khỏi giỏ
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Remove(int id)
        {
            var cart = Cart;
            var item = cart.FirstOrDefault(x => x.ProductID == id);
            if (item != null)
            {
                cart.Remove(item);
                TempData["SuccessMessage"] = $"Đã xóa {item.ProductName} khỏi giỏ hàng!";
            }
            Cart = cart;
            return RedirectToAction("Index");
        }

        // ✅ Xóa tất cả sản phẩm khỏi giỏ hàng
        public ActionResult Clear()
        {
            Session["CART"] = null;
            TempData["SuccessMessage"] = "Đã xóa tất cả sản phẩm khỏi giỏ hàng!";
            return RedirectToAction("Index");
        }

        // ✅ NEW: Lấy thông tin giỏ hàng qua AJAX
        [HttpGet]
        public JsonResult GetCartInfo()
        {
            var cart = Cart;
            var totalQuantity = cart.Sum(x => x.Quantity);
            var subtotal = cart.Sum(x => x.Total);
            var shippingFee = subtotal >= 500000 ? 0 : 30000;
            var finalTotal = subtotal + shippingFee;
            
            return Json(new
            {
                success = true,
                data = new
                {
                    totalQuantity = totalQuantity,
                    subtotal = subtotal,
                    shippingFee = shippingFee,
                    finalTotal = finalTotal,
                    items = cart.Select(x => new
                    {
                        productId = x.ProductID,
                        productName = x.ProductName,
                        price = x.Price,
                        quantity = x.Quantity,
                        total = x.Total,
                        imageUrl = x.ImageUrl
                    }).ToList()
                }
            }, JsonRequestBehavior.AllowGet);
        }

        // ✅ Trang thanh toán (placeholder)
        public ActionResult Checkout()
        {
            if (Session["USER"] == null)
            {
                TempData["ErrorMessage"] = "Bạn cần đăng nhập để thanh toán!";
                return RedirectToAction("Login", "Account");
            }

            var cart = Cart;
            if (cart == null || !cart.Any())
            {
                TempData["ErrorMessage"] = "Giỏ hàng của bạn đang trống!";
                return RedirectToAction("Index");
            }

            // TODO: Implement checkout logic
            ViewBag.Total = cart.Sum(x => x.Total);
            return View(cart);
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
