import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  Object? firebaseError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (error) {
    firebaseError = error;
  }

  runApp(KupkopApp(firebaseReady: firebaseReady, firebaseError: firebaseError));
}

class KupkopApp extends StatelessWidget {
  const KupkopApp({super.key, required this.firebaseReady, this.firebaseError});

  final bool firebaseReady;
  final Object? firebaseError;

  @override
  Widget build(BuildContext context) {
    return AuthConfig(
      firebaseReady: firebaseReady,
      firebaseError: firebaseError,
      child: MaterialApp(
        title: 'KUPKOP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: KupkopColors.primary),
          scaffoldBackgroundColor: KupkopColors.canvas,
          fontFamily: 'Nunito',
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: KupkopColors.ink,
            displayColor: KupkopColors.ink,
          ),
        ),
        home: firebaseReady ? const AuthGate() : const WelcomeScreen(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const OnboardingChoiceScreen();
        }

        return const WelcomeScreen();
      },
    );
  }
}

class AuthConfig extends InheritedWidget {
  const AuthConfig({
    super.key,
    required this.firebaseReady,
    required this.firebaseError,
    required super.child,
  });

  final bool firebaseReady;
  final Object? firebaseError;

  static AuthConfig of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AuthConfig>();
    assert(result != null, 'No AuthConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AuthConfig oldWidget) {
    return firebaseReady != oldWidget.firebaseReady ||
        firebaseError != oldWidget.firebaseError;
  }
}

enum WelcomeAction { getStarted, signIn }

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    SizedBox(height: compact ? 6 : 14),
                    const Expanded(flex: 58, child: _HeroArtwork()),
                    SizedBox(height: compact ? 24 : 38),
                    const _BrandLockup(),
                    const Spacer(flex: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 34),
                      child: _WelcomeActions(),
                    ),
                    SizedBox(height: compact ? 22 : 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'src/images/Start.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => const _FallbackArtwork(),
      ),
    );
  }
}

class _FallbackArtwork extends StatelessWidget {
  const _FallbackArtwork();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 300,
        height: 222,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _Bubble(
              alignment: const Alignment(-0.78, -0.2),
              color: KupkopColors.yellow,
              size: 78,
              icon: Icons.medication_liquid_rounded,
            ),
            _Bubble(
              alignment: const Alignment(-0.36, 0.46),
              color: KupkopColors.blue,
              size: 86,
              icon: Icons.menu_book_rounded,
            ),
            _Bubble(
              alignment: const Alignment(0.48, -0.38),
              color: KupkopColors.primary,
              size: 112,
              icon: Icons.family_restroom_rounded,
              iconSize: 50,
            ),
            _Bubble(
              alignment: const Alignment(0.74, 0.36),
              color: KupkopColors.red,
              size: 72,
              icon: Icons.favorite_rounded,
            ),
            Container(
              width: 154,
              height: 154,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: KupkopColors.border, width: 2),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                color: KupkopColors.primary,
                size: 70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.alignment,
    required this.color,
    required this.size,
    required this.icon,
    this.iconSize = 34,
  });

  final Alignment alignment;
  final Color color;
  final double size;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'src/images/KupKop LOGO.png',
          width: 136,
          fit: BoxFit.contain,
          semanticLabel: 'KupKop',
        ),
        const SizedBox(height: 8),
        Text(
          'An app to care for your love ones',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _WelcomeActions extends StatelessWidget {
  const _WelcomeActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PressableButton(
          label: 'GET STARTED',
          backgroundColor: KupkopColors.primary,
          foregroundColor: Colors.white,
          shadowColor: KupkopColors.primaryShadow,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
          },
        ),
        const SizedBox(height: 12),
        _PressableButton(
          label: 'I ALREADY HAVE AN ACCOUNT',
          backgroundColor: Colors.white,
          foregroundColor: KupkopColors.primary,
          borderColor: KupkopColors.borderStrong,
          shadowColor: KupkopColors.borderStrong,
          shadowOffset: 1,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SignInScreen()));
          },
        ),
      ],
    );
  }
}

class _PressableButton extends StatefulWidget {
  const _PressableButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.shadowColor,
    this.borderColor,
    this.shadowOffset = 4,
    this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color shadowColor;
  final Color? borderColor;
  final double shadowOffset;
  final VoidCallback? onPressed;

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final offset = _isPressed ? 0.0 : widget.shadowOffset;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isPressed ? offset : 0, 0),
        height: 48 + widget.shadowOffset,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: widget.shadowOffset,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: widget.shadowColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: offset,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: widget.borderColor == null
                      ? null
                      : Border.all(color: widget.borderColor!, width: 1.5),
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.foregroundColor,
                    fontFamily: 'Baloo',
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 760;

            return _CenteredScrollPage(
              maxWidth: 430,
              horizontalPadding: 34,
              minHeight: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome back!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: KupkopColors.primary,
                      fontFamily: 'Baloo',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: compact ? 18 : 26),
                  SizedBox(
                    height: compact ? 140 : 180,
                    child: Image.asset(
                      'src/images/Sign in page Image.png',
                      fit: BoxFit.contain,
                      semanticLabel: 'Family care sign in image',
                    ),
                  ),
                  SizedBox(height: compact ? 22 : 30),
                  const _InputLabel('Email'),
                  const SizedBox(height: 8),
                  _SignInField(
                    controller: _emailController,
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const _InputLabel('Password'),
                  const SizedBox(height: 8),
                  _SignInField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: KupkopColors.inkMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 24 : 30),
                  _PressableButton(
                    label: _isSubmitting ? 'Signing In...' : 'Sign In',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: _isSubmitting ? null : _signIn,
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: KupkopColors.primary,
                      textStyle: const TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    child: const Text('Forgot Password'),
                  ),
                  SizedBox(height: compact ? 14 : 22),
                  const _SocialAuthButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validateEmailAndPassword(context, email, password)) {
      return;
    }

    final authConfig = AuthConfig.of(context);
    if (!_ensureFirebaseReady(context, authConfig)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingChoiceScreen()),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showAuthMessage(context, _firebaseAuthMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 760;

            return _CenteredScrollPage(
              maxWidth: 430,
              horizontalPadding: 34,
              minHeight: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontFamily: 'Baloo',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: compact ? 48 : 68),
                  const _InputLabel('Email'),
                  const SizedBox(height: 8),
                  _SignInField(
                    controller: _emailController,
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const _InputLabel('Password'),
                  const SizedBox(height: 8),
                  _SignInField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: KupkopColors.inkMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 28 : 34),
                  _PressableButton(
                    label: _isSubmitting ? 'Signing Up...' : 'Sign Up',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: _isSubmitting ? null : _signUp,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        'Have an Account?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontFamily: 'Baloo',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: KupkopColors.primary,
                                fontFamily: 'Baloo',
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 28 : 36),
                  const _SocialAuthButtons(),
                  SizedBox(height: compact ? 34 : 44),
                  const _TermsText(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validateEmailAndPassword(context, email, password)) {
      return;
    }

    final authConfig = AuthConfig.of(context);
    if (!_ensureFirebaseReady(context, authConfig)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingChoiceScreen()),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showAuthMessage(context, _firebaseAuthMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _CenteredScrollPage(
              maxWidth: 430,
              horizontalPadding: 34,
              minHeight: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'src/images/KupKop LOGO.png',
                      width: 132,
                      fit: BoxFit.contain,
                      semanticLabel: 'KupKop',
                    ),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: KupkopColors.ink,
                      fontFamily: 'Baloo',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter your email address and we will help you reset your password.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KupkopColors.inkMuted,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _InputLabel('Email'),
                  const SizedBox(height: 8),
                  _SignInField(
                    controller: _emailController,
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),
                  _PressableButton(
                    label: _isSubmitting ? 'Sending...' : 'Send Reset Link',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: _isSubmitting ? null : _sendResetLink,
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: KupkopColors.primary,
                      textStyle: const TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    child: const Text('Back to Sign In'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showAuthMessage(context, 'Enter a valid email address.');
      return;
    }

    final authConfig = AuthConfig.of(context);
    if (!_ensureFirebaseReady(context, authConfig)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      _showAuthMessage(context, 'Password reset email sent.');
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showAuthMessage(context, _firebaseAuthMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class OnboardingChoiceScreen extends StatelessWidget {
  const OnboardingChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _CenteredScrollPage(
              maxWidth: 254,
              horizontalPadding: 0,
              minHeight: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to KupKop!',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What do you want to do?',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _CareSpaceChoiceCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CareSpaceChoiceCard extends StatelessWidget {
  const _CareSpaceChoiceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: const [
          BoxShadow(color: KupkopColors.ink, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 111,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: KupkopColors.ink, width: 1.2),
            ),
            child: Image.asset(
              'src/images/Onboarding image.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              semanticLabel: 'Family onboarding image',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateCareSpaceScreen(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: KupkopColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              child: const Text('Create Care Space'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: KupkopColors.surfaceLight,
                foregroundColor: Colors.black,
                side: const BorderSide(color: KupkopColors.borderStrong),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              child: const Text('Join Space'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class CreateCareSpaceScreen extends StatefulWidget {
  const CreateCareSpaceScreen({super.key});

  @override
  State<CreateCareSpaceScreen> createState() => _CreateCareSpaceScreenState();
}

class _CreateCareSpaceScreenState extends State<CreateCareSpaceScreen> {
  final _spaceNameController = TextEditingController();

  @override
  void dispose() {
    _spaceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 720;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(34, 28, 34, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _BackSquareButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Spacer(flex: 5),
                      Text(
                        "What's the space called?",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontFamily: 'Baloo',
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.02,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Give your family care space a name.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SignInField(
                        controller: _spaceNameController,
                        hintText: "Papa's Space",
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _createCareSpace(),
                      ),
                      Spacer(flex: compact ? 6 : 10),
                      _PressableButton(
                        label: 'Continue',
                        backgroundColor: KupkopColors.primary,
                        foregroundColor: Colors.white,
                        shadowColor: KupkopColors.primaryShadow,
                        onPressed: _createCareSpace,
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: _signOut,
                        style: TextButton.styleFrom(
                          foregroundColor: KupkopColors.inkMuted,
                          textStyle: const TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        child: const Text('Temporary Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _createCareSpace() {
    final spaceName = _spaceNameController.text.trim();

    if (spaceName.isEmpty) {
      _showAuthMessage(context, 'Name your care space first.');
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CareSpaceCelebrationScreen(spaceName: spaceName),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }
}

class CareSpaceCelebrationScreen extends StatelessWidget {
  const CareSpaceCelebrationScreen({super.key, required this.spaceName});

  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34, 30, 34, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 7),
                  Image.asset(
                    'src/images/celebration.png',
                    height: 190,
                    fit: BoxFit.contain,
                    semanticLabel: 'Celebration',
                  ),
                  const SizedBox(height: 34),
                  Text(
                    "You just created $spaceName",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                      fontFamily: 'Baloo',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const Spacer(flex: 8),
                  _PressableButton(
                    label: 'Continue',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SafetySettingsScreen(spaceName: spaceName),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SafetySettingsScreen extends StatefulWidget {
  const SafetySettingsScreen({super.key, required this.spaceName});

  final String spaceName;

  @override
  State<SafetySettingsScreen> createState() => _SafetySettingsScreenState();
}

class _SafetySettingsScreenState extends State<SafetySettingsScreen> {
  final List<String> _packDurations = const [
    '7 Days',
    '15 Days',
    '21 Days',
    '30 Days',
    '45 Days',
    '60 Days',
  ];

  String _selectedDuration = '7 Days';
  String _dailyDoseCount = '1';
  final _otherDurationController = TextEditingController();

  @override
  void dispose() {
    _otherDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(34, 28, 34, 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _BackSquareButton(
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: _OnboardingProgress(value: 0.42),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight < 720 ? 28 : 44),
                      Text(
                        'Safety Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontFamily: 'Baloo',
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1.02,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'How many days is your pill pack?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        itemCount: _packDurations.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.12,
                            ),
                        itemBuilder: (context, index) {
                          final duration = _packDurations[index];

                          return _DurationChoiceTile(
                            label: duration,
                            selected: duration == _selectedDuration,
                            onTap: () {
                              setState(() => _selectedDuration = duration);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _SignInField(
                        controller: _otherDurationController,
                        hintText: 'Other',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          final trimmed = value.trim();
                          if (trimmed.isEmpty) return;
                          setState(() => _selectedDuration = '$trimmed Days');
                        },
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'How many times taken each day?',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _DailyDoseDropdown(
                        value: _dailyDoseCount,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _dailyDoseCount = value);
                        },
                      ),
                      const Spacer(),
                      _PressableButton(
                        label: 'Continue',
                        backgroundColor: KupkopColors.primary,
                        foregroundColor: Colors.white,
                        shadowColor: KupkopColors.primaryShadow,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MedicationScheduleScreen(
                                spaceName: widget.spaceName,
                                packDuration: _selectedDuration,
                                dailyDoseCount: _dailyDoseCount,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MedicationScheduleScreen extends StatefulWidget {
  const MedicationScheduleScreen({
    super.key,
    required this.spaceName,
    required this.packDuration,
    required this.dailyDoseCount,
  });

  final String spaceName;
  final String packDuration;
  final String dailyDoseCount;

  @override
  State<MedicationScheduleScreen> createState() =>
      _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  final List<String> _weekDays = const [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final Set<String> _selectedDays = {'Sunday'};
  String _firstDoseTime = '10:00 AM';
  String _secondDoseTime = '12:00 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(34, 28, 34, 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _BackSquareButton(
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: _OnboardingProgress(value: 0.62),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight < 720 ? 28 : 44),
                      Text(
                        'Medication Schedule',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontFamily: 'Baloo',
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1.02,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'When do you need medication?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        itemCount: _weekDays.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.12,
                            ),
                        itemBuilder: (context, index) {
                          final day = _weekDays[index];

                          return _DurationChoiceTile(
                            label: day,
                            selected: _selectedDays.contains(day),
                            onTap: () {
                              setState(() {
                                if (_selectedDays.contains(day)) {
                                  _selectedDays.remove(day);
                                } else {
                                  _selectedDays.add(day);
                                }
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Select Time of Dosage',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _TimeDropdown(
                        value: _firstDoseTime,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _firstDoseTime = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      _TimeDropdown(
                        value: _secondDoseTime,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _secondDoseTime = value);
                        },
                      ),
                      const Spacer(),
                      _PressableButton(
                        label: 'Continue',
                        backgroundColor: KupkopColors.primary,
                        foregroundColor: Colors.white,
                        shadowColor: KupkopColors.primaryShadow,
                        onPressed: () {
                          if (_selectedDays.isEmpty) {
                            _showAuthMessage(
                              context,
                              'Choose at least one medication day.',
                            );
                            return;
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReviewMedicineScreen(
                                spaceName: widget.spaceName,
                                medicineName: 'Metformin',
                                packDuration: widget.packDuration,
                                dailyDoseCount: widget.dailyDoseCount,
                                selectedDays: _weekDays
                                    .where(_selectedDays.contains)
                                    .toList(),
                                doseTimes: [_firstDoseTime, _secondDoseTime],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReviewMedicineScreen extends StatelessWidget {
  const ReviewMedicineScreen({
    super.key,
    required this.spaceName,
    required this.medicineName,
    required this.packDuration,
    required this.dailyDoseCount,
    required this.selectedDays,
    required this.doseTimes,
  });

  final String spaceName;
  final String medicineName;
  final String packDuration;
  final String dailyDoseCount;
  final List<String> selectedDays;
  final List<String> doseTimes;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34, 28, 34, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _BackSquareButton(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: _OnboardingProgress(value: 0.82)),
                    ],
                  ),
                  SizedBox(height: compact ? 28 : 42),
                  Text(
                    'Review Your Medicine',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontFamily: 'Baloo',
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          _ReviewSummaryField(
                            label: 'Name of the medicine',
                            value: medicineName,
                            onEdit: () => Navigator.of(context).pop(),
                          ),
                          _ReviewSummaryField(
                            label: 'How long will it last?',
                            value: packDuration,
                            onEdit: () => Navigator.of(context).pop(),
                          ),
                          _ReviewSummaryField(
                            label: 'How many times taken each day?',
                            value: dailyDoseCount,
                            onEdit: () => Navigator.of(context).pop(),
                          ),
                          _ReviewSummaryField(
                            label: 'Days taken medicine',
                            value: _formatSelectedDays(selectedDays),
                            onEdit: () => Navigator.of(context).pop(),
                          ),
                          _ReviewSummaryField(
                            label: 'Select time of dosage',
                            value: doseTimes.join(' - '),
                            onEdit: () => Navigator.of(context).pop(),
                            bottomSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PressableButton(
                    label: 'Continue',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              CareDashboardScreen(spaceName: spaceName),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatSelectedDays(List<String> days) {
    if (days.isEmpty) return 'No days selected';
    final abbreviations = days.map((day) => day.substring(0, 3)).toList();
    return abbreviations.join(', ');
  }
}

class _ReviewSummaryField extends StatelessWidget {
  const _ReviewSummaryField({
    required this.label,
    required this.value,
    required this.onEdit,
    this.bottomSpacing = 18,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(minHeight: 54),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: KupkopColors.fieldFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: KupkopColors.borderStrong),
                  boxShadow: const [
                    BoxShadow(
                      color: KupkopColors.inputShadow,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.edit_outlined,
                      color: KupkopColors.inkMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        backgroundColor: KupkopColors.surfaceLight,
        valueColor: const AlwaysStoppedAnimation<Color>(KupkopColors.primary),
      ),
    );
  }
}

class _DurationChoiceTile extends StatelessWidget {
  const _DurationChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? KupkopColors.primary : KupkopColors.border,
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? KupkopColors.primary.withValues(alpha: 0.16)
                    : KupkopColors.socialShadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? KupkopColors.primary
                      : KupkopColors.borderStrong,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyDoseDropdown extends StatelessWidget {
  const _DailyDoseDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: KupkopColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KupkopColors.borderStrong),
        boxShadow: const [
          BoxShadow(color: KupkopColors.inputShadow, offset: Offset(0, 3)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          items: const [
            DropdownMenuItem(value: '1', child: Text('1')),
            DropdownMenuItem(value: '2', child: Text('2')),
            DropdownMenuItem(value: '3', child: Text('3')),
            DropdownMenuItem(value: '4', child: Text('4')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  static const List<String> _times = [
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: KupkopColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KupkopColors.borderStrong),
        boxShadow: const [
          BoxShadow(color: KupkopColors.inputShadow, offset: Offset(0, 3)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          items: _times
              .map((time) => DropdownMenuItem(value: time, child: Text(time)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _BackSquareButton extends StatelessWidget {
  const _BackSquareButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        tooltip: 'Back',
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: KupkopColors.border),
          ),
          elevation: 2,
          shadowColor: KupkopColors.borderStrong,
        ),
        icon: const Icon(Icons.chevron_left_rounded, size: 28),
      ),
    );
  }
}

class CareDashboardScreen extends StatelessWidget {
  const CareDashboardScreen({super.key, required this.spaceName});

  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const _DashboardBottomNav(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DashboardHeader(spaceName: spaceName),
                  const SizedBox(height: 18),
                  const _AttentionCard(),
                  const SizedBox(height: 20),
                  _DashboardPanel(
                    title: 'Medicines',
                    icon: Icons.medication_rounded,
                    actionLabel: 'View All',
                    onActionPressed: () {},
                    child: const Column(
                      children: [
                        _MedicineOverviewRow(
                          name: 'Losartan',
                          daysLeft: '12 days left',
                        ),
                        _MedicineOverviewRow(
                          name: 'Metformin',
                          daysLeft: '2 days left',
                          needsAttention: true,
                        ),
                        _MedicineOverviewRow(
                          name: 'Aspirin',
                          daysLeft: '20 days left',
                          bottomSpacing: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DashboardPanel(
                    title: 'Tasks',
                    icon: Icons.task_alt_rounded,
                    actionLabel: 'View All',
                    onActionPressed: () {},
                    child: const Column(
                      children: [
                        _TaskOverviewRow(
                          task: 'Buy Metformin',
                          assignee: 'Kuya',
                        ),
                        _TaskOverviewRow(
                          task: 'Check Pharmacy',
                          assignee: 'Mom',
                          bottomSpacing: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DashboardPanel(
                    title: 'Recent Updates',
                    icon: Icons.chat_bubble_rounded,
                    actionLabel: 'Open Chat',
                    onActionPressed: () {},
                    child: const Column(
                      children: [
                        _ChatPreviewRow(
                          sender: 'Mom',
                          message: 'Paubos na Metformin.',
                        ),
                        _ChatPreviewRow(
                          sender: 'Kuya',
                          message: 'Ako bibili mamaya.',
                          bottomSpacing: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _FamilyPanel(),
                  const SizedBox(height: 24),
                  _PressableButton(
                    label: 'Add Medicine',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  _PressableButton(
                    label: 'Temporary Logout',
                    backgroundColor: Colors.white,
                    foregroundColor: KupkopColors.primary,
                    borderColor: KupkopColors.borderStrong,
                    shadowColor: KupkopColors.borderStrong,
                    shadowOffset: 1,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.spaceName});

  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KupkopColors.border),
        boxShadow: const [
          BoxShadow(color: KupkopColors.socialShadow, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: KupkopColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KupkopColors.border),
            ),
            child: const Icon(
              Icons.elderly_rounded,
              color: Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spaceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontFamily: 'Baloo',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: KupkopColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Everything okay',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: KupkopColors.inkMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.notifications_none_rounded,
            color: KupkopColors.inkMuted,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD76A), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFFFFE8A8), offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: KupkopColors.yellow,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Attention Needed',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Baloo',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Metformin',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '2 days remaining',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: KupkopColors.inkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE2A6)),
            ),
            child: const Text(
              'Task: Buy Metformin',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _PressableButton(
            label: 'View Medicine',
            backgroundColor: KupkopColors.primary,
            foregroundColor: Colors.white,
            shadowColor: KupkopColors.primaryShadow,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({
    required this.title,
    required this.icon,
    required this.child,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KupkopColors.border),
        boxShadow: const [
          BoxShadow(color: KupkopColors.socialShadow, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: KupkopColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontFamily: 'Baloo',
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: KupkopColors.primary,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  child: Text(actionLabel!),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _MedicineOverviewRow extends StatelessWidget {
  const _MedicineOverviewRow({
    required this.name,
    required this.daysLeft,
    this.needsAttention = false,
    this.bottomSpacing = 12,
  });

  final String name;
  final String daysLeft;
  final bool needsAttention;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          Text(
            daysLeft,
            style: TextStyle(
              color: needsAttention ? KupkopColors.red : KupkopColors.inkMuted,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          if (needsAttention) ...[
            const SizedBox(width: 6),
            const Icon(
              Icons.warning_amber_rounded,
              color: KupkopColors.red,
              size: 17,
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskOverviewRow extends StatelessWidget {
  const _TaskOverviewRow({
    required this.task,
    required this.assignee,
    this.bottomSpacing = 12,
  });

  final String task;
  final String assignee;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked_rounded,
            color: KupkopColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Assigned: $assignee',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KupkopColors.inkMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatPreviewRow extends StatelessWidget {
  const _ChatPreviewRow({
    required this.sender,
    required this.message,
    this.bottomSpacing = 12,
  });

  final String sender;
  final String message;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: KupkopColors.surfaceLight,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: KupkopColors.border),
            ),
            child: Text(
              sender.characters.first,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: 0,
                ),
                children: [
                  TextSpan(
                    text: '$sender: ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: '"$message"'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyPanel extends StatelessWidget {
  const _FamilyPanel();

  @override
  Widget build(BuildContext context) {
    return _DashboardPanel(
      title: 'Family',
      icon: Icons.groups_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _FamilyChip(name: 'Mom'),
              _FamilyChip(name: 'Kuya'),
              _FamilyChip(name: 'Ate'),
              _FamilyChip(name: 'Bunso'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '4 members',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: KupkopColors.inkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyChip extends StatelessWidget {
  const _FamilyChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: KupkopColors.surfaceLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: KupkopColors.border),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _DashboardBottomNav extends StatelessWidget {
  const _DashboardBottomNav();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            height: 76,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: KupkopColors.border)),
            ),
            child: const Row(
              children: [
                _DashboardNavItem(
                  label: 'Home',
                  icon: Icons.home_rounded,
                  selected: true,
                ),
                _DashboardNavItem(
                  label: 'Medicines',
                  icon: Icons.medication_rounded,
                ),
                _DashboardNavItem(
                  label: 'Chat',
                  icon: Icons.chat_bubble_rounded,
                ),
                _DashboardNavItem(label: 'Tasks', icon: Icons.task_alt_rounded),
                _DashboardNavItem(label: 'Family', icon: Icons.groups_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardNavItem extends StatelessWidget {
  const _DashboardNavItem({
    required this.label,
    required this.icon,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? KupkopColors.primary : KupkopColors.inkMuted;

    return Expanded(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 23),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredScrollPage extends StatelessWidget {
  const _CenteredScrollPage({
    required this.child,
    required this.minHeight,
    this.maxWidth = 430,
    this.horizontalPadding = 34,
  });

  final Widget child;
  final double minHeight;
  final double maxWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}

class _SignInField extends StatelessWidget {
  const _SignInField({
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      cursorColor: KupkopColors.primary,
      style: const TextStyle(
        color: KupkopColors.ink,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: KupkopColors.inkMuted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: KupkopColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KupkopColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KupkopColors.primary, width: 2),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.icon});

  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KupkopColors.border),
        boxShadow: const [
          BoxShadow(color: KupkopColors.socialShadow, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Baloo',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialAuthButtons extends StatelessWidget {
  const _SocialAuthButtons();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SocialButton(label: 'Sign in With Google', icon: _GoogleMark()),
      ],
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        color: KupkopColors.googleBlue,
        fontSize: 23,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'By signing in to KupKop, you agree to our Terms\nand Privacy Policy',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: KupkopColors.inkMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
    );
  }
}

bool _validateEmailAndPassword(
  BuildContext context,
  String email,
  String password,
) {
  if (email.isEmpty || !email.contains('@')) {
    _showAuthMessage(context, 'Enter a valid email address.');
    return false;
  }

  if (password.length < 6) {
    _showAuthMessage(context, 'Password must be at least 6 characters.');
    return false;
  }

  return true;
}

bool _ensureFirebaseReady(BuildContext context, AuthConfig authConfig) {
  if (authConfig.firebaseReady) {
    return true;
  }

  _showAuthMessage(
    context,
    'Firebase is not configured yet. Run firebase login and flutterfire configure.',
  );
  return false;
}

void _showAuthMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _firebaseAuthMessage(FirebaseAuthException error) {
  return switch (error.code) {
    'email-already-in-use' => 'That email already has an account.',
    'invalid-email' => 'Enter a valid email address.',
    'operation-not-allowed' => 'Email/password sign-in is not enabled yet.',
    'user-disabled' => 'This account has been disabled.',
    'user-not-found' => 'No account found for that email.',
    'wrong-password' || 'invalid-credential' => 'Incorrect email or password.',
    'weak-password' => 'Use a stronger password.',
    'network-request-failed' => 'Network error. Check your connection.',
    _ => error.message ?? 'Authentication failed. Please try again.',
  };
}

abstract final class KupkopColors {
  static const primary = Color(0xFF58CC02);
  static const primaryShadow = Color(0xFF58A700);
  static const blue = Color(0xFF1CB0F6);
  static const yellow = Color(0xFFFFC800);
  static const red = Color(0xFFFF4B4B);
  static const ink = Color(0xFF3C3C3C);
  static const inkMuted = Color(0xFF777777);
  static const canvas = Color(0xFFFFFFFF);
  static const fieldFill = Color(0xFFFAFAFA);
  static const surfaceLight = Color(0xFFF7F7F7);
  static const border = Color(0xFFE5E5E5);
  static const borderStrong = Color(0xFFCFCFCF);
  static const inputShadow = Color(0xFFE0E0E0);
  static const socialShadow = Color(0xFFE9E9E9);
  static const googleBlue = Color(0xFF4285F4);
  static const facebookBlue = Color(0xFF1877F2);
}
