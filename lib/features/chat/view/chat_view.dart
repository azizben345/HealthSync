import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/chat_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start the chat the moment this screen opens, but wait for the UI to build first!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().initializeChat();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper to automatically scroll to the bottom when a new message appears
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 300, // Scroll all the way down
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = context.watch<ChatController>();

    // everytime the messages list changes, trigger 'scroll to the bottom'
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Coach'),
        centerTitle: true,
      ),
      // prevents the keyboard from covering UI
      resizeToAvoidBottomInset: true, 
      body: Column(
        children: [
          // 1. The Scrollable Chat History
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatCtrl.messages.length,
              itemBuilder: (context, index) {
                final msg = chatCtrl.messages[index];
                return _buildChatBubble(msg.text, msg.isUser);
              },
            ),
          ),

          // "Thinking" Indicator
          if (chatCtrl.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),

          // 3. The Text Input Row
          _buildMessageInput(chatCtrl),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      // Move user messages to the right, AI messages to the left
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            // Make the bottom corners flat depending on who is speaking
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        // Prevent the bubble from stretching across the entire screen
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, 
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatController chatCtrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, -1)),
        ],
      ),
      // SafeArea prevents the text box from hiding under the iPhone Home Bar
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Ask about your health data...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                // Allow the user to hit "Enter" on their keyboard to send
                onSubmitted: (text) {
                  if (text.isNotEmpty && !chatCtrl.isLoading) {
                    chatCtrl.sendMessage(text);
                    _textController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            // The Send Button
            CircleAvatar(
              backgroundColor: chatCtrl.isLoading ? Colors.grey : Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: chatCtrl.isLoading
                    ? null
                    : () {
                        if (_textController.text.isNotEmpty) {
                          chatCtrl.sendMessage(_textController.text);
                          _textController.clear();
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}