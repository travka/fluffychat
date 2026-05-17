// SPDX-FileCopyrightText: 2025 Hermes Fork
// SPDX-License-Identifier: AGPL-3.0-or-later

class BotCommand {
  final String command;
  final String description;
  final String? botName;
  final String? botAvatar;

  BotCommand({
    required this.command,
    required this.description,
    this.botName,
    this.botAvatar,
  });

  factory BotCommand.fromJson(Map<String, dynamic> json) {
    return BotCommand(
      command: json['command'] as String,
      description: json['description'] as String,
      botName: json['bot_name'] as String?,
      botAvatar: json['bot_avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'command': command,
    'description': description,
    if (botName != null) 'bot_name': botName,
    if (botAvatar != null) 'bot_avatar': botAvatar,
  };
}

class BotCommandsState {
  final List<BotCommand> commands;

  BotCommandsState({required this.commands});

  factory BotCommandsState.fromJson(Map<String, dynamic> json) {
    final commandsList = json['commands'] as List<dynamic>? ?? [];
    return BotCommandsState(
      commands: commandsList
          .map((c) => BotCommand.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'commands': commands.map((c) => c.toJson()).toList(),
  };
}
