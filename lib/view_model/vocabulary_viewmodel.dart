import 'dart:convert';

import 'package:english_learning_app/constrants/app_constrants.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VocabularyViewmodel extends ChangeNotifier{

  List<VocabularyModel> _vocabs = [];
  bool _isLoading = false;

  List<VocabularyModel> get vocabs => _vocabs;

  bool get isLoading => _isLoading;

  Future<void> fetchVocabs(int lessonID) async{
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse("${apiUrl}/vocabularies/lesson/$lessonID"),
        headers: <String, String>{
        'Content-Type': 'application/json',

      },
      );
      if(response.statusCode == 200){
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        _vocabs = jsonData.map((json) => VocabularyModel.fromJson(json)).toList();

      }else {
        print('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi');
      }
      
    }catch(e){
      print('Lỗi khi lấy khóa học: $e');
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}