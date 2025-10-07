using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnNhom10.Models;

namespace DoAnNhom10.Controllers
{
    public class AccountController : Controller
    {
        private ShopQuanAoNhom10Entities db = new ShopQuanAoNhom10Entities();

        // GET: Account/Register
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(User user)
        {
            if (ModelState.IsValid)
            {
                db.Users.Add(user);
                db.SaveChanges();
                return RedirectToAction("Login");
            }
            return View(user);
        }

        // GET: Account/Login
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(string email, string password)
        {
            var user = db.Users.FirstOrDefault(u => u.Email == email && u.PasswordHash == password);
            if (user != null)
            {
                Session["USER"] = user;
                return RedirectToAction("Index", "Home");
            }
            ViewBag.Error = "Sai email hoặc mật khẩu!";
            return View();
        }

        public ActionResult Logout()
        {
            Session["USER"] = null;
            return RedirectToAction("Index", "Home");
        }
    }
}