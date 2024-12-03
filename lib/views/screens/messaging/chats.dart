import 'package:flutter/material.dart';
import '../../../constants.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: Container(
            decoration: chat["status"] ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.pink,
                    width: 2)) : null,
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(chat["avatar"]),
            ),
          ),
          title: Row(
            children: [
              Text(chat["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
              if(chat["isVerified"])
                Image.asset('assets/verified.png', height: 15, width: 15)
            ],
          ),
          subtitle: Row(
            children: [
              if(!chat["received"])
                if(chat["sent"])
                  Image.asset("assets/tick.png", height: 16, width: 16, color: Colors.grey),
                if(chat["receivedByThem"])
                  Image.asset("assets/seen.png", height: 20, width: 20, color: Colors.grey,),
                if(chat["seen"])
                  Image.asset("assets/seen.png", height: 20, width: 20, color: Colors.blue),
              if(!chat["received"])
                const SizedBox(width: 4),
              Text(
                chat["received"] ? chat["message"].toString().length < 30 ? chat["message"] :"${chat["message"].toString().substring(0,30)}..." : chat["message"].toString().length < 25 ? chat["message"] :"${chat["message"].toString().substring(0,25)}...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chat["time"],
                style: TextStyle(
                  color: chat["unread"]!=0 ? Colors.pink : Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 9),
              if(chat["unread"]!=0)
                  SizedBox(
                    height: 17,
                    width: 17,
                    child: CircleAvatar(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      child: Text(chat["unread"].toString(), style: const TextStyle(fontSize: 12),),
                    ),
                  )
            ],
          ),
        );
      },
    );
  }
}
