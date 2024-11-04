import 'package:flutter/material.dart';
import 'package:flutter_chat_app/states_management/onboarding/onboarding_state.dart';
import 'package:flutter_chat_app/theme.dart';
import 'package:flutter_chat_app/ui/widgets/onBoarding/logo.dart';
import 'package:flutter_chat_app/ui/widgets/onBoarding/profile_upload.dart';
import 'package:flutter_chat_app/ui/widgets/shared/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../states_management/onboarding/onboarding_cubit.dart';
import '../../states_management/onboarding/profile_image_cubit.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  String _username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              const Spacer(),
              const ProfileUpload(),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  hint: 'Твоё имя',
                  height: 45,
                  onchanged: (val) {
                    _username = val;
                  },
                  inputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInputs();
                    if(error.isNotEmpty){
                      final snackBar = SnackBar(content: Text(
                        error,
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold
                        ),
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLightTheme(context) ? Colors.black : Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)
                    )
                  ), 
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'Старт',
                      style: TextStyle(
                        fontSize: 18,
                        color: isLightTheme(context) ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) => state is Loading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
              ),
              Spacer(flex: 1)
            ],
          ),
        ),
      ),
    );
  }

  _logo(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Doge',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(width: 8.0),
        const Logo(),
        const SizedBox(width: 8.0),
        Text('Chat',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_username, profileImage!);
  }

  String _checkInputs() {
    var error = '';
    if (_username.isEmpty) error = 'Enter display name';
    if (context.read<ProfileImageCubit>().state == null) {
      error = '$error\nUpload profile image';
    }

    return error;
  }
}

