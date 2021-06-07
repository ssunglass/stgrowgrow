import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/helper/enum.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/widgets/customloader.dart';

import 'package:stgrowgrow/model/user.dart';
import 'package:stgrowgrow/helper/utility.dart';
import 'package:stgrowgrow/theme/theme.dart';




class SignUp extends StatefulWidget {
  final VoidCallback loginCallback;

  const SignUp({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignUpState();


}

class _SignUpState extends State<SignUp>{


  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  TextEditingController _nicknameController;
  TextEditingController _majorController;
  CustomLoader loader;

  String _selectedDepartment = '인문';
  String _selectedUniv='서울';
  List _univOptions = ['서울','경기','강원','제주','대구/경북','충청','전북/전남'];
  List _departmentOptions = ['인문','공학','사회','교육','자연','의약','예체능'];
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
    _majorController = TextEditingController();
    super.initState();


  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    _nicknameController.dispose();
    _majorController.dispose();
    super.dispose();
  }



  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextButton(
        onPressed: _submitForm,
        child: Text('회원가입', style: TextStyle(color: Colors.blueAccent),),


      ),
    );
  }

  Widget _entryField(String hint,
      {TextEditingController controller,
        bool isPassword = false,
        bool isEmail = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }



  void _submitForm() {
    if (_nameController.text.isEmpty) {
      Utility.customSnackBar(_scaffoldKey, '이름을 입력해주세요');
      return;
    }
    if(_nicknameController.text.isEmpty) {
      Utility.customSnackBar(_scaffoldKey, '닉네임을 입력해주세요');
      return;
    }
    if(_nameController.text.length > 27) {
      Utility.customSnackBar(_scaffoldKey, '이름이 너무 깁니다');
      return;
    }
    if(_majorController.text.isEmpty){
      Utility.customSnackBar(_scaffoldKey, '세부 전공을 입력해주세요');
      return;
    }
    if (_emailController.text == null ||
        _emailController.text.isEmpty ||
        _passwordController.text == null ||
        _passwordController.text.isEmpty ||
        _confirmController.text == null) {
      Utility.customSnackBar(_scaffoldKey, '제대로 입력해주세요');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      Utility.customSnackBar(_scaffoldKey, '비밀번호가 일치하지 않습니다');
      return;
    }



    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);


    UserModel user = UserModel(
      email: _emailController.text.trim().toLowerCase(),
      nickName: _nicknameController.text,
      summary: '한줄요약',
      displayName: _nameController.text,
      department: _selectedDepartment,
      major: _majorController.text,
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


 Widget _departmentDropDown(BuildContext context ) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('전공분야'),
            DropdownButton(
                value: _selectedDepartment,
                items: _departmentOptions
                          .map(
                        (department) => DropdownMenuItem(
                          child: Text(department),
                          value: department,
                        ),
                )
                .toList(),
              onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
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
      height: context.height -88,
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
            _departmentDropDown(context),
            _entryField('세부전공 ps.xx학과이면 xx만 적어주세요', controller: _majorController),
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





