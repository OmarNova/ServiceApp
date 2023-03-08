import 'package:flutter/material.dart';
import 'package:service_app/screens/login_screen.dart';
import 'package:service_app/screens/micuenta.dart';
import 'package:service_app/screens/socio.dart';
import 'package:service_app/screens/solicitud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_app/screens/build_card.dart';
import 'package:service_app/customwidgets/custom_appbar.dart';
import 'package:service_app/screens/micuenta.dart';
import 'package:service_app/customwidgets/cards.dart';

import 'mapa.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _token = '';
  String _selectedRole = 'equisde';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onMiCuentaPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MiCuentaScreen(
                        nombreUsuario: 'Juan Pérez',
                        correo: 'Juanperez@gmail.com',
                        fotoPerfil:
                            'https://cdn-icons-png.flaticon.com/512/3001/3001758.png',
                      )));
        },
        onRoute1Pressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SolicitudScreen()));
        },
        onRoute2Pressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FindFriends()));
        },
        onSocioPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SocioScreen()));
        },
        onLogoutPressed: () async {
          await _logout(context);
          await _deleteToken(context);
          _loadToken();
        },
      ),
      body: Column(
        children: [
          Container(
            height: 50, // Altura del espacio en la parte superior
            //aca puede ir un widget
          ),
          Expanded(
            child: ListView(
              children: [
                WorkerCard(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3001/3001758.png',
                  name: 'Juan Páez',
                  description: 'Electricista',
                  rating: 4,
                ),
                WorkerCard(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3048/3048122.png',
                  name: 'Omar Nova',
                  description: 'Plomero',
                  rating: 3,
                ),
                WorkerCard(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3001/3001785.png',
                  name: 'Mario Hurtado',
                  description: 'Constructor',
                  rating: 3,
                ),
                // Agrega más instancias de WorkerCard aquí
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    final deletedToken = prefs.getString('token');
    print('Token eliminado: $deletedToken');
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
