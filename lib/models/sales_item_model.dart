// ignore_for_file: unnecessary_getters_setters

class SalesItemModel {
  int? _id;
  int _productCode = 0;
  String _name = "";
  int _quantity = 0;
  String _date = "";

  SalesItemModel(
    this._productCode,
    this._name,
    this._quantity,
    this._date,
  );

  SalesItemModel.withId(
    this._id,
    this._productCode,
    this._name,
    this._quantity,
    this._date,
  );

  int? get id => _id;

  int get productCode => _productCode;
  String get name => _name;
  int get quantity => _quantity;
  String get date => _date;

  set productCode(int newPcode) {
    _productCode = newPcode;
  }

  set name(String newName) {
    if (newName.length <= 255 || newName.length >= 3) {
      _name = newName;
    }
  }

  set quantity(int newQty) {
    _quantity = newQty;
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert a SalesItemModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['productCode'] = _productCode;
    map['name'] = _name;
    map['quantity'] = _quantity;
    map['date'] = _date;

    return map;
  }

  // extract a SalesItemModel object from a Map object
  SalesItemModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._productCode = map['productCode'];
    this._name = map['name'];
    this._quantity = map['quantity'];
    this._date = map['date'];
  }
}
