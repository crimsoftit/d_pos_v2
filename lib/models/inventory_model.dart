class InventoryModel {
  int? _id;
  int _pCode = 0;
  String _name = "";
  int _quantity = 1;

  InventoryModel(this._id, this._pCode, this._name, this._quantity);

  int? get id => _id;
  int get pCode => _pCode;
  String get name => _name;
  int get quantity => _quantity;

  set pCode(int newPcode) {
    _pCode = newPcode;
  }

  set name(String newName) {
    if (newName.length <= 255 || newName.length >= 3) {
      _name = newName;
    }
  }

  set quantity(int newQty) {
    _quantity = newQty;
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

    return map;
  }

  // extract a InventoryModel object from a Map object
  InventoryModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _pCode = map['pCode'];
    _quantity = map['quantity'];
  }
}
