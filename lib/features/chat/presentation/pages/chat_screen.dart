import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Demo messages
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadDemoMessages();
  }

  void _loadDemoMessages() {
    // Demo conversation based on the chat
    final chatName = widget.chat['name'] as String;

    if (chatName == 'Priya Thapa') {
      _messages = [
        {
          'id': '1',
          'text': 'Namaste! How are you doing? 😊',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(minutes: 5)),
        },
        {
          'id': '2',
          'text':
              'Hi Priya! I\'m doing great, thanks for asking! How about you?',
          'isMe': true,
          'time': DateTime.now().subtract(const Duration(minutes: 4)),
        },
        {
          'id': '3',
          'text': 'Pretty good! Just finished my yoga session 🧘‍♀️',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(minutes: 3)),
        },
        {
          'id': '4',
          'text': 'That\'s awesome! Do you practice at home or at a studio?',
          'isMe': true,
          'time': DateTime.now().subtract(const Duration(minutes: 2)),
        },
        {
          'id': '5',
          'text': 'At home mostly, but sometimes I go to classes in Thamel!',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(minutes: 1)),
        },
      ];
    } else if (chatName == 'Rajesh Gurung') {
      _messages = [
        {
          'id': '1',
          'text': 'That momo place in Patan was amazing! We should go again',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'id': '2',
          'text': 'Absolutely! The momos were incredible. When are you free?',
          'isMe': true,
          'time': DateTime.now().subtract(const Duration(minutes: 55)),
        },
        {
          'id': '3',
          'text': 'How about this weekend? Saturday evening?',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(minutes: 50)),
        },
      ];
    } else {
      // Default demo messages
      _messages = [
        {
          'id': '1',
          'text': 'Hi there! 👋',
          'isMe': false,
          'time': DateTime.now().subtract(const Duration(minutes: 10)),
        },
        {
          'id': '2',
          'text': 'Hello! Nice to meet you!',
          'isMe': true,
          'time': DateTime.now().subtract(const Duration(minutes: 9)),
        },
      ];
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': _messageController.text.trim(),
      'isMe': true,
      'time': DateTime.now(),
    };

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate typing indicator and response
    _simulateResponse();
  }

  void _simulateResponse() {
    setState(() {
      _isTyping = true;
    });

    // Simulate typing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });

        // Add demo response
        final responses = [
          'That sounds great! 😊',
          'I totally agree with you!',
          'Thanks for sharing that with me',
          'That\'s interesting! Tell me more',
          'I\'d love to hear more about that',
          'Sounds like fun! 🎉',
        ];

        final randomResponse =
            responses[DateTime.now().millisecond % responses.length];

        final responseMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': randomResponse,
          'isMe': false,
          'time': DateTime.now(),
        };

        setState(() {
          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.chat['profilePicture']),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_isTyping)
                    Text(
                      'Typing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call coming soon!')),
              );
            },
          ),
        ],
        backgroundColor: Colors.pink[100],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(widget.chat['profilePicture']),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message['time']),
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File attachment coming soon!')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
