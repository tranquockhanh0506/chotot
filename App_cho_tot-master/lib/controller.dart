import 'package:chotot/infomation.dart';
import 'package:chotot/push_noti.dart';
import 'package:chotot/service/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'entity/city.dart';
import 'entity/item.dart';

class Controller extends GetxController {
  Rx<Status> status = Rx<Status>();
  Rx<List<Item>> listItem = Rx<List<Item>>();
 // Rx<List<City>> listCity = Rx<List<City>>();
  Rx<List<City>> listMoto = Rx<List<City>>();
  Rx<List<String>> selectCity = Rx<List<String>>();
  Rx<String> selectType = Rx<String>();
  Rx<int> page = Rx<int>();
  Rx<bool> isLoad = Rx<bool>();
  Rx<String> loaiCH = Rx<String>();
  Rx<bool> enableRefesh = Rx<bool>();
  Rx<TextEditingController> textEditingController = Rx<TextEditingController>();
  Model model;
  Rx<Map<String,bool>> listCity = Rx<Map<String,bool>>();
  Rx<List<String>> listPresentCity = Rx<List<String>>();
  Rx<String> selectCityString = Rx<String>();
  Rx<String> topic = Rx<String>();
  @override
  void onInit() {
    print('sadasdasd');
    PushNotificationsManager().init().then((value){
      fetchData(page: 1, limit: 20);
    });
    page.value = 1;
    isLoad.value = true;
    listItem.value = [];
    topic.value = "";
    City _city = City(name: "Tất cả", id: "all");
    listCity.value = {"Tất cả" : true};
    listMoto.value = [];
    init();
    model = Model();
    model.init();

    // City fetching
    model.fetchCity().then((value) {
      value.forEach((element) {
        listCity.value[element.name] = true;
      });
      listCity.obs;
      print('List City after add: ${listCity.value}');
    });

    // City present fetching
    model.fetchPresentCity().then((value) {
      if (value.isNotEmpty) {
        listCity.value.forEach((key, value) {
          listCity.value[key] = false;
        });
        value.forEach((element) {
          listCity.value[element] = true;
        });
      }
      print('CityPresent: $value');
    });

    // Motor bike fetching
    model.fetchMotobike().then((value) {
      value.insert(0, _city);
      listMoto.value = value;
    });
    super.onInit();
  }

  init() {
    selectType.value = 'Tất cả';
    selectCity.value = [];
    loaiCH.value = 'Tất cả';
    enableRefesh.value = true;
    textEditingController.value = TextEditingController();
    textEditingController.value.text = "";
  }
  getSelect(){
    selectCity.value = [];
    topic.value = "";
    listCity.value.forEach((key, value) {
      if(!listCity.value['Tất cả']){
        if(value){
          selectCity.value.add(key);
        }
      }else{
        selectCity.value = [];
      }
    });
    selectCityString.value = "";
    selectCity.value.forEach((element) {
      if(selectCity.value.length == 1){
        selectCityString.value += element;
      }else{
        selectCityString.value += element + ", ";
      }
    });
    selectCity.refresh();
  }
  selectAll({bool check}){
    listCity.value.forEach((key, value) {
        listCity.value[key] = check;
    });
  }
  checkSelectAll({bool value}){
    int countAll = 0;
    listCity.value.forEach((key, value) {
      if(value){
        countAll++;
      }
    });
    if(value){
      if(countAll == listCity.value.length - 1){
        listCity.value['Tất cả'] = true;
      }
    }else{
      if(countAll < listCity.value.length){
        listCity.value['Tất cả'] = false;
      }
    }
    listCity.refresh();
  }

  // Update city present
  updateCityPresent(List<String> locations) {
    print('updateCityPresent() -- $locations');
    model.updateCityPresent(locations: locations).then((value) {
      print('Location updated: $locations');
    });
  }
  // Fetch list motor bike
  fetchData({title,List<String> location, typeMoto, loaiCH, limit, int page}) {
    if (location == []) {
      location = null;
    }
    if (typeMoto == 'Tất cả') {
      typeMoto = null;
    }
    if (loaiCH == 'Tất cả') {
      loaiCH = null;
    }
    isLoad.value = true;
    model.searchAndFetchData(title: title, location: location?.length == 0 ? null : location, typeMoto: typeMoto, loaiCH: loaiCH, limit: limit, page: page).then((value) {
      listItem.value = value;
      isLoad.value = false;
      this.page.value = 1;
    });
  }
  loadMore({title, location, typeMoto, loaiCH, limit, int page}) {
    if (location == 'Tất cả') {
      location = null;
    }
    if (typeMoto == 'Tất cả') {
      typeMoto = null;
    }
    if (loaiCH == 'Tất cả') {
      loaiCH = null;
    }
    isLoad.value = true;
    model.searchAndFetchData(title: title, location: location?.length == 0 ? null : location, typeMoto: typeMoto, loaiCH: loaiCH, limit: limit, page: page).then((value) {
      listItem.value.addAll(value);
      listItem.refresh();
      isLoad.value = false;
    });
  }
  updateStatus({@required id, note, status, @required index}) {
    int _status = 1;
    switch (status) {
      case Status.chua_xem:
        _status = 1;
        break;
      case Status.da_lien_he:
        _status = 2;
        break;
      case Status.da_ban:
        _status = 3;
        break;
      case Status.khong_nghe_may:
        _status = 4;
        break;
      case Status.da_xem:
        _status = 5;
        break;
    }
    model.update(id: id, note: note, status: _status);
    listItem.value[index].status = _status;
    listItem.value[index].note = note;
    listItem.refresh();
  }
  makePhoneCall(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      Get.snackbar("Lỗi", "Số điện thoại không đúng");
    }
  }

}
