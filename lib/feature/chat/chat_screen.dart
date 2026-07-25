import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';

enum ChatSender { bot, user }

class ChatMessage {
  const ChatMessage({required this.sender, required this.text});

  final ChatSender sender;
  final String text;
}

/// PLACEHOLDER CONTENT: Figma only specifies the exact copy for the
/// Module 1 Pre-Chat/Chat example (one greeting + a handful of quick
/// replies). There's no real chat backend wired up, so this is a
/// canned, rotating set of supportive replies rather than a live AI
/// response — good enough to make the interaction feel real, but not
/// actually intelligent.
const List<String> _placeholderBotReplies = [
  "Îți mulțumesc că ai împărtășit asta. Hai să vedem împreună ce iese în evidență.",
  "Are sens. Nu trebuie să ai un răspuns perfect — putem lua lucrurile pas cu pas.",
  "Bun de știut. Ce simți că ar fi cel mai util să clarificăm acum?",
];

/// Shared layout for the "Pre-Chat" (116:771) and "Chat" (116:920) Figma
/// frames — they're the same screen at different points in a
/// conversation, so one widget covers both: seed it with a single bot
/// greeting for the Pre-Chat entry state, or with a bot+user exchange
/// already in progress for the Chat state.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contextLabel,
    required this.seedMessages,
    required this.starterPrompts,
    this.promptLabel = "Poți începe cu:",
    this.continueLabel,
    this.onContinue,
  });

  /// Header subtitle pill, e.g. "Modulul 1 · Răspunsurile tale".
  final String contextLabel;
  final List<ChatMessage> seedMessages;
  final List<String> starterPrompts;
  final String promptLabel;

  /// Highlighted "Continuă cu Modulul N" quick reply (Figma's
  /// ui/status/in-progress tint). Omitted when there's no obvious next
  /// step from this chat (e.g. the report screen's chat entry point).
  final String? continueLabel;
  final VoidCallback? onContinue;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<ChatMessage> _messages = List.of(widget.seedMessages);
  late final List<String> _prompts = List.of(widget.starterPrompts);
  final TextEditingController _controller = TextEditingController();
  int _replyIndex = 0;

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: text.trim()));
      _prompts.remove(text);
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(sender: ChatSender.bot, text: _placeholderBotReplies[_replyIndex % _placeholderBotReplies.length]));
        _replyIndex++;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Chat FutureMe",
                        style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.faint,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          widget.contextLabel,
                          style: const TextStyle(color: AppColors.uiHeading, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final message in _messages) ...[_MessageBubble(message: message), const SizedBox(height: 16)],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.promptLabel,
                          style: const TextStyle(
                            color: AppColors.uiHeadingSmall,
                            fontSize: 14,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final prompt in _prompts)
                              GestureDetector(
                                onTap: () => _send(prompt),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.faint,
                                    border: Border.all(color: AppColors.borderStrong),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    prompt,
                                    style: const TextStyle(
                                      color: AppColors.uiHeading,
                                      fontSize: 14,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w500,
                                      height: 1.29,
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.continueLabel != null)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onContinue?.call();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceHighlight,
                                    border: const Border.fromBorderSide(BorderSide(color: Color(0xFFE8C979))),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.continueLabel!,
                                        style: const TextStyle(
                                          color: Color(0xFF9A6500),
                                          fontSize: 14,
                                          fontFamily: AppFonts.body,
                                          fontWeight: FontWeight.w500,
                                          height: 1.29,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF9A6500)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "Întreabă ce vrei să clarifici...",
                          hintStyle: TextStyle(color: AppColors.container, fontFamily: AppFonts.body, fontSize: 16),
                        ),
                        style: const TextStyle(color: AppColors.dashboard, fontFamily: AppFonts.body, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _send(_controller.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(gradient: AppColors.specialGradient, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            AppBottomNavBar(activeIndex: 1, onHomeTap: () => goToDashboard(context)),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.grad1,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5)),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(child: Image.asset(AppAssets.moduleIcon, width: 40, height: 40, fit: BoxFit.cover)),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Text(
              message.text,
              style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
