import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sign_up/main.dart';
import 'package:sign_up/model/user.dart';
import 'package:sign_up/screens/dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool passwordInvisible = true;
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> pickimage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = pickedFile;
    });
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      if (image == null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a profile image')),
        );
        return;
      }

      bool emailExists = users.any((user) => user.email == email.text);
      if (emailExists) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A user with this email already exists'),
          ),
        );
        return;
      }

      String profileImage = image!.path;

      User newUser = User(
        name: name.text,
        email: email.text,
        password: password.text,
        phoneNumber: phoneNumber.text,
        profilePicture: profileImage,
      );

      users.add(newUser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(user: newUser)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickimage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade700,
                backgroundImage: image != null
                    ? FileImage(File(image!.path))
                    : null,
                child: image == null
                    ? Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: name,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.account_box, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter your name' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter your email' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: password,
              obscureText: passwordInvisible,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordInvisible == true
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordInvisible = !passwordInvisible;
                    });
                  },
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your password' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: phoneNumber,
              decoration: InputDecoration(
                labelText: 'Contact',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.phone, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your phone number' : null,
            ),
            SizedBox(height: 36),
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: signUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
