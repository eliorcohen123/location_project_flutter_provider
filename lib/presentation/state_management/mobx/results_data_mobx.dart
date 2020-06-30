//import 'package:flutter/material.dart';
//import 'package:locationprojectflutter/core/services/service_locator.dart';
//import 'package:locationprojectflutter/data/data_resources/locals/sqflite_helper.dart';
//import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
//import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
//import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';
//import 'package:mobx/mobx.dart';
//
//part 'results_data_mobx.g.dart';
//
//class ResultsDataMobXStore = _ResultsDataBase with _$ResultsDataMobXStore;
//
//abstract class _ResultsDataBase with Store {
//  @observable
//  SQFLiteHelper _db = SQFLiteHelper();
//  @observable
//  ObservableList<ResultsSqfl> _resultsSqfl = ObservableList.of([]);
//  @observable
//  LocationRepoImpl _locationRepoImpl;
//
//  _ResultsDataBase() : _locationRepoImpl = serviceLocator();
//
//  @action
//  void initList(ObservableList<ResultsSqfl> resultsSqfl) {
//    this._resultsSqfl = resultsSqfl;
//  }
//
//  @action
//  void addItem(String name, String vicinity, double lat, double lng,
//      String photo, BuildContext context) {
//    var add = ResultsSqfl.sqfl(name, vicinity, lat, lng, photo);
//    _db.addResult(add).then(
//      (_) {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => FavoritesData(),
//          ),
//        );
//      },
//    );
//  }
//
//  @action
//  void updateItem(int id, String name, String vicinity, double lat,
//      double lng, String photo, BuildContext context) {
//    _db
//        .updateResult(
//      ResultsSqfl.fromSqfl(
//        {
//          'id': id,
//          'name': name,
//          'vicinity': vicinity,
//          'lat': lat,
//          'lng': lng,
//          'photo': photo
//        },
//      ),
//    )
//        .then(
//      (_) {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => FavoritesData(),
//          ),
//        );
//      },
//    );
//  }
//
//  @action
//  void deleteItem(ResultsSqfl result, int index) {
//    _db.deleteResult(result.id).then(
//      (_) {
//        _resultsSqfl.removeAt(index);
//      },
//    );
//  }
//
//  @action
//  void deleteData() {
//    _db.deleteData().then(
//      (_) {
//        getItems();
//      },
//    );
//  }
//
//  @action
//  void getItems() {
//    _db.getAllResults().then(
//      (results) {
//        _resultsSqfl.clear();
//        results.forEach(
//          (result) {
//            _resultsSqfl.add(
//              ResultsSqfl.fromSqfl(result),
//            );
//          },
//        );
//      },
//    );
//  }
//
//  @action
//  Future getSearchNearby(double latitude, double longitude, String open,
//      String type, int valueRadiusText, String text) async {
//    return await _locationRepoImpl.getLocationJson(
//        latitude, longitude, open, type, valueRadiusText, text);
//  }
//}
