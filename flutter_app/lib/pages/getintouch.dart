import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.green[700], // Consistent color theme
      ),
      body: Container(
        alignment: Alignment.center, // Ensures everything is centered
        padding: const EdgeInsets.all(16.0),
        color: Colors.green[50], // Soft green background
        child: SingleChildScrollView( // Allows the content to be scrollable
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60, // Increased radius
                backgroundImage: AssetImage('assets/the_legend.jpg'),
              ),
              SizedBox(height: 30), // Increased space
              ContactInfoCard(
                name: 'Maria Roshdy',
                email: 'mariaroshdy17@gmail.com',
                linkedInUrl: 'https://www.linkedin.com/in/linkedinmaria',
                githubUrl: 'https://github.com/githubmaria',
              ),
              SizedBox(height: 20), // Increased space
              ElevatedButton(
                onPressed: () {
                  // Implement feedback submission logic
                },
                child: Text("Submit Feedback", style: TextStyle(fontSize: 18)), // Increased font size
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Increased padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String linkedInUrl;
  final String githubUrl;

  const ContactInfoCard({
    required this.name,
    required this.email,
    required this.linkedInUrl,
    required this.githubUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12), // Slightly increased margin
      elevation: 4, // Increased elevation for more depth
      child: Padding(
        padding: EdgeInsets.all(20), // Increased padding for a roomier layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Increased font size
            ),
            SizedBox(height: 8), // Adjusted spacing
            InkWell(
              onTap: () => _launchURL('mailto:$email'),
              child: Text(
                email,
                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Colors.blue), // Increased font size
              ),
            ),
            InkWell(
              onTap: () => _launchURL(linkedInUrl),
              child: Text(
                'LinkedIn',
                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Colors.blue), // Increased font size
              ),
            ),
            InkWell(
              onTap: () => _launchURL(githubUrl),
              child: Text(
                'GitHub',
                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Colors.blue), // Increased font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }
}