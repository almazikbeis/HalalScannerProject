import 'package:flutter/material.dart';
import 'Product.dart';

class ScanHistoryPage extends StatelessWidget {
  final List<Product> scanHistory;

  const ScanHistoryPage({Key? key, required this.scanHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('История')),
      ),
      body: ListView.builder(
        itemCount: scanHistory.length,
        itemBuilder: (context, index) {
          final product = scanHistory[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
              product.isHalal ? 'Halal' : 'Haram',
              style: TextStyle(
                color: product.isHalal ? Colors.blue : Colors.red,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(product.name),
                  content: Text(
                    'Status: ${product.isHalal ? 'Halal' : 'Haram'}\n'
                    'Reason: ${product.reason}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
