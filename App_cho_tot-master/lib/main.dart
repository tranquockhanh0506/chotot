import 'dart:collection';
import 'dart:convert';

import 'package:chotot/bindings.dart';
import 'package:chotot/custom_rect_tween.dart';
import 'package:chotot/hero_router.dart';
import 'package:chotot/controller.dart';
import 'package:chotot/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'infomation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(), home: Home()));
}

class Home extends StatelessWidget {
  Controller _controller;
  Map<String, String> status = {"1": "Chưa xem", "2": "Đã liên hệ", "3": "Đã bán", "4": "Không nghe máy", "5": "Đã xem"};
  Map<String, MaterialColor> statusColor = {"1": Colors.brown, "2": Colors.green, "3": Colors.red, "4": Colors.amber, "5": Colors.lightBlue};
  List<String> postBy = ["Tất cả", "Cá nhân", "Cửa hàng"];

  @override
  Widget build(BuildContext context) {
    _controller = Get.find();
    return Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: AppBar(
          title: Text('Trang chủ'),
          elevation: 0,
          backgroundColor: Color(0xffffba00),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  height: Get.height * 0.1,
                  decoration: BoxDecoration(color: Color(0xffffba00), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Obx(() => CupertinoTextField(
                                  controller: _controller.textEditingController.value,
                                  onSubmitted: (value) {
                                    _controller.fetchData(
                                        title: _controller.textEditingController.value.text,
                                        loaiCH: _controller.loaiCH.value,
                                        page: 1,
                                        limit: 20,
                                        typeMoto: _controller.selectType.value,
                                        location: _controller.selectCity.value);
                                  },
                                  textInputAction: TextInputAction.search,
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(CupertinoIcons.search),
                                  ),
                                ))),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final pref = await SharedPreferencesService.instance;
                                    var jsonString = pref.getCityFilter;
                                    if (jsonString != null && jsonString.isNotEmpty) {
                                      _controller.listCity.value = Map.from(json.decode(jsonString));
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return dialogLocation(context);
                                        });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.location,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Obx(() => Flexible(
                                            child: Text(
                                              _controller.selectCity.value.length == 0 ? "Tất cả" : _controller.selectCityString.value.toString(),
                                              style: TextStyle(color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return dialogType(context);
                                        });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pedal_bike,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Obx(() => Flexible(
                                            child: Text(
                                              _controller.selectType.value,
                                              style: TextStyle(color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return dialogPostBy(context);
                                        });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.person,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Obx(() => Flexible(
                                            child: Text(
                                              _controller.loaiCH.value,
                                              style: TextStyle(color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sản phẩm mới nhất',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Expanded(child: ListProduct())
              ],
            ),
            Center(
                child: Obx(() => _controller.isLoad.value
                    ? Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoActivityIndicator(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text('Loading...'),
                            ),
                          ],
                        ),
                      )
                    : Container()))
          ],
        ));
  }

  Widget ListProduct() {
    final moneyFormat = new NumberFormat("#,###đ", "en_US");
    return Obx(() => NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_controller.isLoad.value) {
              _controller.loadMore(
                  title: _controller.textEditingController.value.text,
                  loaiCH: _controller.loaiCH.value,
                  page: ++_controller.page.value,
                  limit: 20,
                  typeMoto: _controller.selectType.value,
                  location: _controller.selectCity.value);
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _controller.fetchData(
                  title: _controller.textEditingController.value.text,
                  loaiCH: _controller.loaiCH.value,
                  page: 1,
                  limit: 20,
                  typeMoto: _controller.selectType.value,
                  location: _controller.selectCity.value);
            },
            child: _controller.listItem.value.length != 0
                ? ListView.builder(
                    itemCount: _controller.listItem.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (_controller.listItem.value[index].status == 1) {
                            _controller.updateStatus(id: _controller.listItem.value[index].id, status: Status.da_xem, index: index, note: _controller.listItem.value[index].note);
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Information(
                                    controller: _controller,
                                    index: index,
                                  )));
                        },
                        child: Container(
                          height: 165,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _controller.listItem.value[index].urlImage ?? 'https://ctagency.vn/wp-content/uploads/2020/05/404.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        _controller.listItem.value[index].title,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _controller.listItem.value[index].timeAgo,
                                        style: TextStyle(color: Colors.black54),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "${_controller.listItem.value[index].typeCompanyProduct} - ${_controller.listItem.value[index].yearRegister}",
                                        style: TextStyle(color: Colors.black54),
                                        maxLines: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            moneyFormat.format(int.parse(_controller.listItem.value[index].price)),
                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          ),
                                          Container(
                                            child: Text(
                                              status['${_controller.listItem.value[index].status}'],
                                              style: TextStyle(color: statusColor['${_controller.listItem.value[index].status}'], fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            CupertinoIcons.person,
                                            size: 18,
                                            color: Colors.black54,
                                          ),
                                          Text(
                                            ' ${_controller.listItem.value[index].loaiCH} -',
                                            style: TextStyle(color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                          Icon(CupertinoIcons.location, size: 18, color: Colors.black54),
                                          Expanded(
                                            child: Text(
                                              _controller.listItem.value[index].location,
                                              style: TextStyle(color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        Text(
                          'Không có sản phẩm',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }

  Widget dialogLocation(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Vị trí',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(
            thickness: 1,
            height: 0,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: Get.height * .7),
            child: ListView(
              children: _controller.listCity.value.keys.map((String key) {
                return Obx(() => CheckboxListTile(
                    value: _controller.listCity.value[key],
                    title: Text(key),
                    onChanged: (value) {
                      _controller.listCity.value[key] = value;
                      if (key == "Tất cả") {
                        _controller.selectAll(check: value);
                      }
                      _controller.listCity.refresh();
                      _controller.checkSelectAll(value: value);
                      _controller.getSelect();
                    }));
              }).toList(),
            ),
          ),
          MaterialButton(onPressed: () async {
            final pref = await SharedPreferencesService.instance;
            pref.saveCheckbox(json.encode(_controller.listCity.value));
            Get.back();
            _controller.fetchData(
                title: _controller.textEditingController.value.text,
                loaiCH: _controller.loaiCH.value,
                page: 1,
                limit: 20,
                typeMoto: _controller.selectType.value,
                location: _controller.selectCity.value);
          }, child: Text("Lọc"), color: Colors.yellow,)
        ],
      ),
    );
  }

  Widget dialogType(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Loại xe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(
            thickness: 1,
            height: 0,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: Get.height * .7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _controller.listMoto.value.map((e) {
                  return InkWell(
                    onTap: () {
                      _controller.selectType.value = e.name;
                      filterAction();
                    },
                    child: ListTile(
                      title: Text(e.name.toString()),
                      leading: Obx(() => Theme(
                          data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.red, disabledColor: Colors.blue), child: Radio(value: e.name, groupValue: _controller.selectType.value))),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dialogPostBy(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Đăng bởi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(
            thickness: 1,
            height: 0,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: Get.height * .7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: postBy.map((e) {
                  return InkWell(
                    onTap: () {
                      _controller.loaiCH.value = e;
                      filterAction();
                    },
                    child: ListTile(
                      title: Text(e.toString()),
                      leading: Obx(
                          () => Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.red, disabledColor: Colors.blue), child: Radio(value: e, groupValue: _controller.loaiCH.value))),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  filterAction() {
    Get.back();
    _controller.fetchData(
        title: _controller.textEditingController.value.text, loaiCH: _controller.loaiCH.value, page: 1, limit: 20, typeMoto: _controller.selectType.value, location: _controller.selectCity.value);
  }
}
