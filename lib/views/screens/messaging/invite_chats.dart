import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:message_app/views/screens/messaging/chats.dart';
import 'package:message_app/views/screens/messaging/select_contact.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {

  var haveChats=false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: haveChats ? FloatingActionButton(onPressed: (){},
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          child: const Icon(CupertinoIcons.chat_bubble_2, color: Colors.white, size: 40),
        ) : null,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Messaging',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black.withOpacity(0.8), size: 30,),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black, size: 30,),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(50, 50),
            child: ColoredBox(
              color: Colors.pink,
              child: TabBar(
                labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.w500),
                indicator: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Chats"),
                        const SizedBox(width: 5),
                        if(haveChats) const CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.pink,
                          radius: 10,
                          child: Text("3", style: TextStyle(fontSize: 14),),
                        )
                      ],
                    ),
                  ),
                  const Tab(text: 'Calls'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
          !haveChats ? _buildChatsTab(context) : const Chats(),
          const Center(child: Text("Calls tab content here")),]
        ),
        bottomNavigationBar: _buildBottomNavigationBar()
      ),
    );
  }

  Widget _buildChatsTab(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageSize = constraints.maxWidth * 0.4; //For responsiveness
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Lottie.asset(
                'assets/robot.json',
                height: imageSize
              ),
              const SizedBox(height: 20),
              const Text(
                'Hey!!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              TextButton(
               onPressed: () { 
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CGSelectContactScreen()));
               },
               child: Text( 'Tap to start a new chat',
                style: TextStyle(fontSize: 19, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        haveChats=true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Invite Friends', style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Make a call', style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 16)),
                  ),
                ],
              ),
              const Spacer()
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    double iconSize=30;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(OctIcons.home, size: iconSize),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.compass, size: iconSize),
          label: 'Navigation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline_outlined, size: iconSize+5),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(ZondIcons.film, size: iconSize),
          label: 'Reels',
        ),
        BottomNavigationBarItem(
          icon: Icon(IonIcons.chatbubble_ellipses, size: iconSize),
          label: 'Chats',
        ),
      ],
    );
  }
}