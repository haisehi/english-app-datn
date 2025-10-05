import 'package:english_learning_app/constrants/app_colors.dart';
import 'package:english_learning_app/models/vocabulary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Thêm thư viện lottie
import 'package:english_learning_app/view_model/practice_4_viewmodel.dart';

class Practice4Screen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final List<VocabularyModel> _vocabList;
  final int courseID;
  final int lessonID;
  final double old_process;


  Practice4Screen(
      this._vocabList, this.courseID, this.lessonID, this.old_process);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Practice4ViewModel(_vocabList, courseID, lessonID, old_process),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bài luyện tập số 4', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),),
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(color: AppColors.textSecondary),

        ),
        backgroundColor: AppColors.background,
        body: Consumer<Practice4ViewModel>(
          builder: (context, viewModel, child) {
            double progress = (viewModel.currentIndex + 1) / viewModel.totalQuestions;
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.pink,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Câu ${viewModel.currentIndex + 1}/${viewModel.totalQuestions}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // Thêm biểu tượng động Lottie
                      Lottie.asset(
                        'assets/animations/logo_animation.json', // Đảm bảo bạn đã thêm file JSON của Lottie trong thư mục assets
                        height: 200,
                        width: 200,
                        repeat: true, // Lặp lại animation
                        reverse: true,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nghĩa của từ:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        
                        decoration: BoxDecoration(
                          color: AppColors.Orange,
                          borderRadius: BorderRadius.circular(12)
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          child: Text(
                            viewModel.currentWord.meaning,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Trả lời: ", style: TextStyle(color: Color(0xFF342771),fontSize: 18, fontWeight: FontWeight.bold), ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12), // Bo góc cho viền
                                borderSide: BorderSide(
                                  color: Colors.blueAccent, // Màu viền mặc định
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.checkAnswer(_controller.text, context);
                            _controller.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Bo góc cho nút
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Trả lời', style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        viewModel.feedbackText,
                        style: TextStyle(
                          fontSize: 18,
                          color: viewModel.feedbackText == "Chính xác!"
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold
                        ),

                      ),
                      SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
