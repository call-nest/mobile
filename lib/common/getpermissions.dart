import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPermissions{
  static Future<bool> getCameraPermission() async{
    PermissionStatus permissionStatus = await Permission.camera.status;
    if(permissionStatus.isGranted) {
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.camera.request();
      if(status.isGranted) {
        return true;
      }else{
        Fluttertoast.showToast(msg: "카메라 권한이 필요합니다.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        return false;
      }
    }
    return false;
  }

  static Future<bool> getStoragePermission() async{
    PermissionStatus permissionStatus = await Permission.storage.status;
    if(permissionStatus.isGranted) {
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.storage.request();
      if(status.isGranted) {
        return true;
      }else{
        Fluttertoast.showToast(msg: "저장소 권한이 필요합니다.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        return false;
      }
    }
    return false;
  }
}