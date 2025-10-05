
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:flutter/material.dart';

class MyVocabularyScreen extends StatefulWidget {
  const MyVocabularyScreen({super.key});

  @override
  State<MyVocabularyScreen> createState() => _MyVocabularyScreenState();
}

class _MyVocabularyScreenState extends State<MyVocabularyScreen> {
  final List<Map<String, dynamic>> vocabularyList = [
    {
      'word': 'learn',
      'meaning': 'học',
      'percentage': 80,
    },
    {
      'word': 'speak',
      'meaning': 'nói',
      'percentage': 60,
    },
    {
      'word': 'read',
      'meaning': 'đọc',
      'percentage': 90,
    },
    // Thêm dữ liệu mẫu khác ở đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tất cả từ vựng đã lưu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: vocabularyList.length,
                itemBuilder: (context, index) {
                  final vocab = vocabularyList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Từ và nghĩa
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vocab['word'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  // Xử lý xóa từ vựng
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Nghĩa: ${vocab['meaning']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),

                          // Phần trăm học thuộc
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: vocab['percentage'] / 100,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text('${vocab['percentage']}%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển đến trang luyện tập
        },
        child: Icon(Icons.fitness_center),
        backgroundColor: Colors.green,
        tooltip: 'Luyện tập',
      ),
    );
  }
}


