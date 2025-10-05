import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/login_viewmodel.dart';
import 'profile_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  SharedPreferences? prefs;
  String? fullName = "Nguyen Van Vi";
  String? email = "nguyenvanvi@gmail.com";
  String? phone = "0123 456 789";
  String? avatar;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs?.getString('full_name_user') ?? fullName;
      email = prefs?.getString('email_user') ?? email;
      phone = prefs?.getString('phone_user') ?? phone;
      avatar = prefs?.getString('avatar_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = LoginViewModel();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // header
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          // content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // avatar
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: avatar != null && avatar!.isNotEmpty
                          ? NetworkImage(avatar!)
                          : const AssetImage("assets/images/user.jpg")
                      as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  fullName ?? "",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),

                // card info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(phone ?? "",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ),

                // menu options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.person, "Thông tin cá nhân", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileDetailScreen()),
                        );
                      }),
                      _buildMenuItem(Icons.settings, "Cài đặt", () {}),
                      _buildMenuItem(Icons.info_outline, "Giới thiệu", () {}),
                      _buildMenuItem(Icons.logout, "Đăng xuất", () {
                        viewModel.logout(context);
                      }, color: Colors.red),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }
}
