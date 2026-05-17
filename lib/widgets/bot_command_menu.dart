// SPDX-FileCopyrightText: 2025 Hermes Fork
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/models/bot_command.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class BotCommandMenu extends StatelessWidget {
  final Room room;
  final void Function(String) onCommandSelected;

  const BotCommandMenu({
    required this.room,
    required this.onCommandSelected,
    super.key,
  });

  List<BotCommand> getBotCommands() {
    final state = room.getState('m.room.bot.commands', '');
    if (state == null) return [];
    try {
      final content = state.content;
      if (content['commands'] is! List) return [];
      return (content['commands'] as List)
          .map((c) => BotCommand.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commands = getBotCommands();

    if (commands.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      tooltip: 'Bot commands',
      icon: Icon(
        Icons.slash,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Bot Commands',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: commands.length,
                    itemBuilder: (context, i) {
                      final cmd = commands[i];
                      return ListTile(
                        leading: cmd.botAvatar != null
                            ? Avatar(
                                mxContent: Uri.tryParse(cmd.botAvatar!),
                                name: cmd.botName ?? 'Bot',
                                size: 30,
                                client: room.client,
                              )
                            : Icon(
                                Icons.smart_toy_outlined,
                                color: theme.colorScheme.primary,
                              ),
                        title: Text(
                          '/${cmd.command}',
                          style: const TextStyle(fontFamily: 'RobotoMono'),
                        ),
                        subtitle: Text(cmd.description),
                        onTap: () {
                          Navigator.pop(context);
                          onCommandSelected('/${cmd.command} ');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
