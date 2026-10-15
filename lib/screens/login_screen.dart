
import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

const Color loginRed = Color(0xFFD62828);
const Color loginYellow = Color(0xFFFFC928);
const Color loginGreen = Color(0xFF239447);
const Color loginNavy = Color(0xFF142B45);
const Color loginPale = Color(0xFFFFF9E9);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: loginGreen,
        content: Text(
          'Login UI only. Connect your REST API to authenticate.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginPale,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 700;

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFFE6A0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: loginNavy.withOpacity(0.10),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: isWide
                        ? IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                const Expanded(
                                  flex: 5,
                                  child: _WelcomePanel(),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: _buildLoginForm(),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              const _WelcomePanel(),
                              _buildLoginForm(),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TrikeFindLogo(),
            const SizedBox(height: 35),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: loginNavy,
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Log in to continue your journey!',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              '',
              style: TextStyle(
                color: loginNavy,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _usernameController,
              label: 'Username',
              hint: 'Enter your username',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            const Text(
              '',
              style: TextStyle(
                color: loginNavy,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Log In',
                fullWidth: true,
                backgroundColor: loginRed,
                icon: Icons.login_rounded,
                onPressed: _login,
              ),
            ),

            const SizedBox(height: 18),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                ),
                label: const Text('Back to Home'),
                style: TextButton.styleFrom(
                  foregroundColor: loginGreen,
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Find your local tricycle drivers with TRIKEFIND.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF239447),
            Color(0xFF176D38),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: loginYellow,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.electric_rickshaw_rounded,
              color: loginNavy,
              size: 43,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'TRIKEFIND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Your Community, Connected.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Find registered tricycle drivers in your selected '
            'barangay and get useful location information.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 25),
          const _WelcomeFeature(
            icon: Icons.location_on_outlined,
            text: 'Barangay-based driver locations',
          ),
          const SizedBox(height: 13),
          const _WelcomeFeature(
            icon: Icons.map_outlined,
            text: 'Location-based map information',
          ),
          const Row(
            children: [
              _TrafficLightDot(color: loginRed),
              SizedBox(width: 8),
              _TrafficLightDot(color: loginYellow),
              SizedBox(width: 8),
              _TrafficLightDot(color: Color(0xFF8BE0A1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WelcomeFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WelcomeFeature({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: loginYellow, size: 20),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrafficLightDot extends StatelessWidget {
  final Color color;

  const _TrafficLightDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13,
      width: 13,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.65),
          width: 1,
        ),
      ),
    );
  }
}

class _TrikeFindLogo extends StatelessWidget {
  const _TrikeFindLogo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.electric_rickshaw_rounded,
          color: loginRed,
          size: 30,
        ),
        SizedBox(width: 8),
        Text(
          'TRIKEFIND',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: loginNavy,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
