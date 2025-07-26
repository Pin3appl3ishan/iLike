import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.chatId,
    required super.otherUserId,
    required super.otherUserName,
    super.otherUserProfilePicture,
    required super.otherUserPhotoUrls,
    required super.lastMessageTime,
    required super.lastMessage,
    required super.isLastMessageFromMe,
    required super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'] ?? '',
      otherUserId: json['otherUserId'] ?? '',
      otherUserName: json['otherUserName'] ?? '',
      otherUserProfilePicture: json['otherUserProfilePicture'],
      otherUserPhotoUrls: List<String>.from(json['otherUserPhotoUrls'] ?? []),
      lastMessageTime: DateTime.parse(
        json['lastMessageTime'] ?? DateTime.now().toIso8601String(),
      ),
      lastMessage: json['lastMessage'] ?? '',
      isLastMessageFromMe: json['isLastMessageFromMe'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserProfilePicture': otherUserProfilePicture,
      'otherUserPhotoUrls': otherUserPhotoUrls,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'isLastMessageFromMe': isLastMessageFromMe,
      'unreadCount': unreadCount,
    };
  }
}
