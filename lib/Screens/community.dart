import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  Community({required this.username,super.key});
  String username;
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}