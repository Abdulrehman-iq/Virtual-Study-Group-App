import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modify the model to handle trivia questions
class ProgrammingNote {
  final String question;
  final List<String> options;
  final String correctAnswer;

  ProgrammingNote({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory ProgrammingNote.fromJson(Map<String, dynamic> json) {
    return ProgrammingNote(
      question: json['question'] ?? 'No question available',
      options: List<String>.from(json['incorrect_answers'] ?? []),
      correctAnswer: json['correct_answer'] ?? 'No correct answer available',
    );
  }
}

class OpenAIService {
  final String apiKey;

  OpenAIService({required this.apiKey});

  Future<String> fetchExplanation(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = json.encode({
      'model':
          'text-davinci-003', // You can use other models such as 'gpt-3.5-turbo'
      'prompt': prompt,
      'max_tokens': 150,
      'temperature': 0.7,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].trim(); // Return the generated text
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching explanation: $e');
    }
  }
}

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<ProgrammingNote> notes = [];
  Map<int, String> explanations =
      {}; // Map to store explanations for each question

  final String openAIKey =
      'your-openai-api-key'; // Replace with your OpenAI API key
  final OpenAIService openAIService =
      OpenAIService(apiKey: 'your-openai-api-key'); // Initialize OpenAI service

  @override
  void initState() {
    super.initState();
    _fetchProgrammingNotes();
  }

  Future<void> _fetchProgrammingNotes() async {
    try {
      // Open Trivia Database API to fetch programming trivia questions
      final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=18&type=multiple',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          notes =
              results.map((item) => ProgrammingNote.fromJson(item)).toList();
          isLoading = false;
        });

        // Fetch explanations from OpenAI for each question
        _fetchExplanationsForQuestions();
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage =
              'Error loading data (Status Code: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> _fetchExplanationsForQuestions() async {
    for (int i = 0; i < notes.length; i++) {
      try {
        String prompt =
            "Explain the following programming question: ${notes[i].question}";
        String explanation = await openAIService.fetchExplanation(prompt);

        setState(() {
          explanations[i] = explanation;
        });
      } catch (e) {
        setState(() {
          explanations[i] = 'Error fetching explanation: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programming Trivia with Explanations'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Handle tap if needed
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.question,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...note.options.map((option) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                'Correct Answer: ${note.correctAnswer}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Display the explanation if it's available
                              explanations.containsKey(index)
                                  ? Text(
                                      'Explanation: ${explanations[index]}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : const CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SubjectsScreen(),
  ));
}
