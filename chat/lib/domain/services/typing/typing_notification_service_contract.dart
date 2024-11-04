import 'package:chat/domain/entity/typing_event.dart';
import 'package:chat/domain/entity/user.dart';

abstract class ITypingNotification{
  Future<bool> send({required TypingEvent event, required User? to});
  Stream<TypingEvent> subscribe(User user, List<String> usersIds);
  void dispose();
}