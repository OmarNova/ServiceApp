import 'package:http/http.dart' as http;
import 'dart:convert';


class Api {
  final String _url = 'http://100.25.20.233:8080/api';

  Api();
  Future<String?> login(String email, String password) async {
    final body = {'email':email, 'passwd': password};
   
    var res = await http.post(Uri.parse('$_url/user/login'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(body));
  
    if(res.statusCode == 200){
      return jsonDecode(utf8.decode(res.bodyBytes));
    }else{
      print("Hay error. Llamar al +57 317-285-6951");
      return null;
    }
  }

  Future<String?> register(String nombres, String apellidos, String telefono, String email, String password) async {
    final body = {
      'email':email, 
      'passwd': password,
      'nombres':nombres, 
      'apellidos': apellidos,
      'telefono': telefono
      };
   
    var res = await http.post(Uri.parse('$_url/user/register'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(body));
  
    if(res.statusCode == 200){
      return jsonDecode(utf8.decode(res.bodyBytes));
    }else{
      print("Hay error. Llamar al +57 317-285-6951");
      return null;
    }
  }


}