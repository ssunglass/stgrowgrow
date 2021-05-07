






import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/model/keyword.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:stgrowgrow/helper/utility.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.scaffoldKey,}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;


  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });

    super.initState();
  }








  @override
  Widget build(BuildContext context) {
    // final state = Provider.of<SearchState>(context);
    // final userlist = state.userlist;
    // final keylist = state.keyList;
    // return Scaffold(
    //   appBar: TextField(
    //     scaffoldKey: widget.scaffoldKey,
    //     icon: AppIcon.settings,
    //     onSearchChanged: (text) {
    //       state.filterBy(text,text);
    //     },
    //   ),
    //   body: RefreshIndicator(
    //     onRefresh: () async {
    //       state.getDataFromDatabase();
    //       return Future.value(true);
    //     },
    //     child: ListView.separated(
    //    addAutomaticKeepAlives: false,
    //    physics: BouncingScrollPhysics(),
    //    itemBuilder: (context, index) => _UserTile(user: userlist[index], keyword: keylist[index],),
    //   separatorBuilder: (_, index) => Divider(
    //   height: 0,
    // ),
    // itemCount: userlist?.length ?? 0,
    // ),
    //
    //   ),
    // );



  }





}

//  class _UserTile extends StatelessWidget {
//   const _UserTile({Key key, this.user, this.keyword}) : super(key: key);
//   final UserModel user;
//   final KeyModel keyword;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         kAnalytics.logViewSearchResults(searchTerm: user.userName );
//         Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
//       },
//       title: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Flexible(
//             child: TitleText(user.displayName,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 overflow: TextOverflow.ellipsis),
//           ),
//           SizedBox(width: 3),
//           user.isVerified
//               ? customIcon(
//             context,
//             icon: AppIcon.blueTick,
//             istwitterIcon: true,
//             iconColor: AppColor.primary,
//             size: 13,
//             paddingIcon: 3,
//           )
//               : SizedBox(width: 0),
//         ],
//       ),
//       subtitle: Text(user.userName),
//     );
//   }
// }