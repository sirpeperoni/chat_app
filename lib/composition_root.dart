import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/data/services/image_uploader.dart';

import 'package:flutter_chat_app/ui/pages/onboarding.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';


import 'states_management/onboarding/onboarding_cubit.dart';
import 'states_management/onboarding/profile_image_cubit.dart';

class CompositionRoot {
  static late RethinkDb _r;
  static late Connection _connection;
  static late IUserService _userService;
  static configure() async {
    _r = RethinkDb();
    _connection = await _r.connect(host: "10.0.2.2", port: 28015);
    _userService = UserService(_r, _connection);
  }
  static Widget composeOnboardingUi() {
    ImageUploader imageUploader = ImageUploader('http://10.0.2.2:3000/upload');
    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: const OnboardingWidget(),
    );
  }
}