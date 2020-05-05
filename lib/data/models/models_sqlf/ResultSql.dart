class ResultSql {
  int id;
  String name;
  String vicinity;
  double lat;
  double lng;
  String photo;

  ResultSql.sqlf(this.name, this.vicinity, this.lat, this.lng, this.photo);

  Map<String, dynamic> toSqlf() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['vicinity'] = vicinity;
    map['lat'] = lat;
    map['lng'] = lng;
    map['photo'] = photo;
    return map;
  }

  ResultSql.fromSqlf(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.vicinity = map['vicinity'];
    this.lat = map['lat'];
    this.lng = map['lng'];
    this.photo = map['photo'];
  }
}
