import 'package:english_learning_app/views/screens/student/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/view_model/login_viewmodel.dart';
import '../../localization/app_localizations.dart';
import 'profile_detail_screen.dart';
import '../../models/leaderboard_model.dart';
import '../../services/leaderboard_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences? prefs;
  String? fullName = "";
  String? email = "";
  String? phone = "";
  String? avatar;

  List<LeaderboardModel> leaderboard = [];
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _fetchLeaderboard();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs?.getString('full_name_user') ?? "";
      email = prefs?.getString('email_user') ?? "";
      phone = prefs?.getString('phone_user') ?? "";
      avatar = prefs?.getString('avatar_user');
    });
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final service = LeaderboardService();
      final data = await service.fetchLeaderboard();
      setState(() {
        leaderboard = data;
        isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      debugPrint("❌ Error loading leaderboard: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = LoginViewModel();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 🟣 Header
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatar != null && avatar!.isNotEmpty
                      ? NetworkImage(avatar!)
                      : const AssetImage("assets/images/user.jpg")
                  as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  fullName ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                if (phone != null && phone!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      phone!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 🟢 Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchLeaderboard,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "🏆 ${loc.tr('leaderboard')}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          AppColors.primary.withOpacity(0.08)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 330,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : leaderboard.isEmpty
                          ? Center(
                        child: Text(
                          loc.tr("no_data"),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 16),
                        ),
                      )
                          : AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: ListView.builder(
                                physics:
                                const BouncingScrollPhysics(),
                                itemCount: leaderboard.length,
                                itemBuilder: (context, index) =>
                                    _buildLeaderboardCard(
                                        leaderboard[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  Text(
                    "⚙️ ${loc.tr('settings_and_options')}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildMenuItem(Icons.person, loc.tr("profile_detail"), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileDetailScreen(),
                      ),
                    );
                  }),

                  // ✔ Sửa nút cài đặt đúng UI
                  _buildMenuItem(Icons.settings, loc.tr("setting"), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingScreen(),
                      ),
                    );
                  }),

                  // Giữ nguyên design "Giới thiệu"
                  _buildMenuItem(Icons.info_outline, loc.tr("about"), () {}),

                  _buildMenuItem(Icons.logout, loc.tr("logout"), () {
                    viewModel.logout(context);
                  }, color: Colors.redAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(LeaderboardModel item) {
    bool isValidUrl = item.avatar.startsWith('http://') ||
        item.avatar.startsWith('https://');

    Color rankColor;
    switch (item.rank) {
      case 1:
        rankColor = const Color(0xFFFFD700);
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0);
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32);
        break;
      default:
        rankColor = Colors.grey.shade300;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Card(
        elevation: item.rank <= 3 ? 6 : 2,
        shadowColor:
        item.rank <= 3 ? rankColor.withOpacity(0.5) : Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: isValidUrl
                    ? NetworkImage(item.avatar)
                    : const AssetImage("assets/images/user.jpg")
                as ImageProvider,
              ),
              if (item.rank <= 3)
                Container(
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: rankColor.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "${item.rank}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            item.fullName,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            "${AppLocalizations.of(context).tr("score")}: ${item.totalScore.toStringAsFixed(1)}",
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Text(
            "#${item.rank}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rankColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color ?? AppColors.primary),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.chevron_right,
              color: Colors.grey[500], size: 20),
          onTap: onTap,
        ),
      ),
    );
  }
}
