import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  // FAQ data
  final Map<String, String> faqResponses = {
    'hello': 'Hi! How can I assist you today?',
    'help': 'I can answer FAQs or guide you. Try asking about "hours", "contact", or "services".',
    'hours': 'Our business hours are 9 AM to 5 PM, Monday to Friday.',
    'contact': 'You can reach us at support@example.com or call (123) 456-7890.',
    'services': 'We offer consulting, development, and support services.',
    'bye': 'Goodbye! Have a great day!',
    'book': 'ggrrgrfrfrbook'
  };

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      // Add user message
      messages.add({'sender': 'user', 'text': _controller.text});

      // Process input and get bot response
      String response = _getBotResponse(_controller.text.toLowerCase());
      messages.add({'sender': 'bot', 'text': response});
    });

    _controller.clear();
  }

  String _getBotResponse(String input) {
    // Default response if no match is found
    String defaultResponse = "Sorry, I don't understand. Try asking about 'help', 'hours', or 'contact'.";

    // Check for keyword matches
    for (String keyword in faqResponses.keys) {
      if (input.contains(keyword)) {
        return faqResponses[keyword]!;
      }
    }
    return defaultResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Bot',
          style: TextStyle(fontSize: 19),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUser = messages[index]['sender'] == 'user';
                  return ListTile(
                    title: Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(messages[index]['text']!),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input field and send button
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
