











import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stgrowgrow/state/authstate.dart';
import 'package:stgrowgrow/widgets/title_text.dart';


class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {


  TextEditingController _userName;
  TextEditingController _bio;
  TextEditingController _summary;




  final GlobalKey<ScaffoldMessengerState> _scaffodKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    _userName = TextEditingController();
    _bio = TextEditingController();
    _summary = TextEditingController();

    var state = Provider.of<AuthState>(context, listen: false);
    _userName.text = state?.userModel?.userName;
    _bio.text = state?.userModel?.bio;
    _summary.text = state?.userModel?.summary;
    super.initState();

  }

  void dispose() {
    _userName.dispose();
    _bio.dispose();
    _summary.dispose();
    super.dispose();

  }

  void _submitButton() {
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel.copyWith(

      userName: state.userModel.userName,
      bio: state.userModel.bio,
      summary: state.userModel.summary,



    );
    if(_userName.text != null && _userName.text.isNotEmpty) {
      model.userName = '@${_userName.text}';

    }
    if (_bio.text != null && _bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_summary.text != null && _summary.text.isNotEmpty) {
      model.summary = _summary.text;
    }

    state.updateUserProfile(model);
    Navigator.of(context).pop();


  }

  Widget _body() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _entry('닉네임', controller: _userName),
        SizedBox(height: 50,width: 50,),
        _entry('한줄요약', controller: _summary),
        SizedBox(height: 50,width: 50,),
        _entry('바이오', controller: _bio),

      ],



    );







  }

  Widget _entry(String title,
      {TextEditingController controller,
        int maxLine = 1,
        bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffodKey,
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: TitleText('프로필 편집'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text('저장',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),

            ),



          ),

        ],





      ),
      body: SingleChildScrollView(
        child: _body(),
      ),


    );

  }

}