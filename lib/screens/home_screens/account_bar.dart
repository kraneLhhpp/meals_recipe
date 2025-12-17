import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_api/screens/home_screens/widgets/change_password_screen.dart';
import 'package:nutrition_api/screens/home_screens/widgets/edit_profile_screen.dart';

class AccountBar extends StatelessWidget {
  const AccountBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data;

                return _UserCard(
                  name: user?.displayName ?? 'User Name',
                );
              },
            ),


            const SizedBox(height: 24),

            const Text('Account', style: _sectionStyle),
            const SizedBox(height: 20),

            _AccountTile(
              icon: Icons.person_outline,
              title: 'Edit profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _AccountTile(
              icon: Icons.lock_outline,
              title: 'Change password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _AccountTile(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if(!context.mounted) return;
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}

const _sectionStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);


class _UserCard extends StatelessWidget {
  final String name;

  const _UserCard({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _boxDecoration,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF70B9BE)),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

final _boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(color: Colors.black),
  ],
);
