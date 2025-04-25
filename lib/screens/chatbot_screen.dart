import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // FAQ data
  final Map<String, String> faqResponses = {
    'hello': 'Hi! How can I assist you today?',
    'hi': 'Hello! How can I assist you today?',
    'help':
        'I can answer FAQs or guide you. Try asking about "places", "bookmarks", "bookings", "logout","popular","navigation", or "hotels". Use "add hotel" to add your business to our app',
    'places': 'Press the places button on home screen/categories.',
    'bookmarks': 'Press the Bookmarks button on home screen/categories.',
    'add hotel': 'Please contact travo.business@gmail.com or call +94 77 2548965 for business inquiries.',
    'hotels': 'Press the Hotels button on home screen/categories.',
    'bookings': 'Press the My Schedule button on home screen/categories.',
    'logout': 'Press the profile icon on top of the home screen.',
    'popular': 'Popular places are the places that are visited often. Listed on the home screen.',
    'navigation': 'You can press on the location marker and then press the directions buttons that popup.',
    'contact': 'You can reach us at travo.support@gmail.com or call +94 77 2548965.',
    'bye': 'Goodbye! Have a great day!',
    'book': 'To book a hotel, go to the Hotels section and select your desired hotel and press on book and proceed to payment.',
  };

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      // Add user message
      messages.add({'sender': 'user', 'text': _controller.text});

      // Process input and get bot response
      String response = _getBotResponse(_controller.text.toLowerCase());
      messages.add({'sender': 'bot', 'text': response});

      // Scroll to the bottom of the chat
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });

    _controller.clear();
  }

  String _getBotResponse(String input) {
    // Default response if no match is found
    String defaultResponse = "Sorry, I don't understand. Try asking about 'help', 'contact', 'places' or 'book'.";

    // Check for keyword matches
    for (String keyword in faqResponses.keys) {
      if (input.contains(keyword)) {
        return faqResponses[keyword]!;
      }
    }
    return defaultResponse;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Info'),
                    content: Text(
                        'To get chatbot assistance you can type help and send. \n\n Bussiness inquiries: travo.business@gmail.com \n\n For more information call us on \n+94 77 2548965'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the popup
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
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
