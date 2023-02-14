import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'driver_profile.dart';
import 'keys/keys.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providerConfigs: const [
                EmailProviderConfiguration(),
              ],
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: action == AuthAction.signIn
                      ? const Text('Please Sign In')
                      : const Text('Please Sign Up'),
                );
              },
              footerBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Column(
                    children: const [
                      GoogleSignInButton(
                          clientId: googleProviderConfigurationClientID),
                      PhoneVerificationButton(label: 'Sign with Phone')
                    ],
                  ),
                );
              },
            );
          }
          return const DriverProfileScreen();
        },
      ),
    );
  }
}
