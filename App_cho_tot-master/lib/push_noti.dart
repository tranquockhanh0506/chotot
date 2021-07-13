import 'package:chotot/controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class PushNotificationsManager {
  PushNotificationsManager._();
  static String token = "";
  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
  PushNotificationsManager._();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  Future<void> init({controller}) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      token = await _firebaseMessaging.getToken();
      print("Device Token:---->$token");

      _initialized = true;

      handlePushNotificationEvents();
    }
  }

  @override
  void dispose() {
    _initialized = false;
    _firebaseMessaging = null;
  }

  Future<void> handlePushNotificationEvents() async {
    Controller _controller = Get.find();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        //Add some navigation logic here
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        if(GetPlatform.isAndroid){
          String content = await message['notification']['title'];
          Get.snackbar("Có sản phẩm mới", content, onTap: (value){
            _controller.fetchData(
                title: _controller.textEditingController.value.text,
                loaiCH: _controller.loaiCH.value,
                page: 1,
                limit: 20,
                typeMoto: _controller.selectType.value,
                location: _controller.selectCity.value);
          });
        }else{
          String content = await message['aps']['alert']['title'] + message['aps']['alert']['body'];
          Get.snackbar("Có sản phẩm mới", content, onTap: (value){
            _controller.fetchData(
                title: _controller.textEditingController.value.text,
                loaiCH: _controller.loaiCH.value,
                page: 1,
                limit: 20,
                typeMoto: _controller.selectType.value,
                location: _controller.selectCity.value);
          });
        }

      },
    );
    _firebaseMessaging.subscribeToTopic("minhhoangjsc");
  }
}