import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AccountTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF70B9BE)),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
