import 'package:http/http.dart' as http;
import 'dart:convert';

// NetworkHelper class focused solely on fetching data from a given URL.
class NetworkHelper {
  Future<dynamic> getData(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
    // return null;
  }
}
