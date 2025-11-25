import 'package:flutter/material.dart';
import '../../../models/speaking_result_dto.dart';
import '../../../models/speaking_submit_response.dart';


class SpeakingResultScreen extends StatelessWidget {
  final List<SpeakingResultDTO> results;
  final Widget returnTo;
  final SpeakingSubmitResponse submitResponse; // thêm tham số

  const SpeakingResultScreen({
    super.key,
    required this.results,
    required this.returnTo,
    required this.submitResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kết quả luyện nói"),
        backgroundColor: const Color(0xFF2475FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Điểm: ${submitResponse.totalCorrect}/${submitResponse.totalSentences} "
                  "(${submitResponse.percent}%)",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2475FC)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              submitResponse.isPass ? "🎉 Pass" : "❌ Fail",
              style: TextStyle(
                fontSize: 20,
                color: submitResponse.isPass ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final r = results[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        submitResponse.totalCorrect >= index + 1
                            ? Colors.green
                            : Colors.redAccent,
                        child: Icon(
                          submitResponse.totalCorrect >= index + 1
                              ? Icons.check
                              : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Câu ${r.sentenceId}"),
                      subtitle: Text("Bạn nói: ${r.userText}"),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => returnTo),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2475FC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Quay về",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
