import 'dart:async';
import 'package:catproj/services/network.dart';



class RestAPIService {
  Future<dynamic> getRestfulAPIData() async {
    Uri url = Uri(
      scheme: 'https',
      host: 'meowfacts.herokuapp.com',
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    return data;
  }
}


