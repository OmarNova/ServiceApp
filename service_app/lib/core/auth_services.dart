import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _prefs;

class AuthService {
  final String baseUrl = 'http://serviceapp.bucaramanga.upb.edu.co/api';

  Future<SharedPreferences> get preferencias async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String passwd}) async {
    final url = Uri.parse('$baseUrl/empleador/login'); //$baseUrl/users/login
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
      final token = jsonDecode(response.body);
      print(token);
      return token;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<bool> deleteToken() async {
    final _prefrencias = await preferencias;
    final result = await _prefrencias.remove('token');
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

    var res = await http.post(Uri.parse('$baseUrl/empleador/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print("Hay error. Llamar al +57 317-285-6951");
      throw Exception('Failed to authenticate');
    }
  }

  Future<Map<String, dynamic>> registerSocio(
    String trabajo,
    String descripcion,
    String categoria,
  ) async {
    final _prefrencias = await preferencias;
    final token = await _prefrencias.getString('token');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (token != null && await isTokenValid(token)) {
      headers['authorization'] = token;
    }

    final body = {
      'trabajo': trabajo,
      'descripcion': descripcion,
      'categoria': categoria,
    };
    print("bbbbbbbbbbbbbbbbbbbbb");
    print(categoria);
    var res = await http.post(Uri.parse('$baseUrl/trabajador/register'),
        headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      print("se registro correctamente el socio");
      return jsonDecode(res.body);
    } else {
      print('Error al registrarse');
      throw Exception('Failed to authenticate');
    }
  }

  Future<List<Map<String, dynamic>>> infoTrabajador() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trabajadores'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> workers = data['trabajadores'];

        return workers
            .map((worker) => {
                  'imageUrl': worker['imageUrl'],
                  'nombres': worker['nombres'],
                  'descripcion': worker['descripcion'],
                  'trabajo': worker['trabajo'],
                  'categoria': worker['categoria'],
                  'rating': worker['rating'],
                })
            .toList();
      } else {
        throw Exception('Failed to fetch workers');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching workers');
    }
  }

  Future<Map<String, dynamic>> getEmpleadorInfo(String token) async {
    final headers = {
      'Content-Type': 'application/json',
      'authorization': token,
    };

    final response =
        await http.get(Uri.parse('$baseUrl/empleador'), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['datos'][0];
    } else {
      throw Exception('Failed to fetch employer data');
    }
  }

  Future<Map<String, dynamic>> enviarSolicitud(
      Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/empleador/solicitud');
    final _prefrencias = await preferencias;
    final token = await _prefrencias.getString('token');
    print('Token:$token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': "$token",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error en la solicitud: ${response.statusCode}');
      print('Mensaje del servidor: ${response.body}');
      throw Exception('Failed to send request');
    }
  }

  Future<List<String>> getCategorias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categorias'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          final categorias = List<String>.from(data['categorias']);
          return categorias;
        } else {
          throw Exception('API error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching categories');
    }
  }

  Future<List<Map<String, dynamic>>> getSolicitudes() async {
    try {
      final _prefrencias = await preferencias;
      final token = await _prefrencias.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/empleador/solicitudes'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': "$token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> solicitudes =
            jsonDecode(response.body)['solicitudes'];

        return solicitudes
            .map((solicitud) => {
                  'titulo': solicitud['titulo'],
                  'descripcion': solicitud['descripcion'],
                  'direccion': solicitud['direccion'],
                })
            .toList();
      } else {
        throw Exception('Failed to fetch solicitudes');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching solicitudes');
    }
  }
}
