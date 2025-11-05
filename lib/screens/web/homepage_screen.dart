import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/signup_screen.dart';

class WebHomePage extends StatelessWidget {
  const WebHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: 24,
        title: Row(
          children: [
            Image.asset('images/nacasegreen.png', height: 40),
            const SizedBox(width: 12),
            
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: const Text('Register'),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: _LandingContent(),
    );
  }
}

class _LandingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Hero section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final twoCols = constraints.maxWidth > 900;
                      final isDesktop = constraints.maxWidth >= 1100;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: isDesktop ? MediaQuery.of(context).size.height * 0.5 : 0,
                        ),
                        child: Flex(
                          direction: twoCols ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              twoCols ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment:
                                    twoCols ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: twoCols ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'As a Nigerian...',
                                        textAlign: twoCols ? TextAlign.start : TextAlign.center,
                                        style: theme.textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w200,
                                          height: 1.15,
                                        ),
                                      ),
                                      Text(
                                        'Have you ever been tricked by House/Land Agent?',
                                        textAlign: twoCols ? TextAlign.start : TextAlign.center,
                                        style: (isDesktop ? theme.textTheme.displayLarge : theme.textTheme.displaySmall)?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        'Harrassed by a Police Officer?',
                                        textAlign: twoCols ? TextAlign.start : TextAlign.center,
                                        style: (isDesktop ? theme.textTheme.displayLarge : theme.textTheme.displaySmall)?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        'Person Owe you money and e no wan pay back?',
                                        textAlign: twoCols ? TextAlign.start : TextAlign.center,
                                        style: (isDesktop ? theme.textTheme.displayLarge : theme.textTheme.displaySmall)?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "You deserve the best. You deserve acute representation. You deserve a lawyer that's going to go all in for you. Whether it be an arrest, A business registeration, Purchase of property, Divorce or child custody through the aid of our smart filtering technology and AI, Nacase connects you to certified lawyers in your location swiftly and sharparly.",
                                    textAlign: twoCols ? TextAlign.start : TextAlign.center,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    alignment: twoCols ? WrapAlignment.start : WrapAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                                          );
                                        },
                                        child: const Text('Get Started Now'),
                                      ),
                                      
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  // Features grid
                  Text(
                    'Why Nacase',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const [
                      _FeatureCard(
                        icon: Icons.verified_user,
                        title: 'Verified Lawyers',
                        description: 'All lawyers pass admin verification for trust and safety.',
                      ),
                      _FeatureCard(
                        icon: Icons.search,
                        title: 'Smart Discovery',
                        description: 'Search and filter by area of practice and location.',
                      ),
                      _FeatureCard(
                        icon: Icons.lock,
                        title: 'Secure Messaging',
                        description: 'Communicate confidently with secure, reliable chat features.',
                      ),
                      _FeatureCard(
                        icon: Icons.star,
                        title: 'Premium Services',
                        description: 'Upgrade for premium visibility and connection features.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),
                  // CTA band
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ready to start your legal journey?',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green.shade700,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                                );
                              },
                              child: const Text('Create Account'),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                              child: const Text('Sign In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Footer
                  _Footer(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.green.shade700),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final privacyPolicy = TextSpan(
      text: 'Privacy Policy',
      style: const TextStyle(color: Colors.green),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // Replace with your policy URL
          launchUrl(Uri.parse('https://www.nacase.app/privacy'));
        },
    );

    final termsOfUse = TextSpan(
      text: 'Terms of Use',
      style: const TextStyle(color: Colors.green),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // Replace with your terms URL
          launchUrl(Uri.parse('https://www.nacase.app/terms'));
        },
    );

    return Column(
      children: [
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          '© ${DateTime.now().year} Nacase. All rights reserved.',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            children: [
              privacyPolicy,
              const TextSpan(text: '  •  '),
              termsOfUse,
            ],
          ),
        ),
      ],
    );
  }
}