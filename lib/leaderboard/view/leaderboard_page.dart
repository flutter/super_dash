import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: LeaderboardPage(),
    );
  }

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LeaderboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
