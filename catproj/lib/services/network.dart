import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  NetworkService(this.url);
  final Uri url;

  Future getData() async {
    http.Response response = await http.get(url);
    if(response.statusCode != 200){
      print('ERROR response status code: ${response.statusCode}');
    }else {
      String data = response.body;
      var jsonData = jsonDecode(data);
      print('json data: $jsonData');
      return jsonData;
    }
  }
}

