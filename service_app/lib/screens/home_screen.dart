import 'package:flutter/material.dart';
import 'package:service_app/screens/find_friends.dart';
import 'package:service_app/screens/login_screen.dart';
import 'package:service_app/screens/micuenta.dart';
import 'package:service_app/screens/socio.dart';
import 'package:service_app/screens/solicitud.dart';
import 'package:service_app/screens/solicitudes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_app/customwidgets/custom_appbar.dart';
import 'package:service_app/customwidgets/cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Always use this as the skeleton of the views
class MyMaterialApp extends StatefulWidget {
  Widget body;
  MyMaterialApp(this.body, {Key? key}) : super(key: key);

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  String _token = '';
  String _selectedRole = 'equisde';

  @override
  void initState() {
    super.initState();
    _loadToken();
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
                        name: 'Juan Pérez',
                        email: 'Juanperez@gmail.com',
                        profileImageUrl:
                            'http://serviceapp.bucaramanga.upb.edu.co/api/empleador/imagen/perfil?token=$_token',
                        token: _token,
                      )));
        },
        onRoute1Pressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SolicitudScreen()));
        },
        onRoute2Pressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FindFriends()));
        },
        onSocioPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SocioScreen()));
        },
        onSolicitudesPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SolicitudesScreen()));
        },
        onLogoutPressed: () async {
          await _logout(context);
          await _deleteToken(context);
          _loadToken();
        },
      ),
      body: widget.body,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String _token = '';
  String _selectedRole = 'equisde';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Widget _buildSolicitudesButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SolicitudesScreen()),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyMaterialApp(
      Column(
        children: [
          Container(
            height: 50, // Altura del espacio en la parte superior
            //aca puede ir un widget
          ),
          Expanded(
            child: Stack(
              children: [
                WorkerCardList(), // Reemplaza el ListView aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}
