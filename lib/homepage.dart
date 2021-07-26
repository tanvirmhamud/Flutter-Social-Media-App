import 'package:flutter/material.dart';
import 'package:flutter_social_media/Pages/Profilepage.dart';
import 'package:flutter_social_media/Pages/chat.dart';
import 'package:flutter_social_media/Pages/friendrequest.dart';
import 'package:flutter_social_media/Pages/notifaction.dart';
import 'package:flutter_social_media/Pages/postadd.dart';
import 'package:flutter_social_media/Pages/postpages.dart';
import 'package:flutter_social_media/Widgets/appbar.dart';
import 'package:flutter_social_media/Widgets/bottomnavigation.dart';
import 'package:flutter_social_media/Widgets/drawer.dart';
import 'package:flutter_social_media/Widgets/useremail.dart';
import 'package:flutter_social_media/Pages/postpage2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PageController? _pageController;
  int selectpagetab = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuseremail();
    _pageController = PageController();
  }

  getuseremail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      Useremail.useremailget = sharedPreferences.getString('email')!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButomnavigationBarpage(
        selectedtab: selectpagetab,
        onpressed: (num) {
          _pageController!.animateToPage(num,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic);
        },
      ),

      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: Text(
      //     "IGEKU",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   actions: [
      //     Container(
      //       child: Card(
      //         elevation: 2,
      //         child: IconButton(
      //             onPressed: () {},
      //             icon: Icon(
      //               Icons.search_sharp,
      //               color: Colors.black,
      //             )),
      //       ),
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      selectpagetab = value;
                    });
                  },
                  controller: _pageController,
                  children: [
                    // PostPages(),
                    PostPage2(),
                    ChatPage(),
                    PostAddPage(),
                    NotificationPage(),
                    FriendReqPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
