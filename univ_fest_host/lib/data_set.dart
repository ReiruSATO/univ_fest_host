class Buyer {
  String shop;
  late String user;
  late int price;

  Buyer(this.shop) {
    user = '';
    price = 0;
  }

  void reset() {
    shop = '';
    user = '';
    price = 0;
  }
}
