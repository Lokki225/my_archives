import 'package:flutter/material.dart';

import '../../../../cubits/app_cubit.dart';
import '../../../../injection_container.dart';

class CreatePinCodeScreen extends StatefulWidget {
  const CreatePinCodeScreen({super.key});

  @override
  State<CreatePinCodeScreen> createState() => _CreatePinCodeScreenState();
}

class _CreatePinCodeScreenState extends State<CreatePinCodeScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  void _savePin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (pin.length != 4 || confirmPin.length != 4) {
      _showError("PIN must be 4 digits");
      return;
    }

    if (pin != confirmPin) {
      _showError("PINs do not match");
      return;
    }

    final firstName = await sL<AppCubit>().getUserFirstName();
    final id = await sL<AppCubit>().getUserIDByFirstName(firstName!);

    print("Logged Id: $id");

    await sL<AppCubit>().setUserPINCode(id!, pin);
    Navigator.pushReplacementNamed(context, '/VerifyPinCodeScreen');

  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create PIN Code')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 250),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'Enter PIN Code', labelStyle: TextStyle(color: Colors.white),),
            ),
            TextField(
              controller: _confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'Confirm PIN Code', labelStyle: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade200,
              ),
              onPressed: _savePin,
              child: const Text(
                'Save PIN Code',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
