import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.green[700],  // Consistent with the plant care theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "This Privacy Policy outlines how information collected through our Drone Plant Care app is used and safeguarded. By using our app, you consent to the collection and use of your data in accordance with this policy.\n\n"
                  "Information Collection:\n"
                  "- We collect information you provide directly to us, such as when you register, submit queries, or communicate with us.\n"
                  "- We automatically collect certain information from the drone operations, including imagery, geographic data, device locations, and information collected through sensors and other tracking technologies.\n\n"
                  "Use of Information:\n"
                  "- To provide, maintain, and improve our drone-based plant care service\n"
                  "- To analyze plant health and offer tailored care suggestions\n"
                  "- To allow you to control drone operations and access real-time data\n"
                  "- To provide customer support and respond to your requests\n"
                  "- To ensure the secure operation of our services and protect against misuse\n\n"
                  "Disclosure of Data:\n"
                  "- We may disclose your personal information where required by law or to protect our rights and safety, or the rights and safety of others.\n\n"
                  "Security:\n"
                  "The security of your data is paramount to us, but no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.\n\n"
                  "Changes to This Privacy Policy:\n"
                  "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n"
                  "Contact Us:\n"
                  "If you have any questions about this Privacy Policy, please contact us.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/drone_logo.png',  // Updated to a drone-related image
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}