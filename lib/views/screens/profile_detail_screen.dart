import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/constrants/app_colors.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String? fullName;
  String? email;
  String? phone;
  String? avatar;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString("full_name_user") ?? "Chưa có tên";
      email = prefs.getString("email_user") ?? "Chưa có email";
      phone = prefs.getString("phone_user") ?? "Chưa có số điện thoại";
      avatar = prefs.getString("avatar_user");
      isLoading = false;
    });
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryDark, size: 28),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  backgroundImage:
                  (avatar != null && avatar!.isNotEmpty) ? NetworkImage(avatar!) : null,
                  child: (avatar == null || avatar!.isEmpty)
                      ? Icon(Icons.person, size: 60, color: AppColors.primaryDark)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  fullName ?? "",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

            // Info fields
            _buildInfoTile(Icons.email, "Email", email ?? ""),
            _buildInfoTile(Icons.phone, "Số điện thoại", phone ?? ""),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade400),

            const SizedBox(height: 15),
            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate edit profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Thay đổi thông tin",
                  style: TextStyle(color: AppColors.Orange, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Navigate change password
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(color: AppColors.primaryDark, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Thay đổi mật khẩu",
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
