import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/model/user.dart';




class Signup extends StatefulWidget {
  final VoidCallback loginCallback;

  const Signup({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();


}

class _SignupState extends State<Signup>{
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  TextEditingController _nicknameController;
  CustomLoader loader;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    loader = CustomLoader();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _nicknameController = TextEditingController();
    super.initState();


  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller,
        bool isPassword = false,
        bool isEmail = false})  {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword,

      ),

    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: _submitForm,
        child: Text('회원가입', style: TextStyle(color: Colors.blueAccent),),

      ),
    );
  }

  void _googleLogin() {




  }
  
  void _submitForm() {
    if (_nameController.text.isEmpty) {
      customSnackBar(_scaffoldKey, '이름을 입력해주세요');
      return;
    }
    if(_nicknameController.text.isEmpty) {
      customSnackBar(_scaffoldKey, '닉네임을 입력해주세요');
      return;
    }
    if(_nameController.text.length > 27) {
      customSnackBar(_scaffoldKey, '이름이 너무 깁니다');
      return;
    }
    if (_emailController.text == null ||
        _emailController.text.isEmpty ||
        _passwordController.text == null ||
        _passwordController.text.isEmpty ||
        _confirmController.text == null) {
      customSnackBar(_scaffoldKey, '제대로 입력해주세요');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      customSnackBar(_scaffoldKey, '비밀번호가 일치하지 않습니다');
      return;
    }


    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int randomNumber = random.nextInt(8);


    UserModel user = UserModel(
      email: _emailController.text.trim().toLowerCase(),
      nickName: _nicknameController.text.trim(),
      summary: '한줄요약',
      bio: '바이오 적기',
      displayName: _nameController.text.trim(),



      isVerified: false,
    );
    state
       .signUp(
      user,
      password: _passwordController.text,
      scaffoldKey: _scaffoldKey,

    )

    .then((status){
      print(status);
    }).whenComplete(
        (){
          loader.hideLoader();
          if (state.authStatus == AuthStatus.LOGGED_IN){
            Navigator.pop(context);
            widget.loginCallback();

          }
          },
    );






  }





  
  Widget _body(BuildContext context) {
    return Container(
      height: fullHeight(context) - 88,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _entryFeild('Name', controller: _nameController),
            _entryFeild('NickName', controller: _nicknameController),
            _entryFeild('Enter email',
                controller: _emailController, isEmail: true),
            // _entryFeild('Mobile no',controller: _mobileController),
            _entryFeild('Enter password',
                controller: _passwordController, isPassword: true),
            _entryFeild('Confirm password',
                controller: _confirmController, isPassword: true),
            _submitButton(context),

            Divider(height: 30),
            SizedBox(height: 30),
            SizedBox(height: 30),
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
        title: Text('회원가입'),
        
        
        
      ),
      
      body: SingleChildScrollView(child: _body(context),),
    );
    
    
  }
  

}

