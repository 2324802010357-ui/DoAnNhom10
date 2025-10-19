using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoAnNhom10.Models
{
    public class SoldProductViewModel
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int TotalSold { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}