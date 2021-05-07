import 'dart:math';
import 'dart:convert';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/widgets/customloader.dart';
import 'package:stgrowgrow/widgets/customwidgets.dart';
import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:http/http.dart' as http;




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

  String _selectedMajor = '인문';
  String _selectedUniv='서울';
  List _univOptions = ['서울','경기','강원','제주','대구/경북','충청','전북/전남'];
  List _majorOptions = ['인문','공학','사회','교육','자연','의약','예체능'];
  List<String> interestList = [
    "코딩",
    "마케팅",
    "음악",
    "요리",
    "광고"
  ];

  List<String> selectedinterestList = [];

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("관심분야"),
            content: MultiSelectChip(
              interestList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedinterestList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("선택"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

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

  Widget _entryField(String hint,
      {TextEditingController controller,
        bool isPassword = false,
        bool isEmail = false})  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.blueAccent),

          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20,)

        ),

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
      major: _selectedMajor,
      interestList: selectedinterestList,
      university: _selectedUniv,




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


 Widget _majorDropDown(BuildContext context ) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('전공분야'),
            DropdownButton(
                value: _selectedMajor,
                items: _majorOptions
                          .map(
                        (major) => DropdownMenuItem(
                          child: Text(major),
                          value: major,
                        ),
                )
                .toList(),
              onChanged: (value) {
                  setState(() {
                    _selectedMajor = value;
                  });
              },
            )
          ],
        ),
      );

 }

  Widget _univDropDown(BuildContext context ) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('대학지역'),
          DropdownButton(
            value: _selectedUniv,
            items: _univOptions
                .map(
                  (univ) => DropdownMenuItem(
                child: Text(univ),
                value: univ,
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedUniv = value;
              });
            },
          )
        ],
      ),
    );

  }

 Widget _choicechip(BuildContext context ) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("클릭"),
            onPressed: () => _showReportDialog(),
          ),
          Text(selectedinterestList.join(" , ")),
        ],
      ),
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
            _entryField('Name', controller: _nameController),
            _entryField('NickName', controller: _nicknameController),
            //_dropdownformbutton(context),
            _choicechip(context),
            _entryField('Enter email',
                controller: _emailController, isEmail: true),
            _majorDropDown(context),
            _univDropDown(context),
            // _entryFeild('Mobile no',controller: _mobileController),
            _entryField('Enter password',
                controller: _passwordController, isPassword: true),
            _entryField('Confirm password',
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





class MultiSelectChip extends StatefulWidget {
  final List<String> interestList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.interestList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices =[];

    widget.interestList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}





