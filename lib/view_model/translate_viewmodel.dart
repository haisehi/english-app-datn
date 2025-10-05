
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslateViewModel extends ChangeNotifier {
    final translator = GoogleTranslator();
    String _inputText = '';
    String _outputText = '';
    String _inputLanguage = 'en';
    String _outputLanguage  = 'vi';




  void updateInputText(String text){
        _inputText = text;
        notifyListeners();
    }
    void updateInputLanguage(String lang){
        _inputLanguage = lang;
        notifyListeners();
    }
    void updateOutputLanguage(String lang){
        _outputLanguage = lang;
        notifyListeners();

    }
    Future<void> translate() async {
        final translate = await translator.translate(_inputText, from: _inputLanguage, to: _outputLanguage);
        _outputText = translate.text;
        notifyListeners();
    }
    String get inputText => _inputText;

    String get outputText => _outputText;

    String get inputLanguage => _inputLanguage;

    String get outputLanguage => _outputLanguage;
}