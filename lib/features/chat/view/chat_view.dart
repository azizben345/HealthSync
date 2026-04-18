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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 300, 
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = context.watch<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Coach'),
        centerTitle: true,
        // Clear History button
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: "Clear History",
            onPressed: () => chatCtrl.clearHistory(),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true, 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatCtrl.messages.length,
              itemBuilder: (context, index) {
                final msg = chatCtrl.messages[index];
                return _buildChatBubble(context, msg.text, msg.isUser);
              },
            ),
          ),

          if (chatCtrl.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),

          _buildMessageInput(context, chatCtrl),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  // pass BuildContext - can read the Theme
  Widget _buildChatBubble(BuildContext context, String text, bool isUser) {
    final theme = Theme.of(context); // Grab the current theme (Light or Dark)

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          // use 'primary' for user, 'surfaceContainerHighest' for AI
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, 
        ),
        child: Text(
          text,
          style: TextStyle(
            // Automatically select text color that contrasts with the bubble background
            color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatController chatCtrl) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Adapts to Dark Mode background
        boxShadow: [
          // theme-aware shadow that disappears smoothly in dark mode
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05), 
            blurRadius: 8, 
            offset: const Offset(0, -2)
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Ask about your health data...",
                  // custom pill-shaped border just for the chat box
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  // Adapts beautifully in both modes
                  fillColor: theme.colorScheme.surfaceContainerHighest, 
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
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
              backgroundColor: chatCtrl.isLoading 
                  ? theme.colorScheme.surfaceContainerHighest 
                  : theme.colorScheme.primary,
              child: IconButton(
                icon: Icon(
                  Icons.send, 
                  color: chatCtrl.isLoading ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onPrimary
                ),
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