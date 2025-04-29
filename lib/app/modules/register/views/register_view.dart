import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_cane_app/app/widgets/PrimaryButton.dart';
import 'package:smart_cane_app/app/widgets/TitleText.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Form Key

    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<RegisterController>(
          builder: (controller){
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: ListView(

                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(height: 20),
                        TitleText(title: "Sign Up"),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.firstName,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: controller.lastName,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: controller.phoneNumber,
                            decoration: InputDecoration(
                              labelText: "Phone number",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: controller.address,
                            decoration: InputDecoration(
                              labelText: "Address",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: controller.dateOfBirth,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Date of Birth",
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              controller.dateOfBirth.text = pickedDate!.toLocal().toString().split(' ')[0];
                                                        },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
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
                          DropdownButtonFormField<String>(
                            value: controller.accountType,
                            decoration: InputDecoration(
                              labelText: "Account Type",
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "User",
                                child: Text("User"),
                              ),
                              DropdownMenuItem(
                                value: "Caregiver",
                                child: Text("Caregiver"),
                              ),
                            ],
                            onChanged: (value) {
                              controller.accountType = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an account type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          controller.loading?CircularProgressIndicator():
                          PrimaryButton(buttonText: "Sign Up", onPressed: controller.handleRegister)

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
