import 'package:esc_login_game/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String qr;
  bool camState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        backgroundColor: BLACK_COLOR,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: camState
                      ? Center(
                          child: SizedBox(
                            width: 450.0,
                            height: 450.0,
                            child: QrCamera(
                              onError: (context, error) => Text(
                                error.toString(),
                                style: TextStyle(
                                    color: RED_COLOR,
                                    fontSize: MIDDLE_LETTERS_SIZE),
                              ),
                              qrCodeCallback: (code) {
                                setState(() {
                                  qr = code;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color:
                                          qr == null ? RED_COLOR : GREEN_COLOR,
                                      width: 10.0,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text("Camera inactive",
                              style: TextStyle(
                                  color: GREEN_COLOR,
                                  fontSize: MIDDLE_LETTERS_SIZE)))),
              Text(qr ?? " ",
                  style: TextStyle(
                      fontSize: BIG_LETTERS_SIZE, color: GREEN_COLOR)),
              Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  height: BIG_LETTERS_SIZE * 2,
                  width: double.infinity,
                  child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: GREEN_COLOR),
                          borderRadius: BorderRadius.circular(20.0)),
                      color: BLACK_COLOR,
                      child: Text('Scan',
                          style: TextStyle(
                              fontSize: BIG_LETTERS_SIZE,
                              color: GREEN_COLOR)),
                      onPressed: () {
                        setState(() {
                          camState = !camState;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }
}
