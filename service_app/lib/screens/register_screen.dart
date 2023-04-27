import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/core/auth_services.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late AuthService _authService;
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    final nombres = _nombresController.text;
    final apellidos = _apellidosController.text;
    final telefono = _telefonoController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      _authService
          .register(nombres, apellidos, telefono, email, password)
          .then((value) {
        if (!value['error']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(61, 38, 12, 1),
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(61, 38, 12, 1)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _emailController.text = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(61, 38, 12, 1)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _passwordController.text = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nombresController,
                  decoration: InputDecoration(
                      labelText: 'Nombres',
                      prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(61, 38, 12, 1)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your names';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombresController.text = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _apellidosController,
                  decoration: InputDecoration(
                      labelText: 'Apellidos',
                      prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(61, 38, 12, 1)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last names';
                    }
                    return null;
                  },
                  onSaved: (value) => _apellidosController.text = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(61, 38, 12, 1)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _telefonoController.text = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _submitForm();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(61, 38, 12, 1),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
