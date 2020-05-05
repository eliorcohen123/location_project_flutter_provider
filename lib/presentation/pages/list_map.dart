import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong/latlong.dart' as dis;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/models_location/error.dart';
import 'package:locationprojectflutter/data/models/models_location/place_response.dart';
import 'package:locationprojectflutter/data/models/models_location/result.dart';
import 'package:locationprojectflutter/data/models/models_location/user_location.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/pages/add_data_favorites_activity.dart';
import 'package:locationprojectflutter/presentation/pages/map_list_activity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ListMap extends StatefulWidget {
  ListMap({Key key}) : super(key: key);

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  Error _error;
  List<Result> _places;
  bool _searching = true;
  int _valueRadiusText;
  double _valueRadius;
  SharedPreferences _sharedPrefs;
  var _userLocation;
  String _baseUrl = Constants.baseUrl;
  String _API_KEY = Constants.API_KEY;

  @override
  void initState() {
    super.initState();

    _getLocationPermission();
    _initGetSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _searchNearby(_searching, "");
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _btnType('Banks', 'bank'),
                    _btnType('Bars', 'bar|night_club'),
                    _btnType('Beauty', 'beauty_salon|hair_care'),
                    _btnType('Books', 'book_store|library'),
                    _btnType('Bus stations', 'bus_station'),
                    _btnType(
                        'Cars', 'car_dealer|car_rental|car_repair|car_wash'),
                    _btnType('Clothing', 'clothing_store'),
                    _btnType('Doctors', 'doctor'),
                    _btnType('Gas stations', 'gas_station'),
                    _btnType('Gym', 'gym'),
                    _btnType('Jewelries', 'jewelry_store'),
                    _btnType('Parks', 'park|amusement_park|parking|rv_park'),
                    _btnType('Restaurants', 'food|restaurant|cafe|bakery'),
                    _btnType('School', 'school'),
                    _btnType('Spa', 'spa'),
                  ],
                ),
              ),
              _searching
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.separated(
                        itemCount: _places.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dis.Distance _distance = new dis.Distance();
                          final double _meter = _distance(
                              new dis.LatLng(_userLocation.latitude,
                                  _userLocation.longitude),
                              new dis.LatLng(
                                  _places[index].geometry.location.lat,
                                  _places[index].geometry.location.long));
                          return GestureDetector(
                            child: Container(
                              color: Colors.grey,
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 5),
                                        width: double.infinity,
                                        child: const DecoratedBox(
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                        ),
                                      ),
                                      CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 150),
                                        width: double.infinity,
                                        imageUrl: _places[index]
                                                .photos
                                                .isNotEmpty
                                            ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                                                _places[index]
                                                    .photos[0]
                                                    .photoReference +
                                                "&key=$_API_KEY"
                                            : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      SizedBox(
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 5),
                                        width: double.infinity,
                                        child: const DecoratedBox(
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: ResponsiveScreen()
                                        .heightMediaQuery(context, 160),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xAA000000),
                                          const Color(0x00000000),
                                          const Color(0x00000000),
                                          const Color(0xAA000000),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        _textList(_places[index].name, 17.0,
                                            0xffE9FFFF),
                                        _textList(_places[index].vicinity, 15.0,
                                            0xFFFFFFFF),
                                        _textList(_calculateDistance(_meter),
                                            15.0, 0xFFFFFFFF),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapListActivity(
                                    nameList: _places[index].name,
                                    latList:
                                        _places[index].geometry.location.lat,
                                    lngList:
                                        _places[index].geometry.location.long,
                                  ),
                                )),
                            onLongPress: () => _showDialogList(index),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 10),
                              decoration:
                                  new BoxDecoration(color: Colors.grey));
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _initGetSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPrefs = prefs);
      _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
    });
  }

  _calculateDistance(double _meter) {
    String _myMeters;
    if (_meter < 1000.0) {
      _myMeters = 'Meters: ' + (_meter.round()).toString();
    } else {
      _myMeters =
          'KM: ' + (_meter.round() / 1000.0).toStringAsFixed(2).toString();
    }
    return _myMeters;
  }

  _btnType(String name, String type) {
    return Row(
      children: <Widget>[
        SizedBox(width: ResponsiveScreen().widthMediaQuery(context, 5)),
        RaisedButton(
          padding: EdgeInsets.all(0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          onPressed: () => _searchNearby(true, type),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF5e7974),
                    Color(0xFF6494ED),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(80.0))),
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: ResponsiveScreen().widthMediaQuery(context, 5)),
      ],
    );
  }

  _textList(String text, double fontSize, int color) {
    return Text(text,
        style: TextStyle(shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
        ], fontSize: fontSize, color: Color(color)));
  }

  _showDialogList(int index) async {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text("Add to favorites"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDataFavoritesActivity(
                      nameList: _places[index].name,
                      addressList: _places[index].vicinity,
                      latList: _places[index].geometry.location.lat,
                      lngList: _places[index].geometry.location.long,
                      photoList: _places[index].photos[0].photoReference,
                    ),
                  ));
            },
          ),
          FlatButton(
            child: Text("Share"),
          ),
        ],
      ),
    );
  }

  _getLocationPermission() async {
    var location = new loc.Location();
    try {
      location.requestPermission();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  _searchNearby(bool search, String type) async {
    if (search) {
      _valueRadiusText = _valueRadius.round();
      double latitude = _userLocation.latitude;
      double longitude = _userLocation.longitude;
      String url =
          '$_baseUrl?key=$_API_KEY&location=$latitude,$longitude&opennow=true&types=$type&radius=$_valueRadiusText&keyword=';
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _handleResponse(data);
      } else {
        throw Exception('An error occurred getting places nearby');
      }
      setState(() {
        _searching = false;
        _places.sort((a, b) => sqrt(
                pow(a.geometry.location.lat - _userLocation.latitude, 2) +
                    pow(a.geometry.location.long - _userLocation.longitude, 2))
            .compareTo(sqrt(pow(
                    b.geometry.location.lat - _userLocation.latitude, 2) +
                pow(b.geometry.location.long - _userLocation.longitude, 2))));
        print(_searching);
      });
    }
  }

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        _error = Error.fromJson(data);
        print(_error);
      });
    } else if (data['status'] == "OK") {
      setState(() {
        _places = PlaceResponse.parseResults(data['results']);
      });
    } else {
      print(data);
    }
  }
}
