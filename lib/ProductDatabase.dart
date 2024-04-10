import 'Product.dart';

class ProductDatabase {
  static List<Product> products = [
    Product(
      barcode: '4870036001205',
      name: 'Шоколад Казахстан',
      isHalal: true,
      reason: 'Халяльный продукт',
    ),
    Product(
      barcode: '690228006845',
      name: 'Коктейль молочный Чудо Клубника 2%',
      isHalal: false,
      reason: 'Наличие Кармина красителя E120',
    ),
    Product(
      barcode: '4870004936324',
      name: 'Тушёнка говяжья КУБЛЕЙ 325 гр',
      isHalal: true,
      reason: 'Халяльный продукт',
    ),
    Product(
      barcode: '4870207313724',
      name: 'Гречесуий йогурт ваниль',
      isHalal: false,
      reason: 'Наличие желатина',
    ),

    // Добавьте другие продукты здесь
  ];

  static Product getProductByBarcode(String barcode) {
    return products.firstWhere((product) => product.barcode == barcode, orElse: () => Product(barcode: '', name: '', isHalal: false, reason: 'Product not found'));
  }
}
