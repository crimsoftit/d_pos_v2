import 'package:path/path.dart';
import 'dart:io' show Directory;
import 'package:sqflite/sqflite.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DbHelper {
  final int version = 1;

  static final invTable = 'inventory';
  static final salesTable = 'sales';
  static final invColumnId = 'id';
  static final invColumnName = 'name';
  static final invColumnQty = 'quantity';
  static final invColumnPrice = 'price';
  static final invColumnCode = 'pCode';

  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  // make this a singleton class
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db != null) {
      return db!;
    }
    db = await openDatabase(join(await getDatabasesPath(), 'stock.db'),
        onCreate: (database, version) {
      database.execute(
          'CREATE TABLE inventory (id INTEGER, pCode INTEGER PRIMARY KEY, name TEXT, quantity INTEGER, price INTEGER, date TEXT)');

      database.execute(
          'CREATE TABLE sales(id INTEGER PRIMARY KEY AUTOINCREMENT, productCode INTEGER, name TEXT, quantity INTEGER, price INTEGER, date TEXT, FOREIGN KEY(productCode) REFERENCES inventory(pCode))');
    }, version: version);
    return db!;
  }

  Future testDb() async {
    db = await openDb();

    await db!.execute(
        'INSERT INTO inventory VALUES (0, 12, "fruit", 2, 20, "3/2/2021")');
    await db!.execute(
        'INSERT INTO sales VALUES (0, 0, "apples", 13, 15,  "2/1/2022")');
    List inventory = await db!.rawQuery('select * from inventory');
    List sales = await db!.rawQuery('select * from sales');
    print(inventory[0].toString());
    print(sales[0].toString());
  }

  // fetch operation: get all inventory objects from the database
  Future<List<Map<String, dynamic>>> getInventoryMapList() async {
    // var rawResult = await db.rawQuery('SELECT * FROM inventory order by priority');
    var ormResult = await db!.query('inventory');
    return ormResult;
  }

  // fetch operation: get barcode-scanned inventory object from the database
  Future<List<InventoryModel>> getScannedInvList(int pCode) async {
    // var rawResult = await db.rawQuery('SELECT * FROM inventory order by priority');
    final List<Map<String, dynamic>> maps = await db!.query(
      'inventory',
      where: 'pCode = ?',
      whereArgs: [pCode],
    );
    return List.generate(maps.length, (i) {
      return InventoryModel(
        maps[i]['id'],
        maps[i]['pCode'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['price'],
        maps[i]['date'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getSalesListMap() async {
    var ormResult = await db!.query('Sales');
    return ormResult;
  }

  Future<int> insertInventoryList(InventoryModel invModel) async {
    int pCode = await db!.insert(
      'inventory',
      invModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return pCode;
  }

  Future<int> insertSalesItem(SalesItemModel soldItem) async {
    int productCode = await db!.insert(
      'sales',
      soldItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return productCode;
  }

  // get the 'Map List' [ List<Map> ] and convert it to 'Stock List' [ List<Stock> ]
  Future<List<InventoryModel>> getInventoryList() async {
    var inventoryMapList = await getInventoryMapList();

    int invCount = inventoryMapList.length;

    List<InventoryModel> inventoryItems = <InventoryModel>[];

    // for loop to create an 'InventoryList' Object from a 'MapList' Object
    for (int i = 0; i < invCount; i++) {
      inventoryItems.add(InventoryModel.fromMapObject(inventoryMapList[i]));
    }
    return inventoryItems;
  }

  // get the 'Map List' [ List<Map> ] and convert it to 'Stock List' [ List<Stock> ]
  // Future<List<InventoryModel>> getInventoryList(int pCode) async {
  //   var invItemMapList = await getScannedInvMapList(pCode);

  //   int invCount = invItemMapList.length;

  //   List<InventoryModel> scannedInvItems = <InventoryModel>[];

  //   // for loop to create an 'InventoryList' Object from a 'MapList' Object
  //   for (int i = 0; i < invCount; i++) {
  //     scannedInvItems.add(InventoryModel.fromMapObject(scannedInvItems[i]));
  //   }
  //   return inventoryItems;
  // }

  Future<List<SalesItemModel>> getSalesList() async {
    var soldItems = await getSalesListMap();

    int soldCount = soldItems.length;

    List<SalesItemModel> itemsSold = <SalesItemModel>[];

    // for loop to create an 'SalesList' Object from a 'MapList' Object
    for (int i = 0; i < soldCount; i++) {
      itemsSold.add(SalesItemModel.fromMapObject(soldItems[i]));
    }
    return itemsSold;
  }

  Future<int> deleteInventoryItem(InventoryModel inventory) async {
    int result = await db!.delete(
      'inventory',
      where: 'pCode = ?',
      whereArgs: [inventory.pCode],
    );

    return result;
  }

  Future<int> deleteSoldItem(SalesItemModel soldItem) async {
    int result = await db!.delete(
      'sales',
      where: 'pCode = ?',
      whereArgs: [soldItem.productCode],
    );
    return result;
  }
}
