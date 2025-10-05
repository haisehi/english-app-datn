import 'package:english_learning_app/view_model/statistics_score_viewmodel.dart';
import 'package:english_learning_app/views/widget/card/statistics_score_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScoreTab extends StatefulWidget {
  final int courseID;


  StatisticsScoreTab(this.courseID);

  @override
  State<StatisticsScoreTab> createState() => _StatisticsScoreTabState();
}

class _StatisticsScoreTabState extends State<StatisticsScoreTab> {

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  void _loadExam() {
    Future.microtask(() =>
        Provider.of<StatisticsScoreViewmodel>(context, listen: false)
            .fetchExams(widget.courseID));
  }

  @override
  Widget build(BuildContext context) {
    final StatisticsScoreViewmodel viewModel = Provider.of<StatisticsScoreViewmodel>(context);


    return Scaffold(

      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.exams.isEmpty
          ? const Center(child: Text("Chưa có thống kê nào"))
          : ListView(
        children: viewModel.groupExamsByName().entries
            .map((entry) => BarChartWidget(
          examName: entry.key,
          scores: entry.value,
        ))
            .toList(),
      ),
    );

  }
}
