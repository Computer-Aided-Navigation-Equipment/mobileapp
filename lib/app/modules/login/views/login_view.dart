import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/widgets/PrimaryButton.dart';
import 'package:smart_cane_app/app/widgets/TitleText.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Form Key

    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<LoginController>(
          builder: (controller){
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(

              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Center(child: TitleText(title: "Sign In")),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: controller.password,
                        obscureText: controller.obscureText,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        onPressed: controller.handleLogin,
                        buttonText:'Sign In',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

          }),
    );
  }
}
