CREATE DATABASE ShopFashion2025;
GO


CREATE TABLE Users (
    UserID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    PasswordHash NVARCHAR(255),
    Role NVARCHAR(20) DEFAULT 'Customer',
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(100) NOT NULL
);

CREATE TABLE Brands (
    BrandID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(150),
    Description NVARCHAR(1000),
    BasePrice DECIMAL(18,2),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    BrandID INT FOREIGN KEY REFERENCES Brands(BrandID),
    Featured BIT DEFAULT 0,
    BestSeller BIT DEFAULT 0
);
CREATE TABLE ProductVariants (
    VariantID INT IDENTITY PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Size NVARCHAR(20),
    Color NVARCHAR(50),
    Price DECIMAL(18,2) NOT NULL,
    Stock INT NOT NULL
);

CREATE TABLE ProductImages (
    ImageID INT IDENTITY PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Url NVARCHAR(255),
    IsDefault BIT DEFAULT 1
);
CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CustomerName NVARCHAR(150),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    ShippingAddress NVARCHAR(255),
    Status NVARCHAR(20) DEFAULT 'Pending',
    TotalAmount DECIMAL(18,2),
    OrderDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    VariantID INT FOREIGN KEY REFERENCES ProductVariants(VariantID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    LineTotal DECIMAL(18,2) NOT NULL
);
INSERT INTO Categories (Name, Slug) VALUES
(N'Thời trang nam', 'thoi-trang-nam'),
(N'Thời trang nữ', 'thoi-trang-nu'),
(N'Giày nam', 'giay-nam'),
(N'Giày nữ', 'giay-nu');
INSERT INTO Brands (Name) VALUES
(N'UrbanStyle'),
(N'StreetWear'),
(N'ClassicMan'),
(N'ElegantLady'),
(N'SportPro');
INSERT INTO Products (Name, Description, BasePrice, CategoryID, BrandID, Featured, BestSeller) VALUES
(N'Áo thun nam Basic', N'Áo thun cotton thoáng mát.', 250000, 1, 2, 1, 0),
(N'Áo sơ mi caro', N'Áo sơ mi caro trẻ trung.', 320000, 1, 1, 0, 1),
(N'Áo hoodie nam Street', N'Hoodie cá tính cho mùa đông.', 400000, 1, 2, 1, 1),
(N'Áo khoác jeans', N'Chất liệu denim năng động.', 550000, 1, 3, 1, 0),
(N'Quần tây công sở', N'Lịch lãm và sang trọng.', 450000, 1, 3, 0, 0),
(N'Áo bomber đen', N'Phong cách đường phố.', 480000, 1, 1, 0, 1),
(N'Áo polo nam trắng', N'Lịch sự, gọn gàng.', 350000, 1, 2, 1, 0),
(N'Áo len cổ tròn', N'Giữ ấm mà vẫn thời trang.', 380000, 1, 1, 0, 1),
(N'Áo khoác gió', N'Chống nước nhẹ, tiện dụng.', 420000, 1, 3, 0, 0),
(N'Quần short kaki', N'Mát mẻ cho mùa hè.', 280000, 1, 2, 0, 0),
(N'Áo vest nam', N'Dành cho các buổi sự kiện.', 850000, 1, 3, 1, 1),
(N'Áo tanktop thể thao', N'Thoáng khí khi vận động.', 200000, 1, 5, 0, 1),
(N'Áo khoác da nam', N'Cực ngầu và cá tính.', 950000, 1, 1, 1, 0),
(N'Áo thun oversize', N'Phong cách hiện đại.', 270000, 1, 2, 0, 1),
(N'Áo hoodie Basic', N'Form rộng unisex.', 350000, 1, 2, 0, 0),
(N'Áo len cổ lọ', N'Giữ ấm mùa đông.', 420000, 1, 3, 0, 0),
(N'Áo khoác dù', N'Phong cách Hàn Quốc.', 470000, 1, 3, 0, 1),
(N'Áo blazer xám', N'Trẻ trung, lịch lãm.', 680000, 1, 1, 1, 1),
(N'Áo sơ mi trắng trơn', N'Đơn giản, dễ phối.', 320000, 1, 1, 0, 0),
(N'Áo polo đen', N'Nam tính, mạnh mẽ.', 340000, 1, 3, 0, 1);

