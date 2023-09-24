import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

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
          'CREATE TABLE inventory (id INTEGER, pCode INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');

      //   database.execute(
      //       'CREATE TABLE sales (id INTEGER PRIMARY KEY, productCode INTEGER, name TEXT, quantity TEXT, FOREIGN KEY productCode REFERENCES inventory(pCode))');
      // }, version: version);
      database.execute(
          'CREATE TABLE sales(id INTEGER PRIMARY KEY AUTOINCREMENT, productCode INTEGER, name TEXT, quantity TEXT  FOREIGN KEY(productCode) REFERENCES inventory(pCode))');
    }, version: version);
    return db!;
  }

  Future testDb() async {
    db = await openDb();

    await db!.execute('INSERT INTO inventory VALUES (0, 12, "fruit", 2)');
    await db!.execute(
        'INSERT INTO sales VALUES (0, 0, 13, "apples", "2 kg", "make em green")');
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

  Future<int> insertInventoryList(InventoryModel invModel) async {
    int pCode = await db!.insert(
      'inventory',
      invModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return pCode;
  }

  Future<int> insertSalesItem(SalesItem item) async {
    int pCode = await db!.insert(
      'sales',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return pCode;
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

  Future<int> deleteInventoryItem(InventoryModel inventory) async {
    int result = await db!.delete(
      'sales',
      where: 'pCode = ?',
      whereArgs: [inventory.id],
    );

    result = await db!.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [inventory.id],
    );

    return result;
  }
}
