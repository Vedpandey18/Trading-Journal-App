import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/premium_theme.dart';
import '../../main_new.dart';
import 'premium_register_screen.dart';

/// Premium Login Screen
/// Modern fintech design with glassmorphism and animations
class PremiumLoginScreen extends StatefulWidget {
  const PremiumLoginScreen({Key? key}) : super(key: key);

  @override
  State<PremiumLoginScreen> createState() => _PremiumLoginScreenState();
}

class _PremiumLoginScreenState extends State<PremiumLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to premium navigation screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      final error = authProvider.error ?? 'Login failed';
      String displayError = error;
      if (error.contains('Cannot connect') || error.contains('Connection')) {
        displayError = 'Cannot connect to backend. Please ensure backend is running on port 8081.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(displayError)),
            ],
          ),
          backgroundColor: PremiumTheme.lightLoss,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: PremiumTheme.gradientBackground(brightness),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(PremiumTheme.spaceXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Theme Toggle
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          brightness == Brightness.dark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: brightness == Brightness.light
                              ? PremiumTheme.lightTextSecondary
                              : PremiumTheme.darkTextSecondary,
                        ),
                        onPressed: () => themeProvider.toggleTheme(),
                        tooltip: 'Toggle theme',
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Animated Logo
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  PremiumTheme.lightPrimary,
                                  PremiumTheme.lightPrimaryLight,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: PremiumTheme.lightPrimary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: PremiumTheme.spaceXL),
                    
                    // Welcome Text
                    Text(
                      'Welcome Back',
                      style: PremiumTheme.heading1(brightness),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PremiumTheme.spaceSM),
                    Text(
                      'Sign in to continue tracking your trades',
                      style: PremiumTheme.bodyMedium(brightness),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PremiumTheme.space2XL),
                    
                    // Glassmorphism Card
                    Container(
                      decoration: BoxDecoration(
                        color: brightness == Brightness.light
                            ? Colors.white.withOpacity(0.9)
                            : PremiumTheme.darkCard.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(PremiumTheme.radiusLG),
                        border: Border.all(
                          color: brightness == Brightness.light
                              ? PremiumTheme.lightBorder.withOpacity(0.5)
                              : PremiumTheme.darkBorder.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: PremiumTheme.shadowLG(brightness),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(PremiumTheme.spaceXL),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Username Field
                              TextFormField(
                                controller: _usernameController,
                                style: PremiumTheme.bodyLarge(brightness),
                                decoration: InputDecoration(
                                  labelText: 'Username or Email',
                                  labelStyle: PremiumTheme.labelMedium(brightness),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: brightness == Brightness.light
                                        ? PremiumTheme.lightTextSecondary
                                        : PremiumTheme.darkTextSecondary,
                                  ),
                                  filled: true,
                                  fillColor: brightness == Brightness.light
                                      ? PremiumTheme.lightBackground
                                      : PremiumTheme.darkBackground,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username or email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: PremiumTheme.spaceMD),
                              
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: PremiumTheme.bodyLarge(brightness),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: PremiumTheme.labelMedium(brightness),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: brightness == Brightness.light
                                        ? PremiumTheme.lightTextSecondary
                                        : PremiumTheme.darkTextSecondary,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: brightness == Brightness.light
                                          ? PremiumTheme.lightTextSecondary
                                          : PremiumTheme.darkTextSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: brightness == Brightness.light
                                      ? PremiumTheme.lightBackground
                                      : PremiumTheme.darkBackground,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: PremiumTheme.spaceLG),
                              
                              // Login Button
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(PremiumTheme.radiusSM),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Sign In',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: PremiumTheme.spaceLG),
                    
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: PremiumTheme.bodyMedium(brightness),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PremiumRegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: PremiumTheme.bodyMedium(brightness).copyWith(
                              color: brightness == Brightness.light
                                  ? PremiumTheme.lightPrimary
                                  : PremiumTheme.darkPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
