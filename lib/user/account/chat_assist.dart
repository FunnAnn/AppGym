import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../bottom_main/bottom.dart';
import '../../theme/app_colors.dart';
import '../../api_service/chat_service.dart';

class GemBot extends StatefulWidget {
  const GemBot({super.key});

  @override
  State<GemBot> createState() => _GemBotState();
}

class _GemBotState extends State<GemBot> {
  final TextEditingController prompt = TextEditingController();
  bool isLoading = false;
  String API_KEY = "AIzaSyDAmahgqalrr0uf5HUIs_yd20FYZeSkOXI";
  List<Map<String, String>> messages = [];
  bool useBackendAI = true; // Toggle between backend and Gemini

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await ChatService.getChatHistory();
      setState(() {
        messages = history;
      });
    } catch (e) {
      print('Failed to load chat history: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (prompt.text.trim().isEmpty) return;

    final userMessage = prompt.text.trim();
    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      isLoading = true;
    });

    prompt.clear();

    try {
      String aiResponse;

      if (useBackendAI) {
        // Try backend AI first
        try {
          aiResponse = await ChatService.chatWithAI(userMessage);
        } catch (e) {
          print('Backend AI failed, falling back to Gemini: $e');
          aiResponse = await _getGeminiResponse(userMessage);
        }
      } else {
        // Use Gemini directly
        aiResponse = await _getGeminiResponse(userMessage);
      }

      setState(() {
        isLoading = false;
        messages.add({'role': 'bot', 'text': aiResponse});
      });

      // Save chat history to backend
      await ChatService.saveChatHistory(messages);
    } catch (e) {
      setState(() {
        isLoading = false;
        messages.add({
          'role': 'bot',
          'text': 'Sorry, I encountered an error. Please try again later.'
        });
      });
      print('Error in chat: $e');
    }
  }

  Future<String> _getGeminiResponse(String userMessage) async {
    final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: API_KEY,
        generationConfig:
            GenerationConfig(responseMimeType: 'text/plain'));

    final content = [Content.text(userMessage)];
    final response = await model.generateContent(content);

    return response.text ?? 'Sorry, I could not generate a response.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "AI Chat Assistant",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: AppColors.pinkTheme,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, color: Colors.white),
            onSelected: (value) {
              if (value == 'toggle_ai') {
                setState(() {
                  useBackendAI = !useBackendAI;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      useBackendAI
                          ? 'Switched to Backend AI (with Gemini fallback)'
                          : 'Switched to Gemini AI only',
                    ),
                  ),
                );
              } else if (value == 'clear_chat') {
                setState(() {
                  messages.clear();
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_ai',
                child: Text(
                  useBackendAI
                      ? 'Use Gemini Only'
                      : 'Use Backend AI',
                ),
              ),
              PopupMenuItem(
                value: 'clear_chat',
                child: Text('Clear Chat'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Source Indicator
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                useBackendAI
                    ? '🤖 Using Backend AI (with Gemini fallback)'
                    : '🧠 Using Gemini AI only',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Start a conversation with AI',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return Align(
                          alignment: msg['role'] == 'user'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Card(
                              color: msg['role'] == 'user'
                                  ? AppColors.pinkTheme
                                  : Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  msg['text'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: msg['role'] == 'user'
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      ),
            ),
            if (isLoading)
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('AI is thinking...'),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: prompt,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                      fillColor: AppColors.pinkThemeLight,
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: isLoading ? null : _sendMessage,
                  backgroundColor:
                      isLoading ? Colors.grey : AppColors.pinkTheme,
                  mini: true,
                  child: Icon(
                    isLoading ? Icons.hourglass_empty : Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/workout');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 2) {
            // Handle "Scan QR" button tap
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/package');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    prompt.dispose();
    super.dispose();
  }
}