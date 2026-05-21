import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MatchesListItem {
  final String name;
  final String image;
  final bool isOnline;

  const _MatchesListItem({
    required this.name,
    required this.image,
    required this.isOnline,
  });
}

class _ChatItem {
  final String name;
  final String image;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const _ChatItem({
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

class _MessagesScreenState extends State<MessagesScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  static const Color darkTealColor = Color(0xFF003328);

  final List<_MatchesListItem> _newMatches = const [
    _MatchesListItem(name: 'Sophia', image: 'assets/images/image1.png', isOnline: true),
    _MatchesListItem(name: 'Jessica', image: 'assets/images/image2.png', isOnline: false),
    _MatchesListItem(name: 'Clara', image: 'assets/images/image3.png', isOnline: true),
    _MatchesListItem(name: 'Emily', image: 'assets/images/image1.png', isOnline: true),
  ];

  final List<_ChatItem> _chats = const [
    _ChatItem(
      name: 'Sophia',
      image: 'assets/images/image1.png',
      lastMessage: 'Hey! Are we still on for coffee tomorrow?',
      time: '2 min ago',
      unreadCount: 2,
      isOnline: true,
    ),
    _ChatItem(
      name: 'Clara',
      image: 'assets/images/image3.png',
      lastMessage: 'I loved the art exhibit recommendations!',
      time: '1 hour ago',
      unreadCount: 0,
      isOnline: true,
    ),
    _ChatItem(
      name: 'Jessica',
      image: 'assets/images/image2.png',
      lastMessage: 'Let\'s catch up sometime next week!',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE9E2D9), width: 1.2),
                    ),
                    child: const Icon(Icons.search_rounded, color: goldColor, size: 26),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Search Field ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FBF9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE9E2D9), width: 1.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search messages...',
                    hintStyle: TextStyle(color: Color(0xFFB8B8C2)),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: goldColor),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── "New Matches" Horizontal List ──
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Matches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: darkTealColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 96,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _newMatches.length,
                      itemBuilder: (context, index) {
                        final item = _newMatches[index];
                        return Container(
                          width: 74,
                          margin: const EdgeInsets.only(right: 18),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(item.image),
                                  ),
                                  if (item.isOnline)
                                    Positioned(
                                      bottom: 0,
                                      right: 2,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.0),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Chats Header ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Recent Chats',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: darkTealColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Chat List ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF7FBF9), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(chat.image),
                            ),
                            if (chat.isOnline)
                              Positioned(
                                bottom: 0,
                                right: 2,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          chat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            chat.lastMessage,
                            style: TextStyle(
                              color: chat.unreadCount > 0 ? Colors.black87 : const Color(0xFF656565),
                              fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              chat.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB8B8C2),
                              ),
                            ),
                            if (chat.unreadCount > 0) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: goldColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  chat.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