-- ===============================
-- ẢNH SẢN PHẨM THỜI TRANG NAM
-- ===============================
INSERT INTO ProductImages (ProductID, Url) VALUES
(1, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(2, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(3, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(4, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(5, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(6, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
(7, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),
(8, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(9, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),
(10, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(11, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(12, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(13, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(14, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(15, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(16, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(17, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(18, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(19, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
(20, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400');

-- ===============================
-- 20 SẢN PHẨM THỜI TRANG NỮ
-- ===============================
INSERT INTO Products (Name, Description, BasePrice, CategoryID, BrandID, Featured, BestSeller) VALUES
(N'Đầm hoa mùa hè', N'Váy hoa nhẹ nhàng, thích hợp cho dạo phố.', 420000, 2, 4, 1, 0),
(N'Áo sơ mi trắng nữ', N'Áo sơ mi trắng thanh lịch, phù hợp công sở.', 350000, 2, 4, 0, 1),
(N'Chân váy xếp ly', N'Chân váy dài xếp ly, tạo cảm giác dịu dàng nữ tính.', 380000, 2, 4, 1, 1),
(N'Áo croptop', N'Croptop trẻ trung, năng động, dễ phối đồ.', 280000, 2, 2, 1, 1),
(N'Áo len cổ lọ nữ', N'Giữ ấm tốt, tôn dáng và phong cách.', 400000, 2, 4, 0, 1),
(N'Áo khoác da nữ', N'Áo khoác da form ôm, cực kỳ thời trang.', 950000, 2, 1, 1, 0),
(N'Áo blazer nữ', N'Phong cách công sở hiện đại, lịch sự.', 650000, 2, 4, 0, 1),
(N'Váy body cổ vuông', N'Đầm body quyến rũ, thiết kế cổ vuông gợi cảm.', 580000, 2, 4, 1, 1),
(N'Áo thun nữ Basic', N'Áo thun trơn, vải cotton mềm mịn.', 250000, 2, 2, 1, 0),
(N'Quần jean nữ skinny', N'Quần jean ôm tôn dáng, năng động.', 400000, 2, 2, 0, 1),
(N'Áo sơ mi hoa', N'Họa tiết hoa nhí, chất liệu voan nhẹ.', 370000, 2, 4, 1, 0),
(N'Đầm maxi đi biển', N'Đầm dài bay bổng, phù hợp du lịch.', 450000, 2, 4, 0, 1),
(N'Áo khoác gió nữ', N'Nhẹ, chống nắng, dễ phối đồ.', 420000, 2, 3, 0, 0),
(N'Áo hoodie nữ pastel', N'Màu pastel dễ thương, vải nỉ dày dặn.', 390000, 2, 2, 1, 1),
(N'Váy công chúa', N'Đầm tulle bồng bềnh, phong cách tiểu thư.', 550000, 2, 4, 1, 0),
(N'Áo len cardigan', N'Áo cardigan mỏng nhẹ, phù hợp thu đông.', 370000, 2, 4, 0, 1),
(N'Áo khoác kaki nữ', N'Cá tính, dễ phối đồ.', 520000, 2, 3, 1, 1),
(N'Áo thun tay dài nữ', N'Thiết kế đơn giản, form ôm nhẹ.', 310000, 2, 2, 0, 0),
(N'Áo sơ mi cổ nơ', N'Thiết kế cổ nơ sang trọng.', 360000, 2, 4, 1, 1),
(N'Váy suông công sở', N'Đầm suông nhẹ nhàng, thanh lịch.', 480000, 2, 4, 0, 1);

-- ===============================
-- ẢNH SẢN PHẨM THỜI TRANG NỮ
-- ===============================
INSERT INTO ProductImages (ProductID, Url) VALUES
(21, 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400'),
(22, 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400'),
(23, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3b39?w=400'),
(24, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(25, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(26, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400'),
(27, 'https://images.unsplash.com/photo-1520975918319-27b052be8f2e?w=400'),
(28, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(29, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(30, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
(31, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(32, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(33, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),
(34, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(35, 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400'),
(36, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(37, 'https://images.unsplash.com/photo-1520975918319-27b052be8f2e?w=400'),
(38, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(39, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3b39?w=400'),
(40, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400');

-- ===============================
-- 20 SẢN PHẨM GIÀY NAM
-- ===============================
INSERT INTO Products (Name, Description, BasePrice, CategoryID, BrandID, Featured, BestSeller) VALUES
(N'Giày sneaker trắng', N'Giày sneaker nam trắng, dễ phối đồ, phong cách trẻ trung.', 650000, 3, 2, 1, 1),
(N'Giày da công sở', N'Giày tây da thật, bóng mịn, sang trọng.', 980000, 3, 3, 1, 0),
(N'Giày thể thao Runner', N'Giày thể thao đế mềm, hỗ trợ vận động tốt.', 720000, 3, 5, 1, 1),
(N'Giày slip-on đen', N'Giày lười tiện dụng, da mềm thoáng khí.', 550000, 3, 1, 0, 1),
(N'Giày sandal nam', N'Sandal đế cao su bền, phù hợp mùa hè.', 420000, 3, 5, 0, 0),
(N'Giày boot cổ cao', N'Phong cách mạnh mẽ, cá tính cho nam giới.', 890000, 3, 1, 1, 1),
(N'Giày lười nâu', N'Giày da bò mềm, màu nâu cổ điển.', 760000, 3, 3, 0, 0),
(N'Giày sneaker cổ thấp', N'Thiết kế tối giản, đế êm, năng động.', 670000, 3, 2, 1, 1),
(N'Giày da lộn', N'Giày chất liệu da lộn cao cấp, sang trọng.', 930000, 3, 3, 0, 0),
(N'Giày vải Classic', N'Giày vải cổ điển, thoáng mát, dễ mang.', 480000, 3, 2, 0, 1),
(N'Giày chạy bộ AirMax', N'Mẫu giày thể thao siêu nhẹ.', 780000, 3, 5, 1, 1),
(N'Giày thể thao đen', N'Phong cách năng động, phù hợp gym.', 690000, 3, 5, 0, 1),
(N'Giày lười da trơn', N'Thiết kế tinh tế, phù hợp đi làm.', 870000, 3, 3, 1, 0),
(N'Giày tây Oxford', N'Kiểu dáng cổ điển, sang trọng.', 990000, 3, 3, 1, 1),
(N'Giày sneaker canvas', N'Chất liệu vải canvas, bền và nhẹ.', 520000, 3, 2, 0, 0),
(N'Giày thể thao trắng', N'Màu trắng basic, phù hợp mọi outfit.', 650000, 3, 5, 1, 0),
(N'Giày boot da lộn', N'Boot cổ thấp, da lộn cao cấp, hợp thời trang.', 940000, 3, 3, 0, 1),
(N'Giày sneaker Retro', N'Giày retro cổ điển, phối màu độc đáo.', 720000, 3, 2, 1, 1),
(N'Giày sandal thể thao', N'Sandal quai dán, phong cách thể thao.', 400000, 3, 5, 0, 0),
(N'Giày da đen bóng', N'Sang trọng, phù hợp công sở và sự kiện.', 950000, 3, 3, 1, 1);

-- ===============================
-- ẢNH SẢN PHẨM GIÀY NAM
-- ===============================
INSERT INTO ProductImages (ProductID, Url) VALUES
(41, 'https://images.unsplash.com/photo-1528701800489-20be6c7a43c7?w=400'),
(42, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(43, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(44, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(45, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3b39?w=400'),
(46, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(47, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(48, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
(49, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(50, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(51, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(52, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(53, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),
(54, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(55, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(56, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(57, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(58, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(59, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(60, 'https://images.unsplash.com/photo-1528701800489-20be6c7a43c7?w=400');

-- ===============================
-- 20 SẢN PHẨM GIÀY NỮ
-- ===============================
INSERT INTO Products (Name, Description, BasePrice, CategoryID, BrandID, Featured, BestSeller) VALUES
(N'Giày cao gót đen', N'Giày cao gót cổ điển màu đen, tôn dáng và sang trọng.', 720000, 4, 4, 1, 1),
(N'Giày thể thao nữ trắng', N'Giày sneaker trắng nữ tính, dễ phối đồ.', 580000, 4, 2, 1, 0),
(N'Giày sandal quai mảnh', N'Sandal nữ quai mảnh tinh tế, phù hợp dự tiệc.', 450000, 4, 4, 1, 1),
(N'Giày búp bê da', N'Mềm mại, phù hợp đi làm hoặc đi chơi.', 380000, 4, 3, 0, 1),
(N'Giày thể thao pastel', N'Màu pastel trẻ trung, đế nhẹ êm ái.', 600000, 4, 2, 1, 0),
(N'Giày cao gót nude', N'Màu nude trang nhã, chiều cao 7cm.', 720000, 4, 4, 1, 1),
(N'Giày sneaker hồng', N'Màu hồng dễ thương, phong cách nữ tính.', 590000, 4, 2, 1, 0),
(N'Giày sandal đế bệt', N'Sandal nữ đế bệt thoải mái, dễ mang.', 390000, 4, 5, 0, 0),
(N'Giày thể thao Fashion', N'Thiết kế hiện đại, trẻ trung và năng động.', 630000, 4, 2, 1, 1),
(N'Giày cao gót đỏ', N'Tô điểm nổi bật cho trang phục dự tiệc.', 750000, 4, 4, 1, 0),
(N'Giày búp bê nơ', N'Búp bê mũi tròn, họa tiết nơ xinh xắn.', 400000, 4, 3, 0, 1),
(N'Giày sneaker đen', N'Phong cách thể thao cơ bản, dễ phối đồ.', 560000, 4, 2, 1, 1),
(N'Giày cao gót trong suốt', N'Kiểu dáng hiện đại, phù hợp tiệc tối.', 800000, 4, 4, 1, 0),
(N'Giày sandal dây chéo', N'Thiết kế dây chéo thời trang, tiện dụng.', 420000, 4, 5, 0, 1),
(N'Giày thể thao Retro nữ', N'Phong cách cổ điển phối màu đẹp.', 620000, 4, 2, 0, 1),
(N'Giày cao gót ánh kim', N'Tỏa sáng trong mọi buổi tiệc tối.', 880000, 4, 4, 1, 1),
(N'Giày thể thao chunky', N'Đế cao, cá tính, trendy.', 680000, 4, 2, 1, 1),
(N'Giày sandal đế cao', N'Tạo dáng cao và thon gọn đôi chân.', 570000, 4, 5, 1, 0),
(N'Giày búp bê cổ điển', N'Kiểu dáng cổ điển thanh lịch.', 420000, 4, 3, 0, 0),
(N'Giày sneaker nữ vải', N'Giày vải mềm, nhẹ và thoáng khí.', 490000, 4, 2, 0, 1);

-- ===============================
-- ẢNH SẢN PHẨM GIÀY NỮ
-- ===============================
INSERT INTO ProductImages (ProductID, Url) VALUES
(61, 'https://images.unsplash.com/photo-1528701800489-20be6c7a43c7?w=400'),
(62, 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400'),
(63, 'https://images.unsplash.com/photo-1520975918319-27b052be8f2e?w=400'),
(64, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(65, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400'),
(66, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(67, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(68, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(69, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(70, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400'),
(71, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),
(72, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400'),
(73, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),
(74, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400'),
(75, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(76, 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400'),
(77, 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=400'),
(78, 'https://images.unsplash.com/photo-1593032457864-47a9b6df41d1?w=400'),
(79, 'https://images.unsplash.com/photo-1521334884684-d80222895322?w=400'),
(80, 'https://images.unsplash.com/photo-1600180758890-6b94519a8baa?w=400');

UPDATE Products SET Featured = 1 WHERE ProductID IN (1,2,3,4,5,6,7,8);
UPDATE Products SET BestSeller = 1 WHERE ProductID IN (9,10,11,12,13,14,15,16);

ALTER TABLE Products ADD Gender NVARCHAR(10);


UPDATE Products SET Gender = N'Nam' WHERE CategoryID IN (1, 3, 5);
UPDATE Products SET Gender = N'Nữ' WHERE CategoryID IN (2, 4, 6);

UPDATE Products
SET Gender = N'Nam'
WHERE CategoryID IN (1, 3, 5) -- ID tương ứng áo/quần/phụ kiện nam
AND Name NOT LIKE N'%Giày%';

UPDATE Products
SET Gender = N'Nữ'
WHERE CategoryID IN (2, 4, 6)
AND Name NOT LIKE N'%Giày%';

UPDATE Products
SET Gender = N'Nam'
WHERE CategoryID IN (7) OR Name LIKE N'%Giày nam%';

UPDATE Products
SET Gender = N'Nữ'
WHERE CategoryID IN (8) OR Name LIKE N'%Giày nữ%';

-- 1️⃣ Cập nhật ảnh cho Áo thun nam Basic (ProductID = 1)
UPDATE ProductImages
SET Url = N'https://cf.shopee.vn/file/4aad732314ab8cd7d488528d5ac7be7b'
WHERE ProductID = 1;

-- 2️⃣ Cập nhật ảnh cho Áo sơ mi caro (ProductID = 2)
UPDATE ProductImages
SET Url = N'https://4men.com.vn/thumbs/2015/04/ao-so-mi-ca-ro-asm611-467-p.jpg'
WHERE ProductID = 2;

-- 3. Áo hoodie nam Street
UPDATE ProductImages SET Url = N'https://cf.shopee.vn/file/sg-11134201-22110-mj66guahhejvce' WHERE ProductID = 3;

-- 4. Áo khoác jeans
UPDATE ProductImages SET Url = N'https://product.hstatic.net/1000360022/product/z3907027303949_e9fb89295d4938b8c37bec9aecb06c46_c26702be229b4874a4b17bfc711825b9.jpg' WHERE ProductID = 4;

-- 5. Quần tây công sở
UPDATE ProductImages SET Url = N'https://dongphucphuocthinh.com/wp-content/uploads/2021/06/quan-tay-03.jpg' WHERE ProductID = 5;

-- 6. Áo bomber đen
UPDATE ProductImages SET Url = N'https://4men.com.vn/thumbs/2022/08/ao-khoac-regular-basic-bomber-ak037-mau-den-21423-p.JPG' WHERE ProductID = 6;

-- 7. Áo polo nam trắng
UPDATE ProductImages SET Url = N'https://pos.nvncdn.com/778773-105877/ps/20230529_5xEM0bU9mm.jpeg' WHERE ProductID = 7;

-- 8. Áo len cổ tròn
UPDATE ProductImages SET Url = N'https://pos.nvncdn.com/6ddefc-25341/ps/20231017_JVB6JiuB6T.jpeg' WHERE ProductID = 8;

-- 9. Áo khoác gió
UPDATE ProductImages SET Url = N'https://down-vn.img.susercontent.com/file/525617168365afcbdeafdac652e00910' WHERE ProductID = 9;

-- 10. Quần short kaki
UPDATE ProductImages SET Url = N'https://tse3.mm.bing.net/th/id/OIP.fy4ghlsCt6ML9LVCe6C4JQHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3' WHERE ProductID = 10;

-- 11. Áo vest nam
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.vPJBrlByD5azsOTqpl2BOAHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 11;

-- 12. Áo tanktop thể thao
UPDATE ProductImages SET Url = N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqopb7mxclrrab' WHERE ProductID = 12;

-- 13. Áo khoác da nam
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/R.b51d9cfe581ceccd4d61cd6cfb81a2a0?rik=QmPU4NombF73XA&pid=ImgRaw&r=0' WHERE ProductID = 13;

-- 14. Áo thun oversize
UPDATE ProductImages SET Url = N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lng50dm803ne1b' WHERE ProductID = 14;

-- 15. Áo hoodie Basic
UPDATE ProductImages SET Url = N'https://saigonsneaker.com/wp-content/uploads/2021/10/Ao-khoac-hoodie-flexible-toi-gian-xanh-reu-9.jpg' WHERE ProductID = 15;

-- 16. Áo len cổ lọ
UPDATE ProductImages SET Url = N'https://4men.com.vn/images/thumbs/2021/12/-16429-slide-products-61aae3d8a58ce.JPG' WHERE ProductID = 16;

-- 17. Áo khoác dù
UPDATE ProductImages SET Url = N'https://tse2.mm.bing.net/th/id/OIP.GmdGVamVEbG7fT5Bn5VtnAHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3' WHERE ProductID = 17;

-- 18. Áo blazer xám
UPDATE ProductImages SET Url = N'https://cdn0199.cdn4s.com/media/2500f7e7081fd3418a0e.jpg' WHERE ProductID = 18;

-- 19. Áo sơ mi trắng trơn
UPDATE ProductImages SET Url = N'https://tse3.mm.bing.net/th/id/OIP.6BiE-gP16gV5C8U3WDAkHwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3' WHERE ProductID = 19;

-- 20. Áo polo đen
UPDATE ProductImages SET Url = N'https://libertywings.vn/wp-content/uploads/2023/05/23S-PLN058-BL-XL-1-scaled.jpg' WHERE ProductID = 20;

-- 21. Đầm hoa mùa hè
UPDATE ProductImages SET Url = N'https://cdn.kkfashion.vn/21132-large_default/dam-hoa-nhi-dang-dai-duoi-ca-co-vien-beo-kk140-35.jpg' WHERE ProductID = 21;

-- 22. Áo sơ mi trắng nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.c3_eiGYdBO-ayYXHf4EsNAHaHa?w=178&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 22;

-- 23. Chân váy xếp ly
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.hCcXPOwX4uj2okat3catEQHaEo?w=301&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 23;

-- 24. Áo croptop
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.edTc2e-zMnaj4HqJgYS_EgHaHa?w=192&h=192&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 24;

-- 25. Áo len cổ lọ nữ
UPDATE ProductImages SET Url = N'https://dony.vn/wp-content/uploads/2022/01/ao-len-co-lo-nu-dep-2.jpg' WHERE ProductID = 25;

-- 26. Áo khoác da nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.JMIXxka1lWsM_DEoAmeieAHaHa?w=220&h=220&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 26;

-- 27. Áo blazer nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.0uX3OXwtDWPi4dA5_-YBtwHaHa?w=183&h=184&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 27;

-- 28. Váy body cổ vuông
UPDATE ProductImages SET Url = N'https://down-vn.img.susercontent.com/file/69bf200e3fe19cbc6fc441fae8d74731' WHERE ProductID = 28;

-- 29. Áo thun nữ Basic
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.Uj1OkVsAtfxea6qNLw-giwHaHa?w=216&h=216&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 29;

-- 30. Quần jean nữ skinny
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.ElPryTi8AWKxvUZcZHEsiQHaHa?w=209&h=209&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 30;

-- 31. Áo sơ mi hoa
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.qWgfPVASKeh5Rfuq5Ap-mwHaHa?w=201&h=200&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 31;

-- 32. Đầm maxi đi biển
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.FD7Nv0YoGjERUxnRI7QrSQHaJ4?w=186&h=248&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 32;

-- 33. Áo khoác gió nữ
UPDATE ProductImages SET Url = N'https://cf.shopee.vn/file/1af7e96bc9ce95e102846cbe9dfba7d1' WHERE ProductID = 33;

-- 34. Áo hoodie nữ pastel
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.MA6E3YYppJaXaS8Y16m5mwHaHa?w=218&h=218&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 34;

-- 35. Váy công chúa
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.-IKXsrJFMvnH4x80OwPnggHaHa?w=191&h=191&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 35;

-- 36. Áo len cardigan
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.Sadct3oCsTOcc5sZezi0TwHaHa?w=192&h=192&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 36;

-- 37. Áo khoác kaki nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.wX5CLjSRisSdW3iQf7PjkgHaHa?w=117&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 37;

-- 38. Áo thun tay dài nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.9YB6wERYDc9YLHeargdcAwHaF7?w=228&h=182&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 38;

-- 39. Áo sơ mi cổ nơ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.NY-P5tSes9abbtXZcysHdwHaGW?w=220&h=188&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 39;

-- 40. Váy suông công sở
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.IMrRNnQHrTxvoslv9nzutQHaLH?w=186&h=279&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 40;

-- 41. Giày sneaker trắng
UPDATE ProductImages SET Url = N'https://cf.shopee.vn/file/8d5cd186604fb93560c96eed5cce7231' WHERE ProductID = 41;

-- 42. Giày da công sở
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.clT5-QhpMCmw0a3YGDmaAgHaF4?w=240&h=190&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 42;

-- 43. Giày thể thao Runner
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.A75P8akCItKQ5xvcukmPigHaHa?w=193&h=193&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 43;

-- 44. Giày slip-on đen
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.jILZvvbpI6Ppc0ajNox7rgHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 44;

-- 45. Giày sandal nam
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.dEm8hs0G6INXjBFQyvzQIwHaHa?w=212&h=213&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 45;

-- 46. Giày boot cổ cao
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.lXNAcLIJXwg5TTGnO0LqdwHaHa?w=147&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 46;

-- 47. Giày lười nâu
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.hAFarJOV_YDUGUFJNdew1wHaHa?w=176&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 47;

-- 48. Giày sneaker cổ thấp
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.ujG0aXB8Lc8iwBv20ZhNnAHaHa?w=201&h=201&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 48;

-- 49. Giày da lộn
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.rCHTB3aBsJxACF0IKuzKbwHaHa?w=188&h=188&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 49;

-- 50. Giày vải Classic
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.o2rDvTNgav-UU7H8WOuU7wHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 50;

-- 51. Giày chạy bộ AirMax
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.KCwJmZeB77ywYJ8Mq3ALhQHaHa?w=225&h=220&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 51;

-- 52. Giày thể thao đen
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.Fj64labxplx5bBWFT9eWLgHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 52;

-- 53. Giày lười da trơn
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.BO493fiUGkgScp44TFmLmAHaHa?w=207&h=207&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 53;

-- 54. Giày tây Oxford
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.DEq7rhGu9z4plnVFLH_SxAHaHa?w=199&h=199&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 54;

-- 55. Giày sneaker canvas
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.Qwj7cNnhS_kCD4OjpVtOOwHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 55;

-- 56. Giày thể thao trắng
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.OIc7sGNSHE3AHnNFPUBMMwHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 56;

-- 57. Giày boot da lộn
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.7y9gQ-EZrfJfvldyHlzx1wHaHa?w=208&h=208&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 57;

-- 58. Giày sneaker Retro
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.fVe-hECXgV6PHxlOC7SpBgHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 58;

-- 59. Giày sandal thể thao
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.VeCk1nuUXJ-QNwT5rwZZ-AHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 59;

-- 60. Giày da đen bóng
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.GyaGGkW9zvu_8AOKPuDiagHaHa?w=194&h=194&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 60;

-- 61. Giày cao gót đen
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.GZ047YvqS5feg2TtiyegGgHaLJ?w=141&h=212&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 61;

-- 62. Giày thể thao nữ trắng
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.T-T1h6zZISREmhXU7u66VwHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 62;

-- 63. Giày sandal quai mảnh
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.mDiUh6M85tZ5ZbOqUuJfLQHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 63;

-- 64. Giày búp bê da
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.3gedxSXU9gRZrwY-0tCaLgHaHa?w=72&h=72&c=1&rs=1&qlt=70&r=0&o=7&cb=12&dpr=1.3&pid=InlineBlock&rm=3' WHERE ProductID = 64;

-- 65. Giày thể thao pastel
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.bv2qV_FIaroFu_hzirAEewHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 65;

-- 66. Giày cao gót nude
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.1-BA-v-t3YucbkcO_KmgOgHaJ4?w=186&h=248&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 66;

-- 67. Giày sneaker hồng
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.t844Kuv1SHoZH0hLHKUzsQD6D5?w=177&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 67;

-- 68. Giày sandal đế bệt
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.RG8bytKrWkexHkbihhfh2AHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 68;

-- 69. Giày thể thao Fashion
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.gzoOTfHrcxT70xLWPy8A5gAAAA?w=177&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 69;

-- 70. Giày cao gót đỏ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.bLRDWwxlasN0TA4_dlaS1AHaJH?w=163&h=201&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 70;

-- 71. Giày búp bê nơ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.2zi6X5INZimWJjqZJeHMgQHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 71;

-- 72. Giày sneaker đen
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.vajAYdIKBpdO6IlRZTQ0AAHaHZ?w=147&h=180&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 72;

-- 73. Giày cao gót trong suốt
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.G3ecK1yNLEN7ugwlRVHgAAHaHa?w=214&h=214&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 73;

-- 74. Giày sandal dây chéo
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.ms3UAgwJ2ckw0nZwn53kBAHaKX?w=139&h=195&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 74;

-- 75. Giày thể thao Retro nữ
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.XcR6Mb37pdRF3pSm8IcZiQHaHa?w=201&h=202&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 75;

-- 76. Giày cao gót ánh kim
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.EEtxdVDIrOsSTqWWbEzZFwHaHa?w=194&h=194&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 76;

-- 77. Giày thể thao chunky
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.w1o0gX3aGgM4Gibs1XYPwwHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 77;

-- 78. Giày sandal đế cao
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.2d61IgFIFnmVD0pLknuI3wHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 78;

-- 79. Giày búp bê cổ điển
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.F9HE2YH7JqDMh41Ls4XnOQHaHa?w=186&h=186&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 79;

-- 80. Giày sneaker nữ vải
UPDATE ProductImages SET Url = N'https://th.bing.com/th/id/OIP.kln0hnBmthWwRJrojD85cgHaHa?w=209&h=209&c=7&r=0&o=7&cb=12&dpr=1.3&pid=1.7&rm=3' WHERE ProductID = 80;

