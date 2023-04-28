import 'package:flutter/material.dart';
import 'package:service_app/screens/login_screen.dart';
import 'package:service_app/screens/register_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 140.0,
          width: 140.0,
          child: Image.asset("assets/images/logo.png"),
        ),
        backgroundColor: Color.fromRGBO(61, 38, 12, 1),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(225, 211, 190, 1),
              Color.fromRGBO(245, 237, 226, 1),
              Colors.white,
              Colors.white,
              Color.fromRGBO(245, 237, 226, 1),
              Color.fromRGBO(225, 211, 190, 1),
            ],
            stops: [
              0.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a ServicesApp!',
                style: TextStyle(
                  color: Color.fromRGBO(61, 38, 12, 1),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Encuentra trabajadores de oficios varios para cualquier tarea que necesites en tu hogar o negocio.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(61, 38, 12, 1),
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(61, 38, 12, 1),
                    ),
                    child: Text('Iniciar Sesión'),
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(61, 38, 12, 1),
                    ),
                    child: Text('Registrarse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
