import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:message_app/models/chat_model.dart';
import 'package:message_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:message_app/views/screens/messaging/message_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CGSelectContactScreen extends StatefulWidget {
  final ChatModel? data;
  final bool? isCallScreen;

  const CGSelectContactScreen({super.key, this.isCallScreen, this.data});

  @override
  State<CGSelectContactScreen> createState() => _CGSelectContactScreenState();
}

class _CGSelectContactScreenState extends State<CGSelectContactScreen> {

  final TextEditingController searchController = TextEditingController();

  var isSearching=false;

  List<Contact> contacts = [];
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
    });

    if (await Permission.contacts.request().isGranted) {
      try {
        List<Contact> fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          contacts = fetchedContacts;
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error fetching contacts: $e");
        }
      }
    } else {
      if (kDebugMode) {
        print("Permission denied to access contacts.");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (isSearching) {
            FocusScope.of(context).unfocus();
            setState(() {
              isSearching = false;
              searchController.clear();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  finish(context);
                }),
            backgroundColor: Colors.pink,
            title: !isSearching ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select contact", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18)),
                Skeletonizer(
                  enabled: isLoading,
                  child: Text(
                    "${contacts.length} Contacts",
                    style: boldTextStyle(size: 14, color: Colors.white.withOpacity(0.8)),
                  ),
                )
              ],
            ) : TextField(
              controller: searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (query) {
                // Add your search logic here
                if (kDebugMode) {
                  print("Searching for: $query");
                }
              },
            ),
            actions: [
              !isSearching ? IconButton(icon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)), onPressed: () {
                    setState(() {
                      isSearching=true;
                    });
              }) : const SizedBox(),
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [const PopupMenuItem(value: 1, child: Text("Invite a friend")), const PopupMenuItem(value: 2, child: Text("Contacts")), const PopupMenuItem(value: 3, child: Text("Refresh")), const PopupMenuItem(value: 4, child: Text("Help"))])
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      //CGNewGroupAndBroadcastScreen(isNewGroup: true).launch(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(radius: 24, backgroundColor: Colors.pink, child: Icon(Icons.group, color: Colors.white, size: 28.0)),
                          18.width,
                          Text("New group", style: boldTextStyle(size: 18))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(radius: 24, backgroundColor: Colors.pink, child: Icon(Icons.group, color: Colors.white, size: 28.0)),
                            18.width,
                            Text("New contact", style: boldTextStyle(size: 18)),
                          ],
                        ),
                        IconButton(
                            icon: const Icon(Icons.qr_code, color: Colors.pink),
                            onPressed: () {
                              //CGqrScanScreen().launch(context);
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text("Contacts on Wikolo", style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500)),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: fav.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            finish(context);
                            CGMessageScreen(user: User(id: index, avatarUrl: fav[index].avatarUrl, name: fav[index].name)).launch(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(backgroundImage: NetworkImage(fav[index].avatarUrl!), radius: 24, backgroundColor: Colors.pink),
                                    18.width,
                                    Text(fav[index].name!, style: boldTextStyle(size: 18)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text("Invite to Wikolo", style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500)),
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : contacts.isEmpty
                      ? const Center(child: Text("No contacts found"))
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = contacts[index];
                        return InkWell(
                          onTap: () {
                            finish(context);
                            CGMessageScreen(user: User(id: index, avatarUrl: fav[index].avatarUrl, name: fav[index].name)).launch(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(backgroundImage: NetworkImage("https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?rs=1&pid=ImgDetMain"), radius: 24, backgroundColor: Colors.pink),
                                    18.width,
                                    Text( contact.displayName.length > 17 ? contact.displayName.substring(0,17) : contact.displayName, style: boldTextStyle(size: 18)),
                                  ],
                                ),
                                const Spacer(),
                                TextButton(onPressed: (){}, child: const Text("Invite", style: TextStyle(color: Colors.pink, fontSize: 18),))
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
