import 'dart:convert';

import 'package:chotot/entity/city.dart';
import 'package:chotot/entity/item.dart';
import 'package:chotot/push_noti.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Model {
  Dio dio = new Dio();

  init() {
    dio.options.baseUrl = 'http://45.32.113.69:4000/api/';
    dio.options.connectTimeout = 15000; //15s
    dio.options.receiveTimeout = 3000;
  }

  // Future<List<Item>> fetchData({limit = 20, page = 1}) async {
  //   Response response = await dio.post('find-all', data: {"limit": limit, "page": page});
  //   List<dynamic> _list = response.data["message"];
  //   List<Item> listIteam = List<Item>();
  //   Item _item;
  //   _list.forEach((element) {
  //     _item = Item.fromJson(element);
  //     listIteam.add(_item);
  //   });
  //   return listIteam;
  // }

  Future<List<City>> fetchCity() async {
    List<City> listCity = [];
    Response response = await dio.post("get-city");
    List<dynamic> _list = response.data['data'];
    _list.forEach((element) {
      City _city = City.fromJson(element);
      listCity.add(_city);
    });
    return listCity;
  }

  Future<List<City>> fetchMotobike() async {
    List<City> listMotobike = [];
    Response response = await dio.post("get-type");
    List<dynamic> _list = response.data['data'];
    _list.forEach((element) {
      City _motobike = City.fromJson(element);
      listMotobike.add(_motobike);
    });
    return listMotobike;
  }

  Future<List<Item>> searchAndFetchData({title = "", location, typeMoto = "", loaiCH = "", limit = 20, page = 1}) async {
    print(location);
    print(PushNotificationsManager.token);
    Response response = await dio.post("find-all", data: {"title": title, "diadiem": location, "loaixe": typeMoto, "loaiCH": loaiCH, "limit" : limit, "page": page, "token" : PushNotificationsManager.token,});
    List<dynamic> _list = response.data["message"];
    List<Item> listIteam = [];
    Item _item;
    _list.forEach((element) {
      _item = Item.fromJson(element);
      listIteam.add(_item);
    });
    return listIteam;
  }

  update({@required id, status = 5, note = ''}) async {
    print("----------");
    print(id);
    print(status);
    print(note);
    Response response = await dio.post("update", data: {"id": id, "status": status, "note": note});
    print(response.data);
  }
}
