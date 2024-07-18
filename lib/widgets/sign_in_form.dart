import 'package:aqua_terra_manager/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';
import '../services/authentication_service.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _prefs = locator<SharedPreferences>();
  final _authenticationService = locator<AuthenticationService>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                validator: _emailValidator,
                decoration: const InputDecoration(
                  hintText: 'E-Mail',
                  errorMaxLines: 3,
                ),
                onEditingComplete: _submitForm,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: _isLoading
                      ? SizedBox(
                          width: SizeConstants.s400,
                          height: SizeConstants.s400,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        )
                      : const Text('Anmelden'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _prefs.setString('signInEmail', _emailController.text);

    try {
      setState(() {
        _isLoading = true;
      });
      await _authenticationService.sendSignInLink();
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pushNamed(context, 'sign-in/auth');
        setState(() {
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '$e';
      });
      _formKey.currentState!.validate();
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter some text';
    if (_errorMessage != null) return '$_errorMessage';
    return null;
  }
}
