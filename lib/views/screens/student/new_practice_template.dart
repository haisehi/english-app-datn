import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../constrants/app_colors.dart';
import '../../../models/vocabulary_model.dart';
import '../../../view_model/practice_1_viewmodel.dart';
import '../../../view_model/practice_2_viewmodel.dart';
import '../../../view_model/practice_3_viewmodel.dart';
import '../../../view_model/practice_4_viewmodel.dart';

// ENUM các loại câu hỏi
enum QuestionType {
  dragDrop,
  multipleChoice,
  buildWord,
  textInput
}

class PracticeNewTemplateScreen<T extends ChangeNotifier> extends StatelessWidget {
  final T Function() viewModelBuilder;
  final int totalQuestions;
  final Widget Function(BuildContext context, T vm) getCurrentQuestion;
  final VocabularyModel Function(T vm) getVocabulary;
  final int Function(T vm) getCurrentIndex;
  final double Function(T vm) getProgress;

  const PracticeNewTemplateScreen({
    super.key,
    required this.viewModelBuilder,
    required this.totalQuestions,
    required this.getCurrentQuestion,
    required this.getVocabulary,
    required this.getCurrentIndex,
    required this.getProgress,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModelBuilder(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text("Bài luyện tập", style: TextStyle(color: AppColors.divider)),
          backgroundColor: AppColors.primaryDark,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.divider),
        ),
        body: Consumer<T>(
          builder: (context, vm, _) {
            final vocab = getVocabulary(vm);
            final progress = getProgress(vm);
            final questionType = _randomQuestion();
            final idx = getCurrentIndex(vm);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    // Progress bar
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: AppColors.Pink,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "Câu ${idx + 1} / $totalQuestions",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Lottie.asset(
                      'assets/animations/logo_animation.json',
                      height: 180,
                      repeat: true,
                    ),

                    const SizedBox(height: 20),

                    _buildTitle(questionType),

                    const SizedBox(height: 20),

                    _buildQuestionUI(context, vm, vocab, questionType),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // RANDOM loại câu hỏi
  QuestionType _randomQuestion() {
    final List<QuestionType> types = QuestionType.values;
    types.shuffle();
    return types.first;
  }

  // Tiêu đề riêng cho từng loại
  Widget _buildTitle(QuestionType type) {
    switch (type) {
      case QuestionType.dragDrop:
        return Text("Kéo từ vào đúng nghĩa", style: _titleStyle());
      case QuestionType.multipleChoice:
        return Text("Chọn nghĩa đúng", style: _titleStyle());
      case QuestionType.buildWord:
        return Text("Sắp xếp chữ cái thành từ đúng", style: _titleStyle());
      case QuestionType.textInput:
        return Text("Nhập từ đúng", style: _titleStyle());
    }
  }

  TextStyle _titleStyle() =>
      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  /// RENDER UI theo dạng bài
  Widget _buildQuestionUI(BuildContext context, T vm, VocabularyModel vocab, QuestionType type) {
    switch (type) {

    // 1. KÉO THẢ
      case QuestionType.dragDrop:
        return _dragDropUI(context, vm, vocab);

    // 2. CHỌN ĐÁP ÁN
      case QuestionType.multipleChoice:
        return _multipleChoiceUI(context, vm, vocab);

    // 3. GHÉP CHỮ
      case QuestionType.buildWord:
        return _buildWordUI(context, vm, vocab);

    // 4. NHẬP CHỮ
      case QuestionType.textInput:
        return _inputAnswerUI(context, vm, vocab);
    }
  }

  // -----------------------------
  // UI 1: DRAG DROP
  // -----------------------------
  Widget _dragDropUI(BuildContext context, T vm, VocabularyModel word) {
    final meanings = [
      word.meaning,
      "Sai 1",
      "Sai 2",
    ]..shuffle();

    return Column(
      children: [
        Text("Nghĩa: ${word.meaning}", style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: meanings.map((m) {
            return DragTarget<String>(
              builder: (_, __, ___) => _dropBox(m),
              onAccept: (data) {
                if (data == word.meaning) {
                  _handleCorrect(vm, context);
                } else {
                  _handleWrong(vm,context);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 30),

        Draggable<String>(
          data: word.meaning,
          feedback: _draggableBox(word.word),
          child: _draggableBox(word.word),
        ),
      ],
    );
  }

  // -----------------------------
  // UI 2: MULTIPLE CHOICE
  // -----------------------------
  Widget _multipleChoiceUI(BuildContext context, T vm, VocabularyModel word) {
    final options = [
      word.meaning,
      "Sai 1",
      "Sai 2",
      "Sai 3"
    ]..shuffle();

    return Column(
      children: options.map((o) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppColors.primaryDark, width: 2),
            ),
            onPressed: () {
              if (o == word.meaning) {
                _handleCorrect(vm, context);
              } else {
                _handleWrong(vm,context);
              }
            },
            child: Text(o, style: const TextStyle(color: Colors.black)),
          ),
        );
      }).toList(),
    );
  }

  // -----------------------------
  // UI 3: BUILD WORD – GHÉP CHỮ
  // -----------------------------
  Widget _buildWordUI(BuildContext context, T vm, VocabularyModel word) {
    final letters = word.word.split('')..shuffle();

    List<String> selected = [];

    return StatefulBuilder(
      builder: (_, setState) => Column(
        children: [
          Text("Nghĩa: ${word.meaning}", style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),

          Wrap(
            children: [
              for (var letter in letters)
                ElevatedButton(
                  onPressed: () {
                    selected.add(letter);
                    setState(() {});
                    if (selected.join() == word.word) {
                      _handleCorrect(vm, context);
                    } else if (selected.length == word.word.length) {
                      _handleWrong(vm,context);
                    }
                  },
                  child: Text(letter),
                ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: Text(selected.join()),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // UI 4: INPUT ANSWER
  // -----------------------------
  Widget _inputAnswerUI(BuildContext context, T vm, VocabularyModel word) {
    final controller = TextEditingController();

    return Column(
      children: [
        Text("Nghĩa: ${word.meaning}", style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Nhập từ tiếng Anh",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().toLowerCase() == word.word.toLowerCase()) {
              _handleCorrect(vm, context);
            } else {
              _handleWrong(vm,context);
            }
          },
          child: const Text("Xác nhận"),
        )
      ],
    );
  }

  // -----------------------------
  // Helper UI Widgets
  // -----------------------------
  Widget _dropBox(String text) => Container(
    width: 140,
    height: 80,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );

  Widget _draggableBox(String text) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.Orange,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
  );

  // -----------------------------
  // Handle correct / wrong
  // -----------------------------
  void _handleCorrect(T vm, BuildContext context) {
    // View model giữ nguyên logic cũ → gọi checkAnswer hoặc onDragCompleted
    if (vm is Practice1Viewmodel) vm.onDragCompleted(vm.currentWord!.meaning, context);
    if (vm is Practice2ViewModel) vm.checkAnswer(vm.quizQuestions[vm.currentQuestionIndex]['correctAnswer'], context);
    if (vm is Practice3ViewModel) vm.checkAnswer(context);
    if (vm is Practice4ViewModel) vm.checkAnswer(vm.currentWord.word, context);
  }

  void _handleWrong(T vm, BuildContext context) {
    if (vm is Practice1Viewmodel) vm.onDragCompleted("WRONG", context);
    if (vm is Practice2ViewModel) vm.checkAnswer("WRONG", context);
    if (vm is Practice3ViewModel) vm.checkAnswer(context);
    if (vm is Practice4ViewModel) vm.checkAnswer("WRONG", context);
  }

}
