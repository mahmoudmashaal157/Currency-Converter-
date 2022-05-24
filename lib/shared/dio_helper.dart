import 'package:dio/dio.dart';

class DioHelper  {

  static late Dio dio;

  static void dioInit(){
    dio = Dio(
      BaseOptions(
        headers: {"apikey":"2PGtqaKdORL9QHN22t1e15PBCeAGjNVM",
        },
      )
    );
  }

  static Future<Response> get({required String url})async{
    return await dio.get(url);
  }


}