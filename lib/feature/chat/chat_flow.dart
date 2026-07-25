import 'package:flutter/material.dart';
import 'package:futureme/feature/chat/chat_screen.dart';

/// PLACEHOLDER CONTENT: Figma only shows one worked example of the chat
/// greeting/starters (from the Module 1 entry point). Every "Discută ...
/// în Chat" button across the app opens the same seed conversation with
/// a different [contextLabel] pill, rather than fabricating a unique
/// script per module — there's no real chat backend behind any of it.
void openChat(BuildContext context, {required String contextLabel, String? continueLabel, VoidCallback? onContinue}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        contextLabel: contextLabel,
        seedMessages: const [
          ChatMessage(
            sender: ChatSender.bot,
            text:
                "Mă bucur că ai ajuns aici. Nu trebuie să ai toate răspunsurile acum. Putem lua pe rând ce ai scris și să vedem ce pare important pentru tine.",
          ),
        ],
        starterPrompts: const [
          "Ajută-mă să înțeleg ce am scris",
          "Ce pare important în răspunsurile mele?",
          "Nu știu încă ce vreau. E ok?",
        ],
        continueLabel: continueLabel,
        onContinue: onContinue,
      ),
    ),
  );
}
