import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sura_flutter/sura_flutter.dart';

class MessageComposer extends StatefulWidget {
  final TextEditingController textEditingController;
  final FutureOr<void> Function(File?) onSend;
  const MessageComposer({
    Key? key,
    required this.textEditingController,
    required this.onSend,
  }) : super(key: key);

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> with BoolNotifierMixin {
  File? _pickedfile;

  void removeImage() => setState(() => _pickedfile = null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_pickedfile != null)
              _PickedImage(
                image: _pickedfile!,
                onRemove: removeImage,
                notifier: boolNotifier,
              ),
            Row(
              children: [
                PickImageButton(
                  onChanged: (file) {
                    setState(() {
                      _pickedfile = File(file.path);
                    });
                  },
                ),
                const SpaceX(2),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: widget.textEditingController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Message",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: SuraDecoration.radius(24),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: boolNotifier.builder(
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              toggleValue(true);
                              await widget.onSend(_pickedfile);
                              toggleValue(false);
                              removeImage();
                            },
                          ),
                          builder: (ctx, child) {
                            if (boolNotifier.value) {
                              return const IconButton(
                                icon: Icon(Icons.send),
                                onPressed: null,
                              );
                            }
                            return child!;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SpaceX(8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PickImageButton extends StatelessWidget {
  final void Function(XFile) onChanged;
  const PickImageButton({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuraIconButton(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1000,
        );
        if (file != null) {
          onChanged.call(file);
        }
      },
      icon: const Icon(Icons.image),
      margin: EdgeInsets.zero,
    );
  }
}

class _PickedImage extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;
  final ValueNotifier<bool> notifier;
  const _PickedImage({
    Key? key,
    required this.image,
    required this.onRemove,
    required this.notifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = SuraDecoration.radius(12);
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(bottom: 12, left: 16),
      decoration: BoxDecoration(
        borderRadius: radius,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(image),
        ),
      ),
      alignment: Alignment.topRight,
      child: notifier.builder(
        child: SuraIconButton(
          onTap: onRemove,
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.all(2),
          backgroundColor: Colors.black12,
          borderRadius: 16,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
        builder: (context, child) {
          if (notifier.value) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: radius,
              ),
              alignment: Alignment.center,
              child: const Text(
                "Sending....",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return child!;
        },
      ),
    );
  }
}
