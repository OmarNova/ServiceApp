import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function() onMiCuentaPressed;
  final Function() onRoute1Pressed;
  final Function() onRoute2Pressed;
  final Function() onSocioPressed;
  final Function() onSolicitudesPressed;
  final Function() onLogoutPressed;

  const CustomAppBar({
    Key? key,
    required this.onMiCuentaPressed,
    required this.onRoute1Pressed,
    required this.onRoute2Pressed,
    required this.onSocioPressed,
    required this.onSolicitudesPressed,
    required this.onLogoutPressed,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _selectedOption = 'Logout';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: SizedBox(
        height: 140.0, // aumentar el valor de height
        width: 140.0, // aumentar el valor de width
        child: Image.asset("assets/images/logo.png"),
      ),
      backgroundColor: Color.fromRGBO(63, 121, 255, 1),
      actions: [
        CustomDropdown(
          onMiCuentaPressed: widget.onMiCuentaPressed,
          onRoute1Pressed: widget.onRoute1Pressed,
          onRoute2Pressed: widget.onRoute2Pressed,
          onSocioPressed: widget.onSocioPressed,
          onSolicitudesPressed: widget.onSolicitudesPressed,
          onLogoutPressed: widget.onLogoutPressed,
        ),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final Function() onMiCuentaPressed;
  final Function() onRoute1Pressed;
  final Function() onRoute2Pressed;
  final Function() onSocioPressed;
  final Function() onSolicitudesPressed;
  final Function() onLogoutPressed;

  const CustomDropdown({
    Key? key,
    required this.onMiCuentaPressed,
    required this.onRoute1Pressed,
    required this.onRoute2Pressed,
    required this.onSocioPressed,
    required this.onSolicitudesPressed,
    required this.onLogoutPressed,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String _selectedOption = 'Logout';
  bool _isDropdownActive = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Mi Cuenta',
          child: ListTile(
            leading: Icon(
              Icons.person,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Mi Cuenta'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Route 1',
          child: ListTile(
            leading: Icon(
              Icons.room_service,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Hacer solicitud'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Solicitudes Usuarios',
          child: ListTile(
            leading: Icon(
              Icons.construction,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Solicitudes Usuarios'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Route 2',
          child: ListTile(
            leading: Icon(
              Icons.map_outlined,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Mapa'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Ofrecer servicio',
          child: ListTile(
            leading: Icon(
              Icons.person_add,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Ofrecer servicio'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Logout',
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Color.fromRGBO(61, 38, 12, 1),
            ),
            title: Text('Logout'),
          ),
        ),
      ],
      icon: const Icon(Icons.menu),
      onCanceled: () {
        setState(() {
          _isDropdownActive = false;
        });
      },
      onSelected: (value) {
        setState(() {
          _isDropdownActive = false;
          _selectedOption = value;
        });
        if (_selectedOption == 'Mi Cuenta') {
          widget.onMiCuentaPressed();
        } else if (_selectedOption == 'Route 1') {
          widget.onRoute1Pressed();
        } else if (_selectedOption == 'Route 2') {
          widget.onRoute2Pressed();
        } else if (_selectedOption == 'Ofrecer servicio') {
          widget.onSocioPressed();
        } else if (_selectedOption == 'Logout') {
          widget.onLogoutPressed();
        } else if (_selectedOption == 'Solicitudes Usuarios') {
          widget.onSolicitudesPressed();
        }
      },
      offset: Offset(0, kToolbarHeight),
      elevation: _isDropdownActive ? 8 : 0,
    );
  }
}
