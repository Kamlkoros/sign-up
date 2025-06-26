import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with TickerProviderStateMixin {
  int tabIndex = 0;
  late final AnimationController animationController;
  final List<Widget> screens = [const LoginPage(), const SignUpPage()];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
    
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                tabIndex == 0 ? 'Sign In' : 'Sign Up',
                key: ValueKey(tabIndex),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Container(
              key: ValueKey(tabIndex),
              child: screens[tabIndex],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabIndex,
            onTap: (index) {
              if (index != tabIndex) {
                setState(() {
                  tabIndex = index;
                });
              }
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Sign Up',
              ),
            ],
          ),
        );
      },
    );
  }
}
