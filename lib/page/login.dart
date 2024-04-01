import 'package:flutter/material.dart';
import 'package:partrelate_desktop/http/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> signIn() async {
      try {
        setState(() {
          loading = true;
        });

        final response = await dio.post('/login', data: {
          'username': usernameController.text,
          'password': passwordController.text
        });

        final String token = response.data;

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', token);
        authorizeDio(token);
        usernameController.text = '';
        passwordController.text = '';
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          loading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Center(
          child: SizedBox(
              width: 300,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Login'),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Username'),
                      controller: usernameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Password'),
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: signIn, child: const Text('Sign In')),
                    if (loading) ...[
                      const SizedBox(
                        height: 15,
                      ),
                      const CircularProgressIndicator()
                    ]
                  ],
                ),
              )))),
    );
  }
}
