import 'package:flutter/material.dart';
import 'package:ilike/features/chat/domain/repositories/chat_repository.dart';
import 'package:ilike/core/service_locator/service_locator.dart';
import 'package:ilike/core/utils/snackbar_utils.dart';

class ItsAMatchPage extends StatelessWidget {
  final String currentUserPhotoUrl;
  final String matchedUserId;
  final String matchedUserName;
  final String matchedUserPhotoUrl;

  const ItsAMatchPage({
    Key? key,
    required this.currentUserPhotoUrl,
    required this.matchedUserId,
    required this.matchedUserName,
    required this.matchedUserPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 0, 0, 0.8),
              Color.fromRGBO(0, 0, 0, 0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "It's a Match!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 56,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You and $matchedUserName have liked each other.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileImage(currentUserPhotoUrl),
                    const SizedBox(width: 32),
                    _buildProfileImage(matchedUserPhotoUrl),
                  ],
                ),
                const SizedBox(height: 48),
                // SEND MESSAGE button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final chatResult =
                          await sl<ChatRepository>().createChat(matchedUserId);
                      chatResult.fold(
                        (failure) {
                          showErrorSnackBar(context, failure.message);
                        },
                        (chat) {
                          Navigator.pop(context); // Remove match screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                  chatId: chat.chatId,
                                  otherUserName: matchedUserName),
                            ),
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => null,
                      ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEC4899),
                            Color(0xFFF97316),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'SEND MESSAGE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // KEEP SWIPING button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          width: 2,
                          color: Colors.transparent,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEC4899),
                            Color(0xFFF97316),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'KEEP SWIPING',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String url) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }
}

// Placeholder ChatScreen for navigation demo
class ChatScreen extends StatelessWidget {
  final String chatId;
  final String otherUserName;
  const ChatScreen(
      {Key? key, required this.chatId, required this.otherUserName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $otherUserName')),
      body: Center(child: Text('Chat ID: $chatId')),
    );
  }
}
