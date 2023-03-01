import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final passwd = _passwordController.text.trim();
    final url = Uri.parse(
        'http://100.25.20.233:8080/api/user/login'); // Reemplaza con la URL correcta

    final response = await http.post(
      url,
      body: json.encode({'email': email, 'passwd': passwd}),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['token'] != null) {
        final token = data['token'];
        await _prefs.setString('token', token);
        print('Token: $token');

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Inicio de sesión exitoso'),
              content: const Text('Tus credenciales son correctas'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.3),
              child: AlertDialog(
                title: const Text('Error'),
                content: Text(json.decode(response.body)['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogIn'),
        backgroundColor: Color.fromRGBO(255, 153, 0, 1),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            key: _formKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.network(
                    'https://cdn.vox-cdn.com/thumbor/IULs8cgukIn_-pIgMY9WFZsVOUk=/0x0:1280x800/1400x788/filters:focal(640x400:641x401)/cdn.vox-cdn.com/uploads/chorus_asset/file/19700731/googlemaps.png'),
              ),
              const Center(
                child: Text('ServicesApp',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 16,
              ),
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _login();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(255, 153, 0, 1))),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
