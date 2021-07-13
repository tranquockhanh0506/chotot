import 'package:chotot/hero_router.dart';
import 'package:chotot/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'custom_rect_tween.dart';

class Information extends StatelessWidget {
  Controller controller;
  int index;

  Information({@required Controller controller, @required int index}) {
    this.controller = controller;
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    final moneyFormat = new NumberFormat("#,###đ", "en_US");
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        elevation: 0,
        backgroundColor: Color(0xffffba00),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Color(0xffeeeeee),
                    height: Get.height * .3,
                    child: PageView.builder(
                        itemCount: 1,
                        itemBuilder: (context, int) {
                          return Image.network(
                            controller.listItem.value[index].urlImage ?? 'https://ctagency.vn/wp-content/uploads/2020/05/404.png',
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.listItem.value[index].title.toString(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Giá bán :  ${moneyFormat.format(int.parse(controller.listItem.value[index].price))}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller.listItem.value[index].timeAgo.toString(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Divider(
                      thickness: 0.3,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Text(
                      controller.listItem.value[index].description,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  ItemProduct(icon: Icons.pedal_bike, value: 'Hãng xe: ${controller.listItem.value[index].typeCompanyProduct}'),
                  ItemProduct(icon: CupertinoIcons.calendar, value: 'Năm đăng kí: ${controller.listItem.value[index].yearRegister}'),
                  ItemProduct(icon: Icons.merge_type, value: 'Loại xe: ${controller.listItem.value[index].typeProduct}'),
                  ItemProduct(icon: Icons.local_gas_station, value: 'Dung tích xe: ${controller.listItem.value[index].dungtichxe}'),
                  ItemProduct(icon: CupertinoIcons.clock, value: 'Số km: ${controller.listItem.value[index].km.toString()}'),
                  ItemProduct(icon: CupertinoIcons.person, value: 'Người bán: ${controller.listItem.value[index].namePerson}'),
                  ItemProduct(icon: CupertinoIcons.phone, value: 'SĐT: ${controller.listItem.value[index].phone}'),
                  ItemProduct(icon: CupertinoIcons.location, value: 'Địa điểm: ${controller.listItem.value[index].location}'),
                  ItemProduct(icon: Icons.store, value: 'Loại: ${controller.listItem.value[index].loaiCH}'),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          'Ghi chú : ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Obx(() => Text(controller.listItem.value[index]?.note.toString()))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Get.height * .06,
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1)),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.makePhoneCall('tel:${controller.listItem.value[index].phone}');
                        },
                        child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints.expand(),
                            color: Colors.green,
                            child: Text(
                              'Liên hệ người bán',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                            ))),
                  ),
                  Expanded(
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PopupUpdateStatus();
                            });
                        // Navigator.of(context).push(HeroRouter(buider: (context) => PopupUpdateStatus()));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints.expand(),
                          color: Color(0xffffba00),
                          child: Material(color: Color(0xffffba00), child: Text('Cập nhập trạng thái', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)))),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ItemProduct({@required IconData icon, @required String value}) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text(value))
        ],
      ),
    );
  }

  Widget PopupUpdateStatus() {
    TextEditingController _textEditController = TextEditingController();
    switch (controller.listItem.value[index].status) {
      case 1:
        controller.status.value = Status.chua_xem;
        break;
      case 2:
        controller.status.value = Status.da_lien_he;
        break;
      case 3:
        controller.status.value = Status.da_ban;
        break;
      case 4:
        controller.status.value = Status.khong_nghe_may;
        break;
      case 5:
        controller.status.value = Status.da_xem;
        break;
    }
    print(controller.status.value);
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Trạng thái',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              child: InkWell(
                onTap: () {
                  controller.status.value = Status.da_lien_he;
                },
                child: ListTile(
                  title: Text("Đã liên hệ"),
                  leading: Obx(() => Radio(
                        value: Status.da_lien_he,
                        groupValue: controller.status.value,
                        onChanged: (value) {
                          controller.status.value = Status.da_lien_he;
                        },
                      )),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  controller.status.value = Status.khong_nghe_may;
                },
                child: ListTile(
                  title: Text("Không nghe máy"),
                  leading: Obx(() => Radio(
                        value: Status.khong_nghe_may,
                        groupValue: controller.status.value,
                        onChanged: (value) {
                          controller.status.value = Status.khong_nghe_may;
                        },
                      )),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  controller.status.value = Status.da_ban;
                },
                child: ListTile(
                  title: Text("Đã bán"),
                  leading: Obx(() => Radio(
                        value: Status.da_ban,
                        groupValue: controller.status.value,
                        onChanged: (value) {
                          controller.status.value = Status.da_ban;
                        },
                      )),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  controller.status.value = Status.chua_xem;
                },
                child: ListTile(
                  title: Text("Chưa xem"),
                  leading: Obx(() => Radio(
                        value: Status.chua_xem,
                        groupValue: controller.status.value,
                        onChanged: (value) {
                          controller.status.value = Status.chua_xem;
                        },
                      )),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  controller.status.value = Status.chua_xem;
                },
                child: ListTile(
                  title: Text("Đã xem"),
                  leading: Obx(() => Radio(
                    value: Status.da_xem,
                    groupValue: controller.status.value,
                    onChanged: (value) {
                      controller.status.value = Status.chua_xem;
                    },
                  )),
                ),
              ),
            ),
            Container(
                child: Divider(
              thickness: 1,
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _textEditController,
                decoration: InputDecoration.collapsed(hintText: "Ghi chú"),
                maxLines: 2,
                textInputAction: TextInputAction.done,
              ),
            )),
            Container(
                child: Divider(
              thickness: 1,
            )),
            Container(
              child: Center(
                child: MaterialButton(
                  onPressed: () {
                    controller.updateStatus(id: controller.listItem.value[index].id, status: controller.status.value, note: _textEditController.text, index: index);
                    Get.back();
                    Get.snackbar("Thông báo", "Cập nhập thành công");
                  },
                  child: Text('Lưu'),
                  color: Colors.yellow,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum Status { da_lien_he, khong_nghe_may, da_ban, chua_xem, da_xem }
