import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_cane_app/app/widgets/PrimaryButton.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body:Container(
          padding: EdgeInsets.all(20),
          child:  ListView(
            children: [
              Image(
                image: const AssetImage('assets/images/avatar.png'),
                width: 100,
                height: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("User Information", style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 20),

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

                      if (pickedDate != null) {
                        controller.dateOfBirth.text = pickedDate.toLocal().toString().split(' ')[0];
                      }
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

                  PrimaryButton(
                    onPressed: controller.handleUpdateProfile,
                    buttonText:'Update Profile',
                  ),

                ],
              ),
              SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Device Information", style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Device Name"),
                        Text("Cane connection status"),
                        Text("Cane battery life"),
                        Text("Latest update"),
                        TextButton(onPressed: (){}, child: Text("Connect Device", style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline
                        ),))
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  PrimaryButton(
                    onPressed: controller.handleLogout,
                    buttonText:'Logout',
                  ),

                ],
              ),
            ],
          ),
        )
      );
    });
  }
}
