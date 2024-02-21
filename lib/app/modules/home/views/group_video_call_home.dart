import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_call/app/modules/home/controllers/home_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';

class GroupVideoCall extends StatefulWidget {
  const GroupVideoCall({super.key});

  @override
  State<GroupVideoCall> createState() => _GroupVideoCallState();
}

class _GroupVideoCallState extends State<GroupVideoCall> {
  var controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Calls'),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              const Text(
                'Start a Meeting',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Gap(10),
              const Text(
                'Start a new meeting or join using existing channel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/group.png'),
              ),
              const Gap(50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Custom Channel Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  controller: controller.channelNameController,
                ),
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: ElevatedButton(
                  onPressed: () {
                    controller.startvideoCustomChannelVideoCall();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xDBF14D6E),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Join',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    controller.startInstantMeeting();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Create instant Meeting',
                      style: TextStyle(
                        color: Color(0xDBF14D6E),
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
