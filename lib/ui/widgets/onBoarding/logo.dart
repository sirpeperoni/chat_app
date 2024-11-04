import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/theme.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: isLightTheme(context) ? Image.asset('assets/light-logo.png', fit: BoxFit.fill,) : Image.asset('assets/dark-logo.png', fit: BoxFit.fill,),
    );
  }
}