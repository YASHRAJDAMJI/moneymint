import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'generate_mnemonic_page.dart';

class UserDataInputPage extends StatefulWidget {
  @override
  _UserDataInputPageState createState() => _UserDataInputPageState();
}

class _UserDataInputPageState extends State<UserDataInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user account with email as username and PAN number as password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, // Using email as username
          password: _panCardController.text, // Using PAN card as password
        );

        // Get user UID
        String uid = userCredential.user!.uid;

        // Add user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'dob': _dobController.text,
          'aadharNumber': _aadharController.text,
          'panCard': _panCardController.text,
        });

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GenerateMnemonicPage(),
          ),
        );
      } catch (e) {
        print('Error creating user: $e');
        // Handle error here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Input'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aadharController,
                decoration: InputDecoration(labelText: 'Aadhar Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Aadhar number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _panCardController,
                decoration: InputDecoration(labelText: 'PAN Card'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your PAN card';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('This is the next screen'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserDataInputPage(),
  ));
}
