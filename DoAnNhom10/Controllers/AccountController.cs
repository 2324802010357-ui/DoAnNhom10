using System;
using System.Linq;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class AccountController : Controller
    {
        private ShopFashion2025Entities db = new ShopFashion2025Entities();

        // ---------------------------
        // ĐĂNG KÝ TÀI KHOẢN
        // ---------------------------
        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Register(User user)
        {
            if (ModelState.IsValid)
            {
                // Kiểm tra email đã tồn tại
                var existingUser = db.Users.FirstOrDefault(u => u.Email == user.Email);
                if (existingUser != null)
                {
                    ViewBag.Error = "Email này đã được đăng ký!";
                    return View(user);
                }

                // Gán vai trò mặc định
                user.Role = "Customer";
                user.CreatedAt = DateTime.Now;

                db.Users.Add(user);
                db.SaveChanges();

                TempData["SuccessMessage"] = "Đăng ký thành công! Vui lòng đăng nhập.";
                return RedirectToAction("Login");
            }
            return View(user);
        }

        // ---------------------------
        // ĐĂNG NHẬP
        // ---------------------------
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string email, string password)
        {
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ViewBag.Error = "Vui lòng nhập đầy đủ thông tin!";
                return View();
            }

            var user = db.Users.FirstOrDefault(u => u.Email == email && u.PasswordHash == password);
            if (user != null)
            {
                // Lưu thông tin đăng nhập vào Session
                Session["USER"] = user;
                Session["USER_NAME"] = user.FullName;
                Session["USER_ROLE"] = user.Role;

                // Chuyển hướng theo vai trò
                if (user.Role == "Admin")
                {
                    return RedirectToAction("Index", "Admin");
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }

            ViewBag.Error = "Sai email hoặc mật khẩu!";
            return View();
        }

        // ---------------------------
        // ĐĂNG XUẤT
        // ---------------------------
        public ActionResult Logout()
        {
            Session.Clear();
            return RedirectToAction("Index", "Home");
        }
    }
}
