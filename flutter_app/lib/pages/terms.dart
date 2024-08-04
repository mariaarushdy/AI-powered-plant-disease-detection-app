import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
        backgroundColor: Colors.green[700], // Custom color for the plant care theme
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800], // Theme-specific text color
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Our services specific to drone-based plant care include but are not limited to:\n'
                      '• Automated plant monitoring using drones.\n'
                      '• Data analysis for plant health and growth patterns.\n'
                      '• Integration with other smart farming tools.\n'
                      '• User data and privacy policies specific to the geographical and regulatory norms applicable to drone usage.\n\n'
                      'By using our drone services, you agree to adhere to local regulations concerning drone flights and privacy. It is essential to ensure that your use of our services does not infringe on any local laws or personal privacy.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/drone_logo.png', // Updated image path relevant to drone services
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for choosing our drone-based solutions for your plant care needs!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}