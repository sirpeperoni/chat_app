import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/user/user_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class UserService implements IUserService {

  final Connection _c;
  final RethinkDb _r;

  UserService(this._r, this._c);

  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    if(user.id != null) data['id'] = user.id;

    final result = await _r.table('users').insert(data, {
      'conflict': 'update',
      'return_changes': true
    }).run(_c);

    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    await _r.table("users").update({'id':user.id, 'active':false, 'last_seen': DateTime.now()}).run(_c);
    _c.close();
  }

  @override
  Future<List<User>> online() async {
    Cursor users = await _r.table("users").filter({'active':true}).run(_c);
    final userList = await users.toList();
    return userList.map((item) => User.fromJson(item)).toList();
  }

}