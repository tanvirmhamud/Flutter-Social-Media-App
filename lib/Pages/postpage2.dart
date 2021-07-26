import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/Provider/firebasedata.dart';
import 'package:flutter_social_media/Provider/myday.dart';
import 'package:flutter_social_media/Widgets/allpostsliver.dart';
import 'package:flutter_social_media/Widgets/drawer.dart';
import 'package:flutter_social_media/Widgets/myday.dart';
import 'package:provider/provider.dart';
import '../Provider/likefunction.dart';

class PostPage2 extends StatefulWidget {
  const PostPage2({Key? key}) : super(key: key);

  @override
  _PostPage2State createState() => _PostPage2State();
}

class _PostPage2State extends State<PostPage2> {
  @override
  Widget build(BuildContext context) {
    final firebasedata = Provider.of<FirebasedataProvider>(context);
    final likefunction = Provider.of<Likeprovider>(context);
    final mydayfunction = Provider.of<MydayProvider>(context);
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: firebasedata.getuserpostfirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.grey[300],
                drawer: DrawerPage(),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      backgroundColor: Colors.white,
                      floating: true,
                      title: Text(
                        "Social App",
                        style: TextStyle(color: Colors.black),
                      ),
                      expandedHeight: 280.0,
                      flexibleSpace:
                          Mydaypagesliver(mydayfunction: mydayfunction),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var postdocumets = snapshot.data!.docs[index];
                          return Allpostshow(
                              postdocumets: postdocumets,
                              likefunction: likefunction);
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}





// class Delegate extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;
//   const Delegate({required this.expandedHeight});
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     // TODO: implement build
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.visible,
//       children: [
//         buildAppBar(shrinkOffset),
//         buildBackground(shrinkOffset),
//       ],
//     );
//   }

//   double appear(double shrinkOffset) => shrinkOffset / expandedHeight;
//   double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

//   Widget buildAppBar(double shrinkOffset) => Opacity(
//         opacity: appear(shrinkOffset),
//         child: AppBar(
//           title: Text("jsnksjbk"),
//           centerTitle: true,
//         ),
//       );

//   Widget buildBackground(double shrinkOffset) => Opacity(
//         opacity: disappear(shrinkOffset),
//         child: Image.network(
//           'https://source.unsplash.com/random?mono+dark',
//           fit: BoxFit.cover,
//         ),
//       );

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

//   @override
//   double get minExtent => kToolbarHeight + 30;
// }
