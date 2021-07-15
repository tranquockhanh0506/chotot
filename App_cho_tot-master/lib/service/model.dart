import 'dart:convert';

import 'package:chotot/entity/city.dart';
import 'package:chotot/entity/item.dart';
import 'package:chotot/push_noti.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class Model {
  Dio dio = new Dio();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static String token = "";

  init() {
    dio.options.baseUrl = 'http://45.32.113.69:4000/api/';
    dio.options.connectTimeout = 15000; //15s
    dio.options.receiveTimeout = 3000;
  }
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

  // Fetch present city
  Future<List<String>> fetchPresentCity() async {
    List<String> listCity = [];
    token = await _firebaseMessaging.getToken();
    Response response = await dio.post("get-city-present", data: {"token":"$token"});
    List<dynamic> _list = response.data['data']['arr_city'];
    print('sdfdsff ${response.data['data']['arr_city']}');
    _list.forEach((element) {;
      listCity.add(element);
    });
    return listCity;
  }

  // Update city by check
  Future<String> updateCityPresent({List<String> locations}) async {
    token = await _firebaseMessaging.getToken();
    Response response = await dio.post("update-city-notify", data: {"token": "$token", "diadiem" : locations});
    print('tOKEN : $token');
    return response.data['statuscode'].toString();
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
