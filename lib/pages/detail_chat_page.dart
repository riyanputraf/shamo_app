import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shamo_app/models/message_model.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/providers/auth_provider.dart';
import 'package:shamo_app/services/message_service.dart';
import 'package:shamo_app/theme.dart';
import 'package:shamo_app/widgets/chat_buble.dart';

import '../utils/url_util.dart';

class DetailChatPage extends StatefulWidget {
  DetailChatPage({super.key, required this.product});

  ProductModel product;

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController messageController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleAddMessage() async {
      await MessageService().addMessage(
        authProvider.user,
        true,
        messageController.text,
        widget.product,
      );

      setState(() {
        widget.product = UnintializedProductModel();
        messageController.text = '';
      });
    }

    Widget productPreview() {
      return Container(
        width: 225.w,
        height: 74.h,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(
          bottom: 20.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor5,
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: updateLocalhostUrl(widget.product.galleries[0].url),
                width: 54.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  size: 54.w,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.name,
                    style: primaryTextStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: regular,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.product = UnintializedProductModel();
                });
              },
              child: Image.asset(
                'assets/button_close.png',
                width: 22.w,
              ),
            ),
          ],
        ),
      );
    }

    Widget chatInput() {
      return Container(
        margin: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product is UnintializedProductModel
                ? const SizedBox()
                : productPreview(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: messageController,
                        style: primaryTextStyle.copyWith(
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type Message...',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: handleAddMessage,
                  child: Image.asset(
                    'assets/button_send.png',
                    width: 45.w,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
          stream: MessageService()
              .getMessagesByUserId(userId: authProvider.user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin.w,
                ),
                children: snapshot.data!
                    .map(
                      (MessageModel message) => ChatBubble(
                        isSender: message.isFromUser,
                        text: message.message,
                        product: message.product,
                      ),
                    )
                    .toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    }

    return Scaffold(
      backgroundColor: bgColor3,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: bgColor1,
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              size: 24.w,
            ),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/image_shop_online.png',
                width: 50.w,
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shoe Store',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'Online',
                    style: secondaryTextStyle.copyWith(
                      fontWeight: light,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: chatInput(),
      body: content(),
    );
  }
}
