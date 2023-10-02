class InventoryModel {
  int? _id;
  int _pCode = 0;
  String _name = "";
  int _quantity = 0;
  int _price = 0;
  String _date = "";

  InventoryModel(
    this._id,
    this._pCode,
    this._name,
    this._quantity,
    this._price,
    this._date,
  );

  int? get id => _id;
  int get pCode => _pCode;
  String get name => _name;
  int get quantity => _quantity;
  int get price => _price;
  String get date => _date;

  set pCode(int newPcode) {
    _pCode = newPcode;
  }

  set name(String newName) {
    if (newName.length <= 255 || newName.length >= 3) {
      _name = newName;
    }
  }

  set quantity(int newQty) {
    if (newQty > 0) {
      _quantity = newQty;
    }
  }

  set price(int newPrice) {
    if (newPrice >= 1) {
      _price = newPrice;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert an InventoryModel object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = _id;
    }
    map['pCode'] = _pCode;
    map['name'] = _name;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['date'] = _date;

    return map;
  }

  // extract a InventoryModel object from a Map object
  InventoryModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _pCode = map['pCode'];
    _quantity = map['quantity'];
    _price = map['price'];
    _date = map['date'];
  }
}
