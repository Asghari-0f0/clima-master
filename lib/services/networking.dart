import 'package:http/http.dart';
import 'dart:convert';

class NetWorkHelper{
  String url;

  NetWorkHelper(this.url);


  Future getData() async {
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

    } else {
      print(response.statusCode);
    }
  }
}