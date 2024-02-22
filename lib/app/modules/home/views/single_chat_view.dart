import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SingleChatView extends StatefulWidget {
  const SingleChatView({super.key});

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  var controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.profile_add,
            ),
          ),
        ],
        backgroundColor: const Color(0xDBF14D6E),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Iconsax.menu,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var user = controller.chatUsers[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          user.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          user.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              if (index != 4) {
                                controller.startPersonalVideoCall(user);
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  message: '${user.userName} is offline',
                                  duration: const Duration(seconds: 1),
                                  isDismissible: true,
                                ));
                              }
                            },
                            icon: Icon(
                              index == 4 ? Iconsax.video_slash : Iconsax.video5,
                              size: 20,
                            ),
                          ),
                        ),
                        leading: Badge(
                          largeSize: 10,
                          smallSize: 15,
                          alignment: Alignment.bottomRight,
                          backgroundColor:
                              index == 4 ? Colors.red : Colors.green,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                CachedNetworkImageProvider(user.profileUrl),
                            backgroundColor: Colors.black,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    itemCount: controller.chatUsers.length,
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.isLoading.value,
              child: Dialog.fullscreen(
                backgroundColor: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
