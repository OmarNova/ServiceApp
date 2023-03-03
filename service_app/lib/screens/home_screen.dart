import 'package:flutter/material.dart';
import 'package:service_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_app/screens/build_card.dart';
import 'package:service_app/customwidgets/custom_appbar.dart';

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
        onLogoutPressed: () async {
          await _logout(context);
          await _deleteToken(context);
          _loadToken();
        },
        onRoute1Pressed: () {
          // handle route 1 press
        },
        onRoute2Pressed: () {
          // handle route 2 press
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
                CardItem(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                  name: 'Jossyr',
                  role: 'equisde',
                  description: 'cositas',
                ),
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
