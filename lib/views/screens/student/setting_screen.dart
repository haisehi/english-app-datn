import 'package:english_learning_app/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_learning_app/localization/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    final provider = Provider.of<LocaleProvider>(context);

    // Hàm lấy tên ngôn ngữ theo locale
    String getLanguageName(String code) {
      switch (code) {
        case "vi":
          return "Tiếng Việt";
        case "en":
          return "English";
        case "ja":
          return "日本語";
        case "ko":
          return "한국어";
        default:
          return "English";
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr("setting"))),
      body: Column(
        children: [
          ListTile(
            title: Text(loc.tr("choose_language")),
            subtitle: Text(getLanguageName(provider.locale.languageCode)),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(getLanguageName("vi")),
                      onTap: () => provider.setLocale(const Locale('vi')),
                    ),
                    ListTile(
                      title: Text(getLanguageName("en")),
                      onTap: () => provider.setLocale(const Locale('en')),
                    ),
                    ListTile(
                      title: Text(getLanguageName("ja")),
                      onTap: () => provider.setLocale(const Locale('ja')),
                    ),
                    ListTile(
                      title: Text(getLanguageName("ko")),
                      onTap: () => provider.setLocale(const Locale('ko')),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}