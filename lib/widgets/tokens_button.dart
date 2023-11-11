import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langi/pages/tokens_page.dart';
import 'package:firebase_database/firebase_database.dart';

class TokensButton extends StatelessWidget {
  const TokensButton({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SizedBox();
    }

    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref('users/$uid/tokens').onValue,
      builder: (context, snapshot) {
        final tokens = snapshot.data?.snapshot.value as int?;

        return TextButton.icon(
          onPressed: () => tokens != null
              ? showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (_) => const TokensPage(),
                )
              : null,
          icon: tokens != null
              ? const Icon(Icons.add)
              : const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Text(
                  '${tokens ?? '-'}',
                  key: ValueKey(tokens),
                ),
              ),
              const Text(' tokens')
            ],
          ),
        );
      },
    );
  }
}
