import 'package:lottie/lottie.dart';
import 'package:message_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

class CGMessageScreen extends StatefulWidget {
  final User? user;
  bool _isSend = false;
  bool _isEmojiShow = false;
  FocusNode? _focusNode;
  int? radioGroupItem = 1;
  bool? chk = false;

  final _messageController = TextEditingController();

  CGMessageScreen({super.key, this.user});

  @override
  State<CGMessageScreen> createState() => _CGMessageScreenState();
}

class _CGMessageScreenState extends State<CGMessageScreen> with SingleTickerProviderStateMixin {
  final popupmenuButton = GlobalKey<State>();
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    widget._focusNode = FocusNode();
  }
  _buildSendMessageWidget() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(60.0), color: Colors.white),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: widget._isEmojiShow ? const Icon(Icons.keyboard) : const Icon(Icons.insert_emoticon),
                iconSize: 25.0,
                color: Colors.grey,
                onPressed: () {
                  setState(() {});
                  if (!widget._isEmojiShow) {
                    widget._focusNode!.unfocus();
                    widget._isEmojiShow = true;
                  } else {
                    widget._focusNode!.requestFocus();
                    widget._isEmojiShow = false;
                  }
                },
              ),
              TextField(
                controller: widget._messageController,
                focusNode: widget._focusNode,
                onSubmitted: (data) {
                  setState(() {});
                  widget._isSend = false;
                },
                onChanged: (data) {
                  setState(() {});
                  widget._messageController.text.isNotEmpty ? widget._isSend = true : widget._isSend = false;
                },
                onTap: () {
                  setState(() {});
                  if (widget._isEmojiShow) widget._isEmojiShow = false;
                },
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration.collapsed(hintText: 'Type a message'),
              ).expand(),
              IconButton(
                icon: const Icon(Icons.attach_file),
                iconSize: 25.0,
                color: Colors.grey,
                onPressed: () {
                  setState(() {});
                  _showAttachmentDialog();
                  if (!widget._isEmojiShow) _showAttachmentDialog();
                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                iconSize: 25.0,
                color: Colors.grey,
                onPressed: () {},
              ),
            ],
          ),
        ).expand(),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(60.0), color: Colors.pink),
          child: IconButton(
            icon: widget._isSend ? const Icon(Icons.send) : const Icon(Icons.mic),
            iconSize: 20.0,
            color: Colors.white,
            onPressed: () {
              // setState(() {});
              // widget._isSend && widget._messageController.text.isNotEmpty ? _sendMessage() : print("no message");
            },
          ),
        ).paddingRight(10).paddingTop(10),
      ],
    );
  }

  _showAttachmentDialog() {
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            height: 350,
            margin: const EdgeInsets.only(bottom: 70, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: GridView.count(
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                _attachmentDataItem(context, const Icon(Entypo.text_document, size: 30, color: Colors.white), "Document", Colors.indigo[800], 1),
                _attachmentDataItem(context, const Icon(Icons.camera_alt_rounded, size: 30, color: Colors.white), "Camera", Colors.pink[800], 2),
                _attachmentDataItem(context, const Icon(Icons.panorama, size: 30, color: Colors.white), "Gallery", Colors.purple, 3),
                _attachmentDataItem(context, const Icon(MaterialIcons.headset, size: 30, color: Colors.white), "Audio", Colors.orange, 4),
                _attachmentDataItem(context, const Icon(Icons.attach_money, size: 30, color: Colors.white), "Payment", Colors.teal, 5),
                _attachmentDataItem(context, const Icon(Icons.videocam, size: 30, color: Colors.white), "Room", Colors.indigo, 6),
                _attachmentDataItem(context, const Icon(Icons.location_on, size: 30, color: Colors.white), "Location", Colors.green[700], 7),
                _attachmentDataItem(context, const Icon(Icons.person, size: 30, color: Colors.white), "Contact", Colors.blue[700], 8)
              ],
            ),
          ),
        );
      },
    );
  }

  _attachmentDataItem(BuildContext context, Icon icons, String name, colors, int index) {
    return Column(children: [
      GestureDetector(
          onTap: () {
            if (index == 5) {
              finish(context);
              //CGPaymentScreen().launch(context);
            } else {
              finish(context);
            }
          },
          child: CircleAvatar(backgroundColor: colors, radius: 30, child: icons)),
      8.height,
      Material(child: Text(name, style: const TextStyle(fontSize: 14)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double imageSize = constraints.maxWidth * 0.4;
          return
          SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xffece5dd),
              appBar: AppBar(
                backgroundColor: Colors.pink,
                titleSpacing: 0,
                title: InkWell(
                  onTap: () {
                    //CGProfileScreen(image: widget.user).launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        foregroundColor: Colors.pink,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(widget.user!.avatarUrl!),
                      ),
                      const SizedBox(width: 8.0),
                      Text(widget.user!.name.validate(),
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    finish(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white)),
                  IconButton(onPressed: () {},
                      icon: const Icon(Icons.videocam, color: Colors.white)),
                  const Icon(Icons.more_vert, color: Colors.white),
                  const SizedBox(width: 10)
                ],
              ),
              body: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/robot.json',
                                height: imageSize
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Hey!!',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                            Text('Say Hi to ${widget.user?.name}',
                                style: const TextStyle(fontSize: 18, color: Colors.pink, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      _buildSendMessageWidget(),
                    ],
                  )
              ),
            ),
          );
        }
    );
  }
}
