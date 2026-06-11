import 'package:flutter/material.dart';

void main() {
  runApp(const KupkopApp());
}

class KupkopApp extends StatelessWidget {
  const KupkopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const WelcomeScreen(),
    );
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
          onPressed: () {},
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
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;

            return _CenteredScrollPage(
              maxWidth: 430,
              horizontalPadding: 38,
              minHeight: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: compact ? 154 : 204,
                    child: Image.asset(
                      'src/images/Sign in page Image.png',
                      fit: BoxFit.contain,
                      semanticLabel: 'Family care sign in image',
                    ),
                  ),
                  SizedBox(height: compact ? 28 : 40),
                  const _InputLabel('Email'),
                  const SizedBox(height: 8),
                  const _SignInField(
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const _InputLabel('Password'),
                  const SizedBox(height: 8),
                  _SignInField(
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
                    label: 'Sign In',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 18),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _CenteredScrollPage(
              maxWidth: 430,
              horizontalPadding: 38,
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
                  const _SignInField(
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),
                  _PressableButton(
                    label: 'Send Reset Link',
                    backgroundColor: KupkopColors.primary,
                    foregroundColor: Colors.white,
                    shadowColor: KupkopColors.primaryShadow,
                    onPressed: () {},
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
}

class _CenteredScrollPage extends StatelessWidget {
  const _CenteredScrollPage({
    required this.child,
    required this.minHeight,
    this.maxWidth = 430,
    this.horizontalPadding = 38,
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
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
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
  static const border = Color(0xFFE5E5E5);
  static const borderStrong = Color(0xFFCFCFCF);
}
