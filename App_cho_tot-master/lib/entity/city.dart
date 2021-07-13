class City{
  String id;
  String name;
  bool isCheck;
  City({this.id, this.name, this.isCheck = false});
  factory City.fromJson(Map<String, dynamic> json){
    return City(name: json['name'], id: json['_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['isCheck'] = this.isCheck;
    return data;
  }
}