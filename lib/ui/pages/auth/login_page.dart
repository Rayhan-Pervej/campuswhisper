import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/build_text.dart';
import '../../../providers/login_provider.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_password.dart';
import '../../widgets/default_button.dart';
import 'sign_up_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;
    final provider = Provider.of<LoginProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    BuildText(
                      textAlign: TextAlign.center,
                      text: "Welcome to CampusWhisper",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h16,
                    BuildText(
                      textAlign: TextAlign.center,
                      text:
                          "Hi, Welcome to CampusWhisper. Login with your IUB student email.",
                      fontSize: 14,
                    ),
                    AppDimensions.h24,
                    Form(
                      key: provider.formKey,
                      child: Column(
                        children: [
                          CustomInput(
                            controller: provider.emailController,
                            fieldLabel: "Email",
                            hintText: "Enter your iub mail",
                            validation: true,
                            validatorClass: (value) {
                              final regex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@iub\.edu\.bd$',
                              );

                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              } else if (!regex.hasMatch(value)) {
                                return "Enter a valid IUB email (example@iub.edu.bd)";
                              }

                              return null;
                            },
                            errorMessage: "Email is wrong",
                          ),

                          AppDimensions.h16,

                          CustomPassword(
                            controller: provider.passwordController,
                            fieldLabel: "Password",
                            hintText: "Enter your Password",
                            errorMessage: "Password is wrong",
                          ),
                        ],
                      ),
                    ),
                    AppDimensions.h24,

                    DefaultButton(
                      isLoading: provider.isLoading,
                      text: "Login",
                      press: () {
                        if (provider.formKey.currentState!.validate()) {
                          provider.login(context);
                        }
                      },
                    ),

                    AppDimensions.h24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildText(
                          text: "Don't have an Account? ",
                          fontSize: 14,
                        ),

                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          ),
                          child: BuildText(
                            color: colorScheme.primary,
                            text: "Sign Up",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
