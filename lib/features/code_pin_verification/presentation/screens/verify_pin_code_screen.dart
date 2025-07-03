import 'package:flutter/material.dart';

import '../../../../core/database/local.dart';
import '../../../../core/database/seeds/local_database_seeder.dart';
import '../../../../cubits/app_cubit.dart';
import '../../../../injection_container.dart';

class VerifyPinCodeScreen extends StatefulWidget {
  const VerifyPinCodeScreen({super.key});

  @override
  State<VerifyPinCodeScreen> createState() => _VerifyPinCodeScreenState();
}

class _VerifyPinCodeScreenState extends State<VerifyPinCodeScreen> {

  @override
  void initState() {
    super.initState();
  }

  final _pinController = TextEditingController();

  void _verifyPin() async{
    final firstName = await sL<AppCubit>().getUserFirstName();
    final id = await sL<AppCubit>().getUserIDByFirstName(firstName!);

    final correctPin = await sL<AppCubit>().getUserPINCode(id!);

    print("Correct PIN: $correctPin");

    if (_pinController.text == correctPin) {
      Navigator.pushReplacementNamed(context, '/HomeScreen'); // Or your main screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Enter your PIN',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple.shade500,
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: '****',
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                onSubmitted: (_) => _verifyPin(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyPin,
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
