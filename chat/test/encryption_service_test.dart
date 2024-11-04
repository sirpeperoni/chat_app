import 'package:chat/domain/services/encryption/encryption_contract.dart';
import 'package:chat/domain/services/encryption/encryption_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:test/test.dart';

void main(){
  late IEncryption sut;

  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = EncryptionService(encrypter);
  });

  test('BASE64', () {
    const text = 'message';
    final base64 = RegExp(r"^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$");

    final encrypted = sut.encrypt(text);
    expect(base64.hasMatch(encrypted), true);
  });

  test('enc and dec', () {
    const text = 'message';
    final encrypted = sut.encrypt(text);
    final decrypted = sut.decrypt(encrypted);
    expect(decrypted, text);
  });
}