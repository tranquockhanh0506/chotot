class Item {
   String id;
   String namePerson;
   String urlImage;
   String title;
   String typeProduct;
   String price;
   String timeAgo;
   String location;
   String description;
   String typeCompanyProduct;
   String yearRegister;
   int km;
   String dungtichxe;
   String loaiCH;
   int status;
   String note;
   String phone;

  Item(
      {this.id,
      this.namePerson,
      this.urlImage,
      this.title,
      this.typeProduct,
      this.price,
      this.timeAgo,
      this.location,
      this.description,
      this.typeCompanyProduct,
      this.yearRegister,
      this.km,
      this.dungtichxe,
      this.loaiCH,
      this.status,
      this.phone,
      this.note});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['_id'],
        namePerson: json['tennguoiban'],
        urlImage: json['image'],
        title: json['title'],
        typeProduct: json['loaixe'],
        price: json['gia'].toString(),
        timeAgo: json['date'],
        location: json['diadiem'],
        description: json['mota'],
        typeCompanyProduct: json['hangxe'],
        yearRegister: json['namdangky'],
        km: json['sokm'],
        dungtichxe: json['dungtichxe'],
        loaiCH: json['loaiCH'],
        status: json['trangthai'],
        phone: json['sodt'],
        note: json['ghichu']);
  }
}
