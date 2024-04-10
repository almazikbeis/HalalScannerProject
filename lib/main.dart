import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:halalscanner/CustomDialog.dart';
import 'package:halalscanner/Product.dart';
import 'package:halalscanner/ProductDatabase.dart';
import 'package:halalscanner/ScanHistoryPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green.shade900, // Темно-зеленый цвет для AppBar
        scaffoldBackgroundColor: Colors.lightGreen, // Светло-зеленый фон
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List<Product> scanHistory = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Halal Scanner',
            style: TextStyle(
              color: Colors.black, // Золотистые буквы на темно-зеленом AppBar
            ),
          ),
        ),
        backgroundColor: Colors.green.shade900, // Темно-зеленый цвет для AppBar
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: _controller,
              child: Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () => scanCode(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800, // Темно-зеленый цвет для кнопки
              ),
              child: Text('Start Scanning', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Text(
              'Last scanned: ${scanHistory.isNotEmpty ? scanHistory.last.name : "No scans yet"}',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanHistoryPage(scanHistory: scanHistory)),
          );
        },
        backgroundColor: Colors.black,
        tooltip: 'History',
        child: Icon(Icons.history),
      ),
    );
  }

  Future<void> scanCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcodeScanRes != "-1") {
        Product scannedProduct = ProductDatabase.getProductByBarcode(barcodeScanRes);
        if (scannedProduct.name != "") {
          setState(() {
            scanHistory.add(scannedProduct);
          });
          _showCustomDialog(scannedProduct);
        } else {

          _showCustomDialogForUnknownProduct();
        }
      }
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }
  }

  void _showCustomDialog(Product product) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: product.name,
        content: product.isHalal ? 'This product is halal.' : 'This product is haram.',
        isHalal: product.isHalal,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showCustomDialogForUnknownProduct() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Unknown Product',
        content: 'The halal status of this product is unknown.',
        isHalal: false, // Assuming unknown products are considered haram
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
