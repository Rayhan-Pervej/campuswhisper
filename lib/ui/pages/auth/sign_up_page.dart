import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/build_text.dart';
import '../../../providers/sign_up_provider.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_password.dart';
import '../../widgets/default_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = Provider.of<SignUpProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                          "Sign up with your student email. Don't use easy password!",
                      fontSize: 14,
                    ),
                    AppDimensions.h24,
                    Form(
                      key: provider.formKey,
                      child: Column(
                        children: [
                          CustomInput(
                            controller: provider.firstNameController,

                            fieldLabel: "First Name*",

                            hintText: "Enter your first name",
                            validation: true,
                            validatorClass: (value) {
                              if (value == null || value.isEmpty) {
                                return "First name is required";
                              }
                              if (value.length < 2 || value.length > 11) {
                                return "First name should have 3 to 10 letters";
                              }

                              return null;
                            },
                            errorMessage: "First name is wrong",
                          ),
                          AppDimensions.h16,
                          CustomInput(
                            controller: provider.lastNameController,

                            fieldLabel: "Last Name*",

                            hintText: "Enter your last name",
                            validation: true,
                            validatorClass: (value) {
                              if (value == null || value.isEmpty) {
                                return "Last is required";
                              }
                              if (value.length < 2 || value.length > 11) {
                                return "Last name should have 3 to 10 letters";
                              }

                              return null;
                            },
                            errorMessage: "Last name is wrong",
                          ),
                          AppDimensions.h16,
                          CustomInput(
                            controller: provider.idController,

                            fieldLabel: "IUB ID*",

                            hintText: "Enter your IUB ID",
                            validation: true,
                            validatorClass: (value) {
                              if (value == null || value.isEmpty) {
                                return "ID is required";
                              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return "ID should have digit only";
                              } else if (value.length != 7) {
                                return "ID should have 7 digit";
                              }

                              return null;
                            },
                            errorMessage: "Last name is wrong",
                          ),
                          AppDimensions.h16,
                          CustomInput(
                            controller: provider.emailController,

                            fieldLabel: "Email*",

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
                            fieldLabel: "Password*",
                            hintText: "Enter your password",
                            errorMessage: "Password is wrong",
                          ),
                          AppDimensions.h16,

                          CustomPassword(
                            controller: provider.confirmPasswordController,
                            fieldLabel: "Confirm Password*",
                            hintText: "Enter your password again",
                            errorMessage: "Password didn't match",
                            validatorClass: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required";
                              } else if (value !=
                                  provider.passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    AppDimensions.h24,

                    DefaultButton(
                      isLoading: provider.isLoading,
                      text: "Submit",
                      press: () {
                        if (provider.formKey.currentState!.validate()) {
                          provider.submitForm(context);
                        }
                      },
                    ),

                    AppDimensions.h24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildText(
                          text: "Already have an Account? ",
                          fontSize: 14,
                        ),

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: BuildText(
                            color: colorScheme.primary,
                            text: "Login",
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
