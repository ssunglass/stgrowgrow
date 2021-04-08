import 'package:flutter/material.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/widgets/title_text.dart';









import 'package:flutter/cupertino.dart';

class EmptyList extends StatelessWidget{
  EmptyList(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context) -135,
      color: Color.fromRGBO(230, 236, 240, 1.0),
      child: NotifyText(

        title: title,
      ),



    );
  }

}


class NotifyText extends StatelessWidget {
  final String title;
  const NotifyText({Key key, this.title}) :super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title, fontSize: 20, textAlign: TextAlign.center,

        ),



      ],


    );

  }


}