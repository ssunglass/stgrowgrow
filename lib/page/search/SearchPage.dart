






import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/state/searchstate.dart';
import 'package:stgrowgrow/theme/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.scaffoldKey,}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;


  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController textController;

  List _departmentOptions = ['인문','공학','사회','교육','자연','의약','예체능','기타'];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });

    super.initState();

  }



  Widget _searchField() {
    final state = Provider.of<SearchState>(context);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 20,right: 20),
        child: TextField(
          onChanged: (text) {
            state.filterBy(text);
          },
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            hintText: 'Search..',
            fillColor: Colors.grey,
            filled: true,
            focusColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, ),
            suffixIcon: Container(

              child: IconButton(
                icon: Icon(Icons.search),

              ),

            ),
          ),
        )


    );


  }


  Widget _filterDepart() {
    return FilterListWidget(
      listData: _departmentOptions,
      hideSearchField: true,
      hideHeaderText: true,
      choiceChipLabel: (item) {
        return item;
      },


    );

  }


  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20,top: 15 ),
              child:Text(
                '검색',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),),
            Container(
              margin: EdgeInsets.only(left: 20,top: 15 ,bottom: 10),
              child:Text(
                '키워드 검색',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),),

            Container(
              child: _searchField(),
            ),

            Container(
              margin: EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Divider(
                thickness: 3,

              ),

            ),













          ],

        ),






      ),





    );

  }
}



