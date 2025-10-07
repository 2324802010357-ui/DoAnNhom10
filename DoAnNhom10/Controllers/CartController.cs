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
                cart.Add(new CartItem
                {
                    ProductID = product.ProductID,
                    ProductName = product.Name,
                    Price = product.BasePrice,
                    Quantity = qty,
                    ImageUrl = "~/Content/images/placeholder.png"
                });
            }
            else
            {
                item.Quantity += qty;
            }
            Cart = cart;

            return RedirectToAction("Index"); // sau khi thêm → về giỏ hàng
        }


        // ✅ Cập nhật số lượng
        [HttpPost]
        public ActionResult Update(int id, int qty)
        {
            var cart = Cart;
            var item = cart.FirstOrDefault(x => x.ProductID == id);
            if (item != null) item.Quantity = qty;
            Cart = cart;
            return RedirectToAction("Index");
        }

        // ✅ Xóa sản phẩm khỏi giỏ
        [HttpPost]
        public ActionResult Remove(int id)
        {
            var cart = Cart;
            cart.RemoveAll(x => x.ProductID == id);
            Cart = cart;
            return RedirectToAction("Index");
        }
    }
}
