class ChatEntity {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserProfilePicture;
  final List<String> otherUserPhotoUrls;
  final DateTime lastMessageTime;
  final String lastMessage;
  final bool isLastMessageFromMe;
  final int unreadCount;

  const ChatEntity({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserProfilePicture,
    required this.otherUserPhotoUrls,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.isLastMessageFromMe,
    required this.unreadCount,
  });

  ChatEntity copyWith({
    String? chatId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserProfilePicture,
    List<String>? otherUserPhotoUrls,
    DateTime? lastMessageTime,
    String? lastMessage,
    bool? isLastMessageFromMe,
    int? unreadCount,
  }) {
    return ChatEntity(
      chatId: chatId ?? this.chatId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserProfilePicture:
          otherUserProfilePicture ?? this.otherUserProfilePicture,
      otherUserPhotoUrls: otherUserPhotoUrls ?? this.otherUserPhotoUrls,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessage: lastMessage ?? this.lastMessage,
      isLastMessageFromMe: isLastMessageFromMe ?? this.isLastMessageFromMe,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

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

  factory ChatEntity.fromJson(Map<String, dynamic> json) {
    return ChatEntity(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatEntity && other.chatId == chatId;
  }

  @override
  int get hashCode => chatId.hashCode;
}
