import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:preab/preab.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../util/format.dart';
import '../../widgets/profile_avatar.dart';

class MessageTile extends StatelessWidget {
  final ChatMessageModel message;
  final RoomModel room;
  const MessageTile({Key? key, required this.message, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const messageBoxMargin = 64.0;
    final bool hasAttachment = message.hasAttachment;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMyMessage) ...[
            ProfileAvatar(user: room.otherUser),
            const SpaceX(),
          ],
          Expanded(
            child: Align(
              alignment: message.isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Stack(
                children: [
                  Container(
                    margin: message.isMyMessage
                        ? const EdgeInsets.only(left: messageBoxMargin)
                        : const EdgeInsets.only(right: messageBoxMargin),
                    padding: EdgeInsets.only(
                      left: 8,
                      top: 8,
                      bottom: hasAttachment ? 24 : 16,
                      right: hasAttachment ? 8 : 56,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: SuraDecoration.radius(12),
                      color: Colors.black12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.hasAttachment) _ImageMessage(attachment: message.fullUrl),
                        if (message.message.isNotEmpty) Text(message.message)
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: message.isMyMessage ? 6 : messageBoxMargin + 6,
                    child: Text(
                      formatMessageDateTime(message.created),
                      style: context.textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageMessage extends StatelessWidget {
  final String attachment;
  const _ImageMessage({Key? key, required this.attachment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 200;
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: CachedNetworkImage(
            imageUrl: attachment,
            placeholder: (context, obj) => const SizedBox(
              width: 120,
            ),
            height: imageHeight,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
