import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/page/homepage.dart';
import 'package:stgrowgrow/page/onboarding.dart';
import 'package:stgrowgrow/page/signin.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/page/signup.dart';




class WelcomePage extends StatefulWidget{
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();


}

class _WelcomePageState extends State<WelcomePage> {
    Widget _submitButton(){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,

        child: TextButton(
          onPressed: (){
            var state = Provider.of<AuthState>(context, listen: false );
            Navigator.push(
              context,
                MaterialPageRoute(
                    builder: (context) => SignUp(loginCallback: state.getCurrentUser),
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
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
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
                ),



                Text(
                  '커커와 함께하세요',style: TextStyle( fontSize: 25,color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 20,

                ),
                _submitButton(),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children:<Widget>[
                    Text('이미계정이 있으신가요?'),
                InkWell(
                  onTap: () {
                    var state = Provider.of<AuthState>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignIn(loginCallback: state.getCurrentUser),
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
                ),
                  ],
                ),
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
          : HomePage(),

    );

  }


}