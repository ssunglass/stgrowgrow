import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/page/onboarding.dart';
import 'package:stgrowgrow/state/authstate.dart';




class Welcomepage extends StatefulWidget{
  Welcomepage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();


}

class _WelcomePageState extends State<Welcomepage> {
    Widget _submitButton(){
      return Container(

        child: TextButton(
          onPressed: (){
            var state = Provider.of<AuthState>(context, listen: false );
            Navigator.push(
              context,
                MaterialPageRoute(
                    builder: (context) => Signup(loginCallback: state.getCurrentUser),
            ),
            );
            },
          child: Text('회원가입', style: TextStyle( color: Colors.blueAccent),),

        ),
      );
    }


    Widget _body(){
      return SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => onboarding(),
                    ),
                  );
                  } , child: Text('온보딩', style: TextStyle( color: Colors.blueAccent),),
                )



                Text(
                  '커커와 함께하세요',style: TextStyle( fontSize: 25,color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 20,

                ),
                _submitButton(),
                Text('계정이 이미 있으신가요?', style: TextStyle( color: Colors.blueAccent),
                ),
                InkWell(
                  onTap: () {
                    var state = Provider.of<AuthState>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPage(
                        builder: (context) =>


                      ),
                    );
                    },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2,vertical: 10),
                    child: Text(
                      '로그인',
                      style: TextStyle( color: Colors.black, fontSize: 15),
                    ),

                  ),
                )
              ],
            ),
          ),
      );
    }

    @override
  Widget build(BuildContext context) {
    var state=Provider.of<AuthState>(context,listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
            state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          :

    );

  }


}