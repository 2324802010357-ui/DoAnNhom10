using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnNhom10.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        public ActionResult Index()
        {
            if (Session["USER_ROLE"] == null || Session["USER_ROLE"].ToString() != "Admin")
            {
                return RedirectToAction("Login", "Account");
            }
            return View();
        }
    }
}