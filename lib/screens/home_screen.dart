
import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import 'login_screen.dart';

const Color trikeRed = Color(0xFFD62828);
const Color trikeYellow = Color(0xFFFFC928);
const Color trikeGreen = Color(0xFF239447);
const Color trikeNavy = Color(0xFF142B45);
const Color trikePale = Color(0xFFFFF9E9);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLogin = false;

  void _openLogin() => setState(() => _showLogin = true);
  void _closeLogin() => setState(() => _showLogin = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavigation(context),
                  _buildHero(context),
                  _buildFeatures(),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),

        if (_showLogin) ...[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeLogin,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.42),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: LoginScreen(onClose: _closeLogin),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 18,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.electric_rickshaw_rounded,
            color: trikeRed,
            size: 32,
          ),
          const SizedBox(width: 8),
          const Text(
            'TRIKEFIND',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: trikeNavy,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          if (MediaQuery.sizeOf(context).width > 600) ...[
            TextButton(
              onPressed: () {},
              child: const Text(
                'Home',
                style: TextStyle(color: trikeNavy),
              ),
            ),
            TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('About TRIKEFIND'),
                  content: const Text(
                    'TRIKEFIND helps passengers view '
                    'registered tricycle driver locations '
                    'in their selected barangay.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              child: const Text(
                'About',
                style: TextStyle(color: trikeNavy),
              ),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: 110,
            child: AppButton(
              text: 'Log In',
              fullWidth: true,
              backgroundColor: trikeRed,
              onPressed: _openLogin,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
  final isWide = MediaQuery.sizeOf(context).width > 750;

  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/tricycle.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 130, 130, 126).withValues(alpha: 0.88),
            trikeNavy.withValues(alpha: 0.62),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: _buildHeroText(context)),
                    const SizedBox(width: 40),
                    const Expanded(child: MapPreview()),
                  ],
                )
              : Column(
                  children: [
                    _buildHeroText(context),
                    const SizedBox(height: 35),
                    const MapPreview(),
                  ],
                ),
        ),
      ),
    ),
  );
}

  Widget _buildHeroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE89A),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: trikeGreen, size: 10),
              SizedBox(width: 7),
              Text(
                'YOUR COMMUNITY, CONNECTED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Find a Tricycle\nNear You.',
          style: TextStyle(
            color: trikeNavy,
            fontSize: 42,
            height: 1.15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Know whether registered tricycle drivers are nearby '
          'or available in your selected barangay. TRIKEFIND '
          'helps passengers find local driver information '
          'using location-based mapping.',
          style: TextStyle(
            color: Color(0xFFF1F5F9),
            fontSize: 16,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 165,
              child: AppButton(
                text: 'Get Started',
                fullWidth: true,
                backgroundColor: trikeRed,
                icon: Icons.arrow_forward_rounded,
                onPressed: _openLogin,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('How TRIKEFIND Works'),
                  content: const Text(
                    '1. Log in to your account.\n\n'
                    '2. Select your barangay.\n\n'
                    '3. View registered driver location information.\n\n'
                    'TRIKEFIND focuses on driver localization '
                    'and availability information, not ride booking.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(
                Icons.play_circle_outline,
                color: trikeGreen,
              ),
              label: const Text('How It Works'),
              style: OutlinedButton.styleFrom(
                foregroundColor: trikeNavy,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 16,
                ),
                side: const BorderSide(color: trikeGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: trikeGreen,
              size: 20,
            ),
            SizedBox(width: 7),
            Flexible(
              child: Text(
                'Focused on your selected barangay',
                style: TextStyle(
                  color: Color(0xFF536477),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  

  Widget _buildFeatures() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 55,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'A Smarter Way to Find Local Drivers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: trikeNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Useful location information for passengers and drivers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 35),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns =
                      constraints.maxWidth > 750 ? 3 : 1;
                  final cardWidth =
                      (constraints.maxWidth -
                          (columns - 1) * 18) /
                      columns;

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: const FeatureCard(
                          icon: Icons.location_on_rounded,
                          iconColor: trikeGreen,
                          title: 'Nearby Drivers',
                          description:
                              'View registered tricycle drivers '
                              'associated with your selected area.',
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: const FeatureCard(
                          icon: Icons.map_rounded,
                          iconColor: trikeRed,
                          title: 'Barangay Search',
                          description:
                              'Choose a barangay to see relevant '
                              'driver location information.',
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: const FeatureCard(
                          icon: Icons.insights_rounded,
                          iconColor: Color(0xFFB88600),
                          title: 'Smart Insights',
                          description:
                              'Use location and movement data to '
                              'support driver availability predictions.',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: trikeNavy,
      child: const Text(
        '© TRIKEFIND | Tricycle Driver and Passenger Localization',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 205),
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4ECF0)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: trikeNavy.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0C2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: trikeNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEDD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD5E2DE)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: RoadPainter()),
          ),
          Positioned(
            top: 18,
            left: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: trikeRed),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search your barangay',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.tune_rounded, color: trikeNavy),
                ],
              ),
            ),
          ),
          const _MapMarker(left: 55, top: 120),
          const _MapMarker(left: 185, top: 170),
          const _MapMarker(left: 285, top: 105),
          Positioned(
            right: 22,
            bottom: 35,
            child: Container(
              width: 145,
              height: 120,
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: trikeGreen, size: 10),
                  SizedBox(width: 8),
                  Text(
                    'Driver map preview',
                    style: TextStyle(
                      color: trikeNavy,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final double left;
  final double top;

  const _MapMarker({
    required this.left,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: trikeGreen,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: trikeNavy.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.electric_rickshaw_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFDDEAD7)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final roadPaint = Paint()
      ..color = const Color(0xFFFFFEF8)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPaths = [
      Path()
        ..moveTo(-20, size.height * 0.30)
        ..lineTo(size.width * 0.45, size.height * 0.50)
        ..lineTo(size.width + 20, size.height * 0.28),
      Path()
        ..moveTo(size.width * 0.25, -20)
        ..lineTo(size.width * 0.45, size.height * 0.50)
        ..lineTo(size.width * 0.35, size.height + 20),
      Path()
        ..moveTo(size.width * 0.72, -20)
        ..lineTo(size.width * 0.63, size.height * 0.53)
        ..lineTo(size.width + 20, size.height * 0.80),
    ];

    for (final path in roadPaths) {
      canvas.drawPath(path, roadPaint);
    }

    final linePaint = Paint()
      ..color = const Color(0xFFE6E1D2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final path in roadPaths) {
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
