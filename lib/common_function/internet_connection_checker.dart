import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ConnectionChecker {
  static Future<bool> checkConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        print("-------1111  connectivityResult : $connectivityResult    --------------");
        return false;
      } else {
        print("-------2222  connectivityResult : $connectivityResult    --------------");
        return true;
      }
    } on PlatformException catch (e) {
      debugPrint("Error : $e");
      return false;
    }
  }
}
