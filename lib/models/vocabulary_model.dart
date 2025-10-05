
class VocabularyModel {
  final int id;
  final String word;
  final String meaning;
  final String description;


  VocabularyModel({required this.id, required this.word, required this.meaning, required this.description});

  static List<VocabularyModel> vocabList = [
    VocabularyModel(id: 1,word: 'apple', meaning: 'quả táo', description: ''),
    VocabularyModel(id: 2,word: 'banana', meaning: 'quả chuối', description: ''),
    // Thêm từ vựng khác
  ];

  factory VocabularyModel.fromJson(Map<String, dynamic> json){
    return VocabularyModel(
        id: json['vocabId'],
        word: json['word'],
        meaning: json['meaning'],
        description: json['description']
    );
  }
}
