import 'package:english_learning_app/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_learning_app/localization/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr("setting"))),
      body: Column(
        children: [
          ListTile(
            title: Text(loc.tr("choose_language")),
            subtitle: Text(provider.locale.languageCode == "vi"
                ? "Tiếng Việt"
                : "English"),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text("Tiếng Việt"),
                      onTap: () => provider.setLocale(const Locale('vi')),
                    ),
                    ListTile(
                      title: const Text("English"),
                      onTap: () => provider.setLocale(const Locale('en')),
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
