import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://100.25.20.233:8080/api';
  late SharedPreferences _prefs;

  AuthService() {
    SharedPreferences.getInstance().then((prefs) => _prefs = prefs);
  }

  Future<String?> authenticate(
      {required String email, required String passwd}) async {
    final url = Uri.parse('$baseUrl/user/login'); //$baseUrl/users/login
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passwd': passwd}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await _saveToken(token);
      return token;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> logout() async {
    await _deleteToken();
  }

  Future<void> _saveToken(String token) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  Future<void> _deleteToken() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('token');
  }

  Future<bool> isTokenValid(String token) async {
    return !JwtDecoder.isExpired(token);
  }
}
