import 'dart:math';
import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../models/chat_message.dart';
import '../services/openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _apiMessages = [];
  bool _isLoading = false;
  bool _gameOver = false;
  late ScenarioType _currentScenario;
  late String _strangerName;
  late String _strangerAvatar;

  final List<String> _friendlyNames = [
    'Alex', 'Charlie', 'Sam', 'Jordan', 'Taylor', 
    'Casey', 'Riley', 'Morgan', 'Skylar', 'Jamie'
  ];

  final List<String> _avatarEmojis = [
    '😊', '🙂', '😎', '🤗', '😇', 
    '🌟', '✨', '🎮', '🎨', '🎵'
  ];

  @override
  void initState() {
    super.initState();
    _selectRandomScenario();
    _selectRandomStranger();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _addInitialMessage();
    }
  }

  void _selectRandomScenario() {
    final scenarios = ScenarioType.values;
    _currentScenario = scenarios[Random().nextInt(scenarios.length)];
  }

  void _selectRandomStranger() {
    _strangerName = _friendlyNames[Random().nextInt(_friendlyNames.length)];
    _strangerAvatar = _avatarEmojis[Random().nextInt(_avatarEmojis.length)];
  }

  void _addInitialMessage() {
    final localizations = AppLocalizations.of(context);
    setState(() {
      _messages.add(
        ChatMessage(
          text: localizations.translate('chat_started'),
          isUser: false,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _gameOver) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });

    _scrollToBottom();

    // Agregar mensaje del usuario al historial de la API
    _apiMessages.add({
      'role': 'user',
      'content': userMessage,
    });

    try {
      final response = await OpenAIService.sendMessage(
        messages: _apiMessages,
        scenario: _currentScenario,
      );

      final isGameOver = response['isGameOver'] as bool;
      final message = response['message'] as String;

      // Agregar respuesta al historial
      _apiMessages.add({
        'role': 'assistant',
        'content': message,
      });

      setState(() {
        _messages.add(ChatMessage(text: message, isUser: false));
        _isLoading = false;
      });

      _scrollToBottom();

      // Si el juego terminó, mostrar modal
      if (isGameOver) {
        setState(() {
          _gameOver = true;
        });
        _showGameOverDialog(message);
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      setState(() {
        _messages.add(
          ChatMessage(
            text: '${localizations.translate('error_api')}: $e',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _showGameOverDialog(String explanation) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.translate('game_over'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('you_lost'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              explanation,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(localizations.translate('go_back')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0084FF),
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.translate('play_again')),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _messages.clear();
      _apiMessages.clear();
      _isLoading = false;
      _gameOver = false;
      _selectRandomScenario();
      _selectRandomStranger();
      _addInitialMessage();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0084FF),
              child: Text(
                _strangerAvatar,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _strangerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  localizations.translate('online'),
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
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
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(localizations.translate('loading')),
              ),
            _buildMessageInput(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF0084FF)
              : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_gameOver,
                decoration: InputDecoration(
                  hintText: localizations.translate('type_message'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: _gameOver 
                  ? Colors.grey 
                  : const Color(0xFF0084FF),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: (_isLoading || _gameOver) ? null : _sendMessage,
              ),
            ),
          ],
        ),
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
