import 'package:flutter/material.dart';
import 'package:service_app/customwidgets/custom_appbar.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/screens/login_screen.dart';
import 'package:service_app/screens/micuenta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_app/core/auth_services.dart';

class SocioScreen extends StatefulWidget {
  const SocioScreen({Key? key}) : super(key: key);
  @override
  State<SocioScreen> createState() => _SocioScreenState();
}

class _SocioScreenState extends State<SocioScreen> {
  String _token = '';
  final _formKey = GlobalKey<FormState>();
  late AuthService _authService;
  final _emailController = TextEditingController();
  final _trabajoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final dropdownController = TextEditingController();
  String? _categoria;
  bool _isLoading = false;
  //List<String> _categorias = ['Limpieza & Aseo', 'Plomería', 'Mantenimiento'];
  List<String> _categorias = [];

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final trabajo = _trabajoController.text;
    final descripcion = _descripcionController.text;

    try {
      _authService
          .registerSocio(email, trabajo, descripcion, _categoria!)
          .then((value) {
        if (!value['error']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          print(value['message']);
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.3),
              child: AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyMaterialApp(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Introduce tu email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce un email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _trabajoController,
                decoration: InputDecoration(
                  labelText: 'Trabajo',
                  hintText: 'Introduce el trabajo que ofreces',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce un trabajo válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Introduce una breve descripción del trabajo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce una descripción válida';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _categoria,
                items: [
                  DropdownMenuItem(
                    value: 'limpieza&aseo',
                    child: Text('Limpieza y Aseo'),
                  ),
                  DropdownMenuItem(
                    value: 'plomeria',
                    child: Text('Plomería'),
                  ),
                  DropdownMenuItem(
                    value: 'mantenimiento',
                    child: Text('Mantenimiento'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Selecciona una categoría',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    dropdownController.text = value!;
                    _categoria = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(255, 153, 0, 1))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authService.registerSocio(
                        _emailController.text,
                        _trabajoController.text,
                        _descripcionController.text,
                        dropdownController.text,
                      );
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    print(_categoria);
                  },
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
