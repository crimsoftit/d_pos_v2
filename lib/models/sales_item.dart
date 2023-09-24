class SalesItem {
  int id;
  int pCode;
  String name;
  String quantity;

  SalesItem(this.id, this.pCode, this.name, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'pCode': pCode,
      'name': name,
      'quantity': quantity
    };
  }
}
