import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';

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
          'CREATE TABLE inventory (id INTEGER, pCode INTEGER PRIMARY KEY, name TEXT, quantity INTEGER, date TEXT)');

      database.execute(
          'CREATE TABLE sales(id INTEGER PRIMARY KEY AUTOINCREMENT, productCode INTEGER, name TEXT, quantity INTEGER, date TEXT, FOREIGN KEY(productCode) REFERENCES inventory(pCode))');
    }, version: version);
    return db!;
  }

  Future testDb() async {
    db = await openDb();

    await db!.execute(
        'INSERT INTO inventory VALUES (0, 12, "fruit", 2, "3/2/2021")');
    await db!
        .execute('INSERT INTO sales VALUES (0, 0, "apples", 13,  "2/1/2022")');
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

  Future<List<Map<String, dynamic>>> getInventoryDetailsMap(
      int productCode) async {
    var ormResult = await db!
        .query('sales', where: 'productCode = ?', whereArgs: [productCode]);
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

  Future<List<SalesItemModel>> getInvItemDetails(int productCode) async {
    var invDetails = await getInventoryDetailsMap(productCode);

    int invDetailsCount = invDetails.length;

    List<SalesItemModel> invItems = <SalesItemModel>[];

    // for loop to create an 'InventoryList' Object from a 'MapList' Object
    for (int i = 0; i < invDetailsCount; i++) {
      invItems.add(
          SalesItemModel.fromMapObject(invItems[i] as Map<String, dynamic>));
    }
    return invItems;
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
