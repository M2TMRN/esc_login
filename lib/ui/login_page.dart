import 'dart:async';

import 'package:esc_login_game/utils/app_colors.dart';
import 'package:esc_login_game/utils/constants.dart';
import 'package:esc_login_game/utils/keys.dart' as keys;
import 'package:esc_login_game/utils/solution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hardware_buttons/hardware_buttons.dart';

import 'scanner_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormMode { LOGIN, FORGOT_PASSWORD }

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordFormController = TextEditingController();

  FormMode _formMode = FormMode.LOGIN;

  List<bool> _correct;
  List<String> _current;

  bool _isLoginButtonEnabled = false;

  StreamSubscription<HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<LockButtonEvent> _lockButtonSubscription;
  StreamSubscription<VolumeButtonEvent> _volumeButtonSubscription;

  @override
  void initState() {
    _correct = [false, false, false];
    _current = ['', '', ''];

    _homeButtonSubscription = homeButtonEvents.listen((event) {
      setState(() {
        _onBackPressed();
      });
    });
    _lockButtonSubscription = lockButtonEvents.listen((event) {
      setState(() {
        _onBackPressed();
      });
    });
    _volumeButtonSubscription = volumeButtonEvents.listen((event) {
      setState(() {
        _onBackPressed();
      });
    });
    super.initState();
  }

  void _changeFormToAlternative() {
    if (_formMode == FormMode.FORGOT_PASSWORD) return;
    _formKey.currentState.reset();
    setState(() {
      _formMode = FormMode.FORGOT_PASSWORD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        key: keys.scaffoldKey,
        backgroundColor: BLACK_COLOR,
        body: Form(
          key: _formKey,
          child: Align(
            alignment: _formMode == FormMode.FORGOT_PASSWORD
                ? Alignment.topCenter
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _showPasswordInput(),
                  _showLoginButton(),
                  _showForgotPasswordButton(),
                  _showQuestionsBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: ListTile(
        title: Text(PASSWORD,
            style: TextStyle(fontSize: BIG_LETTERS_SIZE, color: RED_COLOR)),
        subtitle: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          cursorColor: RED_COLOR,
          style: TextStyle(fontSize: BIG_LETTERS_SIZE),
          decoration: _inputDecoration(RED_COLOR),
          controller: _passwordFormController,
          validator: (value) =>
              value.isEmpty || value.isNotEmpty ? PASSWORD_NOT_CORRECT : null,
        ),
        trailing: Icon(
          Icons.lock,
          color: RED_COLOR,
          size: 50,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(Color color, {Icon icon}) {
    return InputDecoration(
      icon: icon,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: color),
      ),
    );
  }

  Widget _showLoginButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: BIG_LETTERS_SIZE * 2,
          width: double.infinity,
          child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: _color(_isLoginButtonEnabled)),
                  borderRadius: BorderRadius.circular(20.0)),
              color: BLACK_COLOR,
              child: Text('Login',
                  style: TextStyle(
                      fontSize: BIG_LETTERS_SIZE,
                      color: _color(_isLoginButtonEnabled))),
              onPressed: () {
                if (_isLoginButtonEnabled)
                  navigate(context, ScannerPage());
                else if (_formKey.currentState.validate()) {}
              }),
        ));
  }

  Widget _showForgotPasswordButton() {
    return FlatButton(
      child: Text(FORGOT_PASSWORD,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: MIDDLE_LETTERS_SIZE, fontWeight: FontWeight.w300)),
      onPressed: _changeFormToAlternative,
    );
  }

  Widget _showQuestionsBody() {
    if (_formMode == FormMode.FORGOT_PASSWORD) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            _questionWidget(0),
            _questionWidget(1),
            _questionWidget(2),
          ],
        ),
      );
    }
    return Container(height: 0.0);
  }

  void navigate(BuildContext context, Widget action) {
    Navigator.push(
      keys.scaffoldKey.currentContext,
      MaterialPageRoute(builder: (context) => action),
    );
  }

  Widget _questionWidget(int ind) {
    var iconCorrect = _icon(_correct[ind]);
    var colorCorrect = _color(_correct[ind]);
    return ListTile(
      title: Text(
        QUESTION[ind],
        style: TextStyle(fontSize: BIG_LETTERS_SIZE),
      ),
      subtitle: TextFormField(
          style: TextStyle(fontSize: BIG_LETTERS_SIZE),
          maxLines: 1,
          obscureText: false,
          autofocus: false,
          cursorColor: colorCorrect,
          decoration: _inputDecoration(colorCorrect, icon: iconCorrect),
          onChanged: (value) {
            setState(() {
              _current[ind] = value;
              for (int i = 0; i < 3; i++)
                _correct[i] = _current[i].isNotEmpty &&
                    _current[i].toLowerCase().trim() == ANSWER[i];
              _isLoginButtonEnabled = _checkCorrect();
              iconCorrect = _icon(_correct[ind]);
              colorCorrect = _color(_correct[ind]);
            });
          }),
    );
  }

  Widget _icon(bool correct) {
    return !correct
        ? Icon(Icons.clear, color: RED_COLOR, size: BIG_LETTERS_SIZE)
        : Icon(Icons.check, color: GREEN_COLOR, size: BIG_LETTERS_SIZE);
  }

  Color _color(bool correct) {
    return correct ? GREEN_COLOR : RED_COLOR;
  }

  bool _checkCorrect() {
    return _correct[0] && _correct[1] && _correct[2];
  }

  @override
  void dispose() {
    super.dispose();
    _formMode = FormMode.LOGIN;
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
    _volumeButtonSubscription?.cancel();
    _checkCorrect();
  }
}
