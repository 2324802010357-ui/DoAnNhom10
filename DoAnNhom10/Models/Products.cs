using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoAnNhom10.Models
{

    public class Products
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(150)]
        public string Name { get; set; }

        [StringLength(1000)]
        public string Description { get; set; }

        [DataType(DataType.Currency)]
        public decimal Price { get; set; }
        public int BrandID { get; set; }
        public virtual Brand Brand { get; set; }

        public int CategoryID { get; set; }
        public virtual Category Category { get; set; }

        public string Image { get; set; }
    }
}