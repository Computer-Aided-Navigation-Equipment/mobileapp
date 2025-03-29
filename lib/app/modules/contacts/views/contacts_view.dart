import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/contacts_controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ContactsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ContactsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
