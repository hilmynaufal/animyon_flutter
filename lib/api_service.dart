import 'package:http/http.dart' as http;

class ApiService {
  // static const String url = 'http://192.168.0.115:3000/';

  static Future<http.Response> getCall(
      {required String baseUrl, required String header}) async {
    final response = await http.get(Uri.parse('$baseUrl$header'));

    return response;
  }
}
