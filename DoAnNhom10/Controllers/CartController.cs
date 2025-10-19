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
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

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
        public ActionResult AddToCart(int id, string returnUrl)
        {
            var product = db.Products.Find(id);
            if (product != null)
            {
                List<CartItem> cart = Session["CART"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                }

                var existingItem = cart.FirstOrDefault(x => x.ProductID == id);
                if (existingItem != null)
                {
                    existingItem.Quantity++;
                }
                else
                {
                    // ✅ Lấy ảnh mặc định
                    var image = db.ProductImages.FirstOrDefault(i => i.ProductID == product.ProductID && i.IsDefault == true);

                    cart.Add(new CartItem
                    {
                        ProductID = product.ProductID,
                        ProductName = product.Name,
                        Price = (decimal)product.BasePrice,
                        ImageUrl = image != null ? image.Url : "/Images/no-image.png",
                        Quantity = 1
                    });
                }

                Session["CART"] = cart;
            }

            // ✅ Không chuyển qua giỏ hàng — ở lại trang hiện tại
            if (!string.IsNullOrEmpty(returnUrl))
                return Redirect(returnUrl);

            return RedirectToAction("Index", "Products");
        }


        public ActionResult ClearAfterPayment()
        {
            // Xóa giỏ hàng
            Session["CART"] = null;

            // Hiển thị thông báo thành công ở trang chủ
            TempData["SuccessMessage"] = "Thanh toán thành công! Cảm ơn bạn đã mua sắm tại Fashion Store 💜";

            return RedirectToAction("Index", "Home");
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
