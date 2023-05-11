import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/core/auth_services.dart';
import 'package:http/http.dart' as http;

class MiCuentaScreen extends StatefulWidget {
  final String name;
  final String email;
  final String profileImageUrl;
  final String token;

  MiCuentaScreen({
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.token,
  });

  @override
  State<MiCuentaScreen> createState() => _MiCuentaScreenState();
}

class _MiCuentaScreenState extends State<MiCuentaScreen> {
  Map<String, dynamic> _empleadorInfo = {};
  File? _profileImage;
  DecorationImage? _profileDecorationImage;

  @override
  void initState() {
    super.initState();
    _getEmpleadorInfo();
    _profileDecorationImage = DecorationImage(
      image: NetworkImage(widget.profileImageUrl),
      fit: BoxFit.cover,
    );
  }

  Future<void> _getEmpleadorInfo() async {
    try {
      final empleadorInfo =
          await AuthService().getEmpleadorInfo(widget.token);
      setState(() {
        _empleadorInfo = empleadorInfo;
      });
    } catch (e) {
      print(e);
      throw Exception('Error fetching employer data');
    }
  }

  Future<void> subirImagen(String email, String base64Image) async {
    final url = Uri.parse(
        'http://serviceapp.bucaramanga.upb.edu.co/api/empleador/imagen/perfil');
    final body = {'img': base64Image};
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "authorization": widget.token
    };
     print("ddddddddddd");
     print(base64Image);
    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response);
        print("eeeeeeee");
      if (response.statusCode == 200) {
        print('Imagen subida exitosamente');
      } else {
        print(
            'Error al subir imagen. Código de respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al subir imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(29, 29, 29, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: _profileDecorationImage,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    _empleadorInfo['nombres'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _empleadorInfo['email'] ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    'Información personal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Nombre',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _empleadorInfo['nombres'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Correo electrónico',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _empleadorInfo['email'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Future<void> _showImagePicker(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    final bytes = await photo.readAsBytes();
                    final base64Image = base64Encode(bytes);
                    await subirImagen(widget.email, base64Image);
                    setState(() {
                      _profileImage = File(photo.path);
                      _profileDecorationImage = DecorationImage(
                          image: FileImage(_profileImage!), fit: BoxFit.cover);
                    });
                  }
                  Navigator.pop(context, photo);
                },
                child: const ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a photo'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    final bytes = await photo.readAsBytes();
                    final base64Image = base64Encode(bytes);
                    await subirImagen(widget.email, base64Image);
                    setState(() {
                      _profileImage = File(photo.path);
                      _profileDecorationImage = DecorationImage(
                          image: FileImage(_profileImage!), fit: BoxFit.cover);
                    });
                  }
                  Navigator.pop(context, photo);
                },
                child: const ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Choose from gallery'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _profileDecorationImage = DecorationImage(
            image: FileImage(_profileImage!), fit: BoxFit.cover);
      });
    }
  }

}
