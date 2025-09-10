import 'package:flutter/material.dart';
import '../main_app.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/user_profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showCreateAccount = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String gender = '';
  String village = '';
  String city = '';
  String pincode = '';
  String phone = '';
  String bio = '';
  bool isLoading = false;
  String? errorMessage;

  void _createAccount() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setCurrentUser(
        UserProfile(
          email: email.trim(),
          name: name.trim(),
          gender: gender.trim(),
          village: village.trim(),
          city: city.trim(),
          pincode: pincode.trim(),
          phone: phone.trim(),
          bio: bio.trim(),
          password: password.trim(),
        ),
      );
      setState(() {
        isLoading = false;
        showCreateAccount = false;
        email = '';
        password = '';
        name = '';
        gender = '';
        village = '';
        city = '';
        pincode = '';
        phone = '';
        bio = '';
        errorMessage = 'Account created! Please log in.';
      });
    });
  }

  void _login() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final appState = Provider.of<AppState>(context, listen: false);
      final userIdx = appState.users.indexWhere((u) =>
        u.email.trim() == email.trim() && u.password == password.trim());
      if (userIdx != -1) {
        appState.setLoggedInUserByIndex(userIdx);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainApp()),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid email or password';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showCreateAccount ? 'Create Account' : 'Login'),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showCreateAccount) ...[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (val) => name = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Gender'),
                    value: gender.isNotEmpty ? gender : null,
                    items: [
                      'Male',
                      'Female',
                      'Other',
                      'Prefer not to say'
                    ]
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => gender = val ?? ''),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Select your gender' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Village'),
                    onChanged: (val) => village = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your village' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'City'),
                    onChanged: (val) => city = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your city' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Pincode'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => pincode = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your pincode' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => phone = val,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Enter your phone number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Short Bio'),
                    maxLines: 2,
                    onChanged: (val) => bio = val,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => email = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (val) => password = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter your password' : null,
                ),
                const SizedBox(height: 24),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (isLoading)
                  const CircularProgressIndicator(),
                if (!isLoading) ...[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (showCreateAccount) {
                          _createAccount();
                        } else {
                          _login();
                        }
                      }
                    },
                    child:
                        Text(showCreateAccount ? 'Create Account' : 'Login'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showCreateAccount = !showCreateAccount;
                        errorMessage = null;
                      });
                    },
                    child: Text(showCreateAccount
                        ? 'Back to Login'
                        : 'Create Account'),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
