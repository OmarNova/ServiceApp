import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://serviceapp.bucaramanga.upb.edu.co/api';
  late SharedPreferences _prefs;

  AuthService() {
    SharedPreferences.getInstance().then((prefs) => _prefs = prefs);
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String passwd}) async {
    final url = Uri.parse('$baseUrl/user/login'); //$baseUrl/users/login
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passwd': passwd}),
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body);
      if (!token['error']) {
        await _saveToken(token['token']);
      }

      return token;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<bool> deleteToken() async {
    _prefs = await SharedPreferences.getInstance();
    final result = await _prefs.remove('token');
    return result;
  }

  Future<bool> isTokenValid(String token) async {
    return !JwtDecoder.isExpired(token);
  }

  Future<Map<String, dynamic>> register(String nombres, String apellidos,
      String telefono, String email, String password) async {
    final body = {
      'email': email,
      'passwd': password,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono
    };

    var res = await http.post(Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print("Hay error. Llamar al +57 317-285-6951");
      throw Exception('Failed to authenticate');
    }
  }
}
