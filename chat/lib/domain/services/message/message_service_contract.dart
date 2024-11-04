import 'package:chat/domain/entity/message.dart';
import 'package:chat/domain/entity/user.dart';

abstract class IMessageService{
  Future<bool> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}