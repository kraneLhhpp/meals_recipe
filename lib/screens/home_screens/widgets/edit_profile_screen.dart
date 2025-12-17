  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';

  class EditProfileScreen extends StatefulWidget {
    const EditProfileScreen({super.key});

    @override
    State<EditProfileScreen> createState() => _EditProfileScreenState();
  }

  class _EditProfileScreenState extends State<EditProfileScreen> {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    bool isLoading = true;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    @override
    void initState() {
      super.initState();
      if (userId != null) {
        loadUserData();
      } else {
        setState(() => isLoading = false);
      }
    }

    // Загрузка данных пользователя из Firestore
    Future<void> loadUserData() async {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (doc.exists) {
          _firstNameController.text = doc['firstName'] ?? '';
          _lastNameController.text = doc['lastName'] ?? '';
        }
      } catch (e) {
        debugPrint('Error loading user data: $e');
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
      setState(() => isLoading = false);
    }

    Future<void> saveProfile() async {
      if (userId == null) return;

      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      if (firstName.isEmpty || lastName.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in both fields')),
        );
        return;
      }

      try {
        // 1️⃣ Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
        }, SetOptions(merge: true));

        // 2️⃣ FirebaseAuth
        final user = FirebaseAuth.instance.currentUser;
        await user?.updateDisplayName('$firstName $lastName');
        await user?.reload();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;

        debugPrint('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile')),
        );
      }
    }

    @override
    void dispose() {
      _firstNameController.dispose();
      _lastNameController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: saveProfile,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
      );
    }
  }