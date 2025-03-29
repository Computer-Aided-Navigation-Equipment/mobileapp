import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_home_controller.dart';

class UserHomeView extends GetView<UserHomeController> {
  const UserHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserHomeController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Hey There!'),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.toNamed('/profile');
                },
                child: Image(
                  image: const AssetImage('assets/images/avatar.png'),
                  width: 50,
                  height: 50,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  controller.logout();
                },
              )
            ],
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("My Location"),
                    TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      controller: controller.location,
                      decoration: InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: NavigationItem(
                          title: "Navigation",
                          path: "/navigation",
                          imagePath: "assets/images/navigation.png"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: NavigationItem(
                          title: "Begin Path",
                          path: "/begin-path",
                          imagePath: "assets/images/path.png"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: NavigationItem(
                          title: "Saved Contacts",
                          path: "/contacts",
                          imagePath: "assets/images/contacts.png"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: NavigationItem(
                          title: "Saved Locations",
                          path: "/locations",
                          imagePath: "assets/images/locations.png"),
                    ),
                  ],
                ),
              ],
            ),
          ));
    });
  }
}

class NavigationItem extends StatelessWidget {
  final String title;
  final String path;
  final String imagePath;
  const NavigationItem(
      {super.key,
      required this.title,
      required this.path,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffEDFFFE),
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(path);
            },
            child: Image(
              image: AssetImage(imagePath),
              width: 100,
              height: 100,
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.w100),
          )
        ],
      ),
    );
  }
}
