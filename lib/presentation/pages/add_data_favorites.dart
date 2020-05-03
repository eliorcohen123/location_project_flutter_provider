import 'package:flutter/material.dart';
import 'package:locationprojectflutter/others/my_media_query.dart';

class AddDataFavorites extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList;

  AddDataFavorites(
      {Key key, this.nameList, this.addressList, this.latList, this.lngList})
      : super(key: key);

  @override
  _AddDataFavoritesState createState() => _AddDataFavoritesState();
}

class _AddDataFavoritesState extends State<AddDataFavorites> {
  final textName = TextEditingController();
  final textAddress = TextEditingController();
  final textLat = TextEditingController();
  final textLng = TextEditingController();
  final textPhoto = TextEditingController();

  @override
  void initState() {
    super.initState();

    textName.text = widget.nameList;
    textAddress.text = widget.addressList;
    textLat.text = widget.latList.toString();
    textLng.text = widget.lngList.toString();
  }

  @override
  void dispose() {
    super.dispose();

    textName.dispose();
    textAddress.dispose();
    textLat.dispose();
    textLng.dispose();
    textPhoto.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.grey,
            body: SingleChildScrollView(
              child: Center(
                  child: Container(
                width: MyMediaQuery().widthMediaQuery(context, 300),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 10),
                    ),
                    Row(
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: MyMediaQuery().widthMediaQuery(context, 30),
                          height: MyMediaQuery().heightMediaQuery(context, 30),
                          child: RaisedButton(
                            color: Colors.grey,
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MyMediaQuery().widthMediaQuery(context, 230),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 10),
                    ),
                    Text(
                      'Add Place',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 20),
                    ),
                    Text(
                      'Name',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 2),
                    ),
                    _editText(textName),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 10),
                    ),
                    Text(
                      'Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 2),
                    ),
                    _editText(textAddress),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 10),
                    ),
                    Text(
                      'Coordinates',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 2),
                    ),
                    _editText(textLat),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 2),
                    ),
                    _editText(textLng),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 10),
                    ),
                    Text(
                      'Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 2),
                    ),
                    _editText(textPhoto),
                    SizedBox(
                      height: MyMediaQuery().heightMediaQuery(context, 20),
                    ),
                    RaisedButton(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      onPressed: () => null,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF5e7974),
                                Color(0xFF6494ED),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: const Text(
                          'Add Your Place',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            )));
  }

  _editText(TextEditingController textEditingController) {
    return Container(
      color: Color(0xff778899),
      padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      child: TextField(
        style: TextStyle(color: Colors.lightGreenAccent),
        controller: textEditingController,
      ),
    );
  }
}
