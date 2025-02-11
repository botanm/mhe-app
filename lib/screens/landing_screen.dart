import 'package:flutter/material.dart';
import 'package:mohe_app_1_x_x/screens/mohe-app/scientific_title_screen.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/auth.dart';
import 'core/auth/login/login_screen.dart';
import 'mohe-app/attendance_screen.dart';
import 'mohe-app/certification_screen.dart';
import 'mohe-app/committee_screen.dart';
import 'mohe-app/deputation_screen.dart';
import 'mohe-app/leave_screen.dart';
import 'mohe-app/me_screen.dart';
import 'mohe-app/operate_screen.dart';
import 'mohe-app/punishment_screen.dart';
import 'mohe-app/research_screen.dart';
import 'mohe-app/reward_screen.dart';
import 'mohe-app/salary_screen.dart';
import 'mohe-app/thanks_letter_screen.dart';

class LandingScreen extends StatelessWidget {
  // Define the menu items with their respective icons, labels, and colors
  static const List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.person_search,
      'label': 'زانیاری کەسی',
      'color': Colors.pink,
      'route': MeScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.school,
      'label': 'بڕوانامە',
      'color': kPrimaryColor,
      'route': CertificationsScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.attach_money,
      'label': 'مووچە، دەرماڵە',
      'color': Colors.orange,
      'route': SalaryScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.thumb_up_alt_outlined,
      'label': 'سوپاس',
      'color': Colors.greenAccent,
      'route': ThanksLetterScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.business_center_outlined,
      'label': 'نازناوی زانستی',
      'color': Colors.blue,
      'route': ScientificTitleScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.refresh,
      'label': 'دەست بەکاربوونەوە',
      'color': Colors.red,
      'route': OperateScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.airplanemode_active_outlined,
      'label': 'مۆڵەت و باڵانس',
      'color': Colors.green,
      'route': LeaveScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.event_available,
      'label': 'ئامادەبوون',
      'color': Colors.orange,
      'route': AttendanceScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.group_outlined,
      'label': 'شاندکردن',
      'color': Colors.purple,
      'route': DeputationScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.person_search,
      'label': 'باڵانس',
      'color': Colors.pink,
      'route': CertificationsScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.gavel,
      'label': 'سزا',
      'color': Colors.yellow,
      'route': PunishmentScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.group,
      'label': 'لێژنە',
      'color': Colors.cyan,
      'route': CommitteeScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.star_border_outlined,
      'label': 'پاداشت',
      'color': Colors.blue,
      'route': RewardScreen.routeName,
      'requiresAuth': true
    },
    {
      'icon': Icons.biotech,
      'label': 'توێژینەوە',
      'color': Colors.brown,
      'route': ResearchScreen.routeName,
      'requiresAuth': true
    },

    // Add more items with different colors as needed
  ];

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuth = Provider.of<Auth>(context).isAuth;
    return Scaffold(
      // backgroundColor: Colors.grey[200], // Background color to match Facebook app
      appBar: AppBar(
        title: const Text('زانیاری کەسی'),
        backgroundColor: Colors.white,
        iconTheme:
            const IconThemeData(color: Colors.black), // Black icons in AppBar
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Padding around the grid
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 10.0, // Horizontal spacing between items
            mainAxisSpacing: 10.0, // Vertical spacing between items
            childAspectRatio: 3 / 2.1, // Width to height ratio
          ),
          itemBuilder: (context, index) {
            return MenuItem(
              icon: menuItems[index]['icon'],
              label: menuItems[index]['label'],
              color: menuItems[index]['color'], // Passing the color
              onTap: () {
                Navigator.pushNamed(
                  context,
                  menuItems[index]['requiresAuth'] && !isAuth
                      ? LoginScreen.routeName
                      : menuItems[index]['route'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color, // Accept color
    required this.onTap,
  });

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false; // Tracks if the item is pressed

  // Handle tap down to start the scaling animation
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  // Handle tap up to reverse the scaling animation and trigger onTap
  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  // Handle tap cancel to reverse the scaling animation
  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0, // Scale down to 95% when pressed
      duration: const Duration(milliseconds: 100), // Animation duration
      curve: Curves.easeInOut, // Animation curve
      child: Material(
        color: Colors.white, // Background color of the menu item
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        elevation: 2.0, // Shadow elevation
        child: InkWell(
          borderRadius:
              BorderRadius.circular(8.0), // Match the container's border radius
          // onTap: widget.onTap, // Handle tap
          onTapDown: _handleTapDown, // Handle tap down
          onTapUp: _handleTapUp, // Handle tap up
          onTapCancel: _handleTapCancel, // Handle tap cancel
          splashColor: kPrimaryLightColor, // Ripple color
          child: Container(
            padding: const EdgeInsets.all(16.0), // Padding inside the menu item
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(8.0), // Padding inside the container
                  height: 50, // Adjust height to make sure it fits the icon
                  width: 50, // Adjust width to match the height
                  decoration: BoxDecoration(
                    color: widget.color
                        .withOpacity(0.06), // Background color with opacity
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)), // Rounded corners
                  ),
                  child: Icon(
                    widget.icon,
                    size:
                        24.0, // Adjust icon size to fit well within the container
                    color: widget.color, // Set the icon color
                  ),
                ),
                const SizedBox(height: 10), // Spacing between icon and label
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 15, // Font size
                    fontWeight: FontWeight.w500, // Font weight
                    color: Colors.black, // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
