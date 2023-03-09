import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:photo_viewer/photo_model.dart';

class ApiServices {
  Future<List<Photo>> photoServices(int page) async {
    try {
      final url =
          Uri.parse('https://jsonplaceholder.typicode.com/photos?_page=$page');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var json = photoFromJson(response.body);
        return json;
      }
    } catch (e) {
      log(e.toString());
    }
    return throw '';
  }
}
