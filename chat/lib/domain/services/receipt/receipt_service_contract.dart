import 'package:chat/domain/entity/receipt.dart';
import 'package:chat/domain/entity/user.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> receipts(User user);
  void dispose();
}