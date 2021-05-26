






import 'package:filter_list/filter_list.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '검색',
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500),
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text('키워드 검색'),
            ),



            Divider(
              thickness: 2,
              indent: 2,
              endIndent: 2,
            ),




          ],




        ),






      ),



    );




  }





}

