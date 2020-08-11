import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/chat_settings_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/simple_image_crop.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsChatProvider>(
      builder: (context, results, child) {
        return ChatSettingsProv();
      },
    );
  }
}

class ChatSettingsProv extends StatefulWidget {
  @override
  _ChatSettingsProvState createState() => _ChatSettingsProvState();
}

class _ChatSettingsProvState extends State<ChatSettingsProv> {
  final Firestore _firestore = Firestore.instance;
  TextEditingController _controllerNickname, _controllerAboutMe;
  String _id = '';
  final FocusNode _focusNodeNickname = FocusNode();
  final FocusNode _focusNodeAboutMe = FocusNode();
  var document;
  SettingsChatProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<SettingsChatProvider>(context, listen: false);

    _initControllerTextEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          _mainBody(),
          _loading(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: Color(0xFFE9FFFF),
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _mainBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _circleAvatar(),
          _textFieldsData(),
          _buttonUpdate(),
        ],
      ),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
    );
  }

  Widget _circleAvatar() {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            (_provider.avatarImageFileGet == null)
                ? (_provider.photoUrlGet != ''
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: _provider.photoUrlGet != null
                                ? CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xfff5a623),
                                    ),
                                  )
                                : Container(),
                            width:
                                ResponsiveScreen().widthMediaQuery(context, 90),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 50),
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: _provider.photoUrlGet != null
                              ? _provider.photoUrlGet
                              : '',
                          width:
                              ResponsiveScreen().widthMediaQuery(context, 90),
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 90),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(45.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 90.0,
                        color: Color(0xffaeaeae),
                      ))
                : Material(
                    child: Image.file(
                      _provider.avatarImageFileGet,
                      width: 90.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(45.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Color(0xff203152).withOpacity(0.5),
              ),
              onPressed: () => _newTaskModalBottomSheet(context),
              padding: EdgeInsets.all(30.0),
              splashColor: Colors.transparent,
              highlightColor: Color(0xff203152),
              iconSize: 30.0,
            ),
          ],
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(20.0),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            'Nickname',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Color(0xff203152),
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Color(0xff203152),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cool Man',
                contentPadding: EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Color(0xffaeaeae)),
              ),
              controller: _controllerNickname,
              onChanged: (value) {
                _provider.nickname(value);
              },
              focusNode: _focusNodeNickname,
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        Container(
          child: Text(
            'About me',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Color(0xff203152),
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Color(0xff203152),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Fun, like travel and play PES...',
                contentPadding: EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Color(0xffaeaeae)),
              ),
              controller: _controllerAboutMe,
              onChanged: (value) {
                _provider.aboutMe(value);
              },
              focusNode: _focusNodeAboutMe,
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buttonUpdate() {
    return Container(
      child: FlatButton(
        onPressed: _handleUpdateData,
        child: Text(
          'UPDATE',
          style: TextStyle(fontSize: 16.0),
        ),
        color: Color(0xff203152),
        highlightColor: Color(0xff8d93a0),
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      ),
      margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
    );
  }

  Widget _loading() {
    return Positioned(
      child: _provider.loadingGet
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xfff5a623),
                  ),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void _initControllerTextEditing() async {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _id = _provider.sharedGet.getString('id') ?? '';
        _provider.nickname(_provider.sharedGet.getString('nickname') ?? '');
        _provider.aboutMe(_provider.sharedGet.getString('aboutMe') ?? '');
        _provider.photoUrl(_provider.sharedGet.getString('photoUrl') ?? '');
      },
    ).then(
      (value) => {
        document = _firestore.collection('users').document(_id),
        document.get().then(
          (document) {
            if (document.exists) {
              _provider.nickname(document['nickname']);
              _provider.aboutMe(document['aboutMe']);
              _provider.photoUrl(document['photoUrl']);
            }
          },
        ).then((value) => {
              _controllerNickname =
                  TextEditingController(text: _provider.nicknameGet),
              _controllerAboutMe =
                  TextEditingController(text: _provider.aboutMeGet),
            }),
      },
    );
  }

  void _getImage(bool take) async {
    File image;
    if (take) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleImageCrop(
            image: image,
          ),
        ),
      );

      _provider.avatarImageFile(image);
      _provider.loading(true);

      Navigator.pop(context, false);

      _uploadFile();
    }
  }

  void _uploadFile() async {
    StorageReference reference = FirebaseStorage.instance.ref().child(_id);
    StorageUploadTask uploadTask =
        reference.putFile(_provider.avatarImageFileGet);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then(
      (value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then(
            (downloadUrl) {
              _provider.photoUrl(downloadUrl);
              _firestore.collection('users').document(_id).updateData(
                {
                  'nickname': _provider.nicknameGet,
                  'aboutMe': _provider.aboutMeGet,
                  'photoUrl': _provider.photoUrlGet,
                },
              ).then(
                (data) {
                  _provider.loading(false);

                  Fluttertoast.showToast(
                    msg: "Upload success",
                  );
                },
              ).catchError(
                (err) {
                  _provider.loading(false);

                  Fluttertoast.showToast(
                    msg: err.toString(),
                  );
                },
              );
            },
            onError: (err) {
              _provider.loading(false);

              Fluttertoast.showToast(
                msg: 'This file is not an image',
              );
            },
          );
        } else {
          _provider.loading(false);

          Fluttertoast.showToast(
            msg: 'This file is not an image',
          );
        }
      },
      onError: (err) {
        _provider.loading(false);

        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _handleUpdateData() {
    _focusNodeNickname.unfocus();
    _focusNodeAboutMe.unfocus();

    _provider.loading(true);

    _firestore.collection('users').document(_id).updateData(
      {
        'nickname': _provider.nicknameGet,
        'aboutMe': _provider.aboutMeGet,
        'photoUrl': _provider.photoUrlGet,
      },
    ).then(
      (data) {
        _provider.loading(false);

        Fluttertoast.showToast(
          msg: "Update success",
        );
      },
    ).catchError(
      (err) {
        _provider.loading(false);

        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _newTaskModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: Wrap(
                  children: [
                    ListTile(
                      title: Center(
                        child: Text('Take A Picture'),
                      ),
                      onTap: () => _getImage(true),
                    ),
                    ListTile(
                      title: Center(
                        child: Text('Open A Gallery'),
                      ),
                      onTap: () => _getImage(false),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
