import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function() onLogoutPressed;
  final Function() onRoute1Pressed;
  final Function() onRoute2Pressed;

  const CustomAppBar({
    Key? key,
    required this.onLogoutPressed,
    required this.onRoute1Pressed,
    required this.onRoute2Pressed,
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
      backgroundColor: Color.fromRGBO(255, 153, 0, 1),
      title: const Text('ServicesApp'),
      actions: [
        CustomDropdown(
          onLogoutPressed: widget.onLogoutPressed,
          onRoute1Pressed: widget.onRoute1Pressed,
          onRoute2Pressed: widget.onRoute2Pressed,
        ),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final Function() onLogoutPressed;
  final Function() onRoute1Pressed;
  final Function() onRoute2Pressed;

  const CustomDropdown({
    Key? key,
    required this.onLogoutPressed,
    required this.onRoute1Pressed,
    required this.onRoute2Pressed,
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
          value: 'Logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Route 1',
          child: ListTile(
            leading: Icon(Icons.directions),
            title: Text('Route 1'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Route 2',
          child: ListTile(
            leading: Icon(Icons.map),
            title: Text('Route 2'),
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
        if (_selectedOption == 'Logout') {
          widget.onLogoutPressed();
        } else if (_selectedOption == 'Route 1') {
          widget.onRoute1Pressed();
        } else if (_selectedOption == 'Route 2') {
          widget.onRoute2Pressed();
        }
      },
      offset: Offset(0, kToolbarHeight),
      elevation: _isDropdownActive ? 8 : 0,
    );
  }
}
