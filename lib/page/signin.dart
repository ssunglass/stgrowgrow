import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';




class SignIn extends StatefulWidget {
  final VoidCallback loginCallback;


  const SignIn({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  CustomLoader loader;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loader = CustomLoader();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _entryField(String hint,
      {TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

 Widget _labelButton(String title, {Function onPressed}) {
    return TextButton(
      onPressed: () {
        if(onPressed != null)
          onPressed();
      },
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );

 }

 Widget _emailLoginButton(BuildContext context) {
    return Container(
      width: fullWidth(context),
      margin: EdgeInsets.symmetric(vertical: 35),
      child: TextButton(
        onPressed: _emailLogin,
        child: Text('로그인'),
      ),
    );
  }


 void _emailLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
    if(state.isbusy) {
      return;
    }
    loader.showLoader(context);
    var isValid = Utility.validateCredentials(
      _scaffoldKey, _emailController.text, _passwordController.text);
    if (isValid) {
      state
         .signIn(_emailController.text, _passwordController.text,
               scaffoldKey: _scaffoldKey)
          .then((status) {
       if (state.user != null) {
         loader.hideLoader();
         Navigator.pop(context);
         widget.loginCallback();
       }else{
         cprint('Unable to login',errorIn: '_emailLoginButton');
         loader.hideLoader();
       }


      });
    }else {
      loader.hideLoader();
    }
  }


  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            _entryField('Enter email', controller: _emailController),
            _entryField('Enter password',
                controller: _passwordController, isPassword: true),
            _emailLoginButton(context),
            SizedBox(height: 20),
            _labelButton('Forget password?', onPressed: () {
              Navigator.of(context).pushNamed('/ForgetPasswordPage');
            }),
            Divider(
              height: 30,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('로그인'),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }


}