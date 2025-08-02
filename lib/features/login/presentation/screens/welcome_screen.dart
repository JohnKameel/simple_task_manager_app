import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_task_manager/core/db/shared_pref_helper.dart';
import 'package:simple_task_manager/core/routing/app_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    checkIsLogged();
  }

  bool isLogged = false;

  checkIsLogged() async {
    bool isLogin = SharedPrefHelper.getIsLogin() ?? false;

    if (isLogin) {
      isLogged = true;
    } else {
      isLogged = false;
      SharedPrefHelper.clear();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image in top
          Image.asset(
            width: double.infinity,
            'assets/login_background.png',
            fit: BoxFit.cover,
          ),
          // Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Simple Task Manager App',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'small app for help user to add tasks and remember it easy',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (isLogged) {
                          context.pushReplacement(RouterApp.home);
                        } else {
                          context.pushReplacement(RouterApp.login);
                        }
                      },
                      child: Text(
                        'Get Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
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
