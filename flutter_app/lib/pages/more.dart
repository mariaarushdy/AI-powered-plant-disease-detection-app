import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using a common theme color for consistency with the SelectedArea page
    Color themeColor = Colors.green[700]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        backgroundColor: themeColor, // Use the same color as in SelectedArea
      ),
      body: Container(
        color: Colors.grey[200], // Light grey for a more neutral background
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 50, // Circular logo for a polished look
                backgroundImage: AssetImage('assets/drone_logo.png'),
              ),
            ),
            SizedBox(height: 20),
            buildListTile(
              icon: Icons.article,
              title: 'Terms of Service',
              onTap: () => Navigator.pushNamed(context, '/terms'),
              themeColor: themeColor,
            ),
            buildListTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () => Navigator.pushNamed(context, '/privacy'),
              themeColor: themeColor,
            ),
            buildListTile(
              icon: Icons.contact_mail,
              title: 'Get in Touch',
              onTap: () => Navigator.pushNamed(context, '/get_in_touch'),
              themeColor: themeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color themeColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeColor),
      title: Text(title, style: TextStyle(color: themeColor)),
      onTap: onTap,
      // Enhanced visual feedback
      hoverColor: themeColor.withOpacity(0.1),
      selectedTileColor: themeColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: themeColor),
      ),
    );
  }
}