import 'package:chotot/infomation.dart';
import 'package:chotot/controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Controller>(() => Controller());
  }

}