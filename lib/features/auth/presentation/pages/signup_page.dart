import 'package:datahack/core/theme/app_pallete.dart';
import 'package:datahack/core/utils/loader.dart';
import 'package:datahack/core/utils/snackbar.dart';
import 'package:datahack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:datahack/features/auth/presentation/widgets/auth_button.dart';
import 'package:datahack/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  List<String> selectedSubjects = [];

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
    gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Image(
                            image: AssetImage('assets/images/authBgImage.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showSnackbar(context, state.message);
                    }
                    if (state is AuthSuccess) {
                      showSnackbar(context, "Account created successfully");
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Loader();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          children: [
                            Text(
                              "Create account!",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.primaryColor),
                            ),
                            Text(
                              "Enter your details to get started!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              AuthTextfield(
                                controller: firstNameController,
                                text: 'First Name',
                              ),
                              const SizedBox(height: 20),
                              AuthTextfield(
                                controller: middleNameController,
                                text: 'Middle Name',
                              ),
                              const SizedBox(height: 20),
                              AuthTextfield(
                                controller: lastNameController,
                                text: 'Last Name',
                              ),
                              const SizedBox(height: 20),
                              AuthTextfield(
                                controller: emailController,
                                text: 'Email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              AuthTextfield(
                                controller: passwordController,
                                text: 'Password',
                                isPassword: true,
                              ),
                              const SizedBox(height: 20),
                              AuthTextfield(
                                controller: cpasswordController,
                                text: 'Confirm Password',
                                isPassword: true,
                              ),
                              DropdownButtonFormField<String>(
                                value: gradeController.text.isEmpty
                                    ? null
                                    : gradeController.text,
                                decoration: InputDecoration(
                                  labelText: 'Grade',
                                  border: OutlineInputBorder(),
                                ),
                                items: ['11th', '12th'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gradeController.text = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Select Subjects:'),
                                  CheckboxListTile(
                                    title: Text('Physics'),
                                    value: selectedSubjects.contains('Physics'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          selectedSubjects.add('Physics');
                                        } else {
                                          selectedSubjects.remove('Physics');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Chemistry'),
                                    value:
                                        selectedSubjects.contains('Chemistry'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          selectedSubjects.add('Chemistry');
                                        } else {
                                          selectedSubjects.remove('Chemistry');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Maths'),
                                    value: selectedSubjects.contains('Maths'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          selectedSubjects.add('Maths');
                                        } else {
                                          selectedSubjects.remove('Maths');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Biology'),
                                    value: selectedSubjects.contains('Biology'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          selectedSubjects.add('Biology');
                                        } else {
                                          selectedSubjects.remove('Biology');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('English'),
                                    value: selectedSubjects.contains('English'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          selectedSubjects.add('English');
                                        } else {
                                          selectedSubjects.remove('English');
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            AuthButton(
                              text: 'Sign Up',
                              onPressed: () {
                                if (gradeController.text.isEmpty) {
                                  showSnackbar(
                                      context, "Please select a grade");
                                  return;
                                }
                                if (selectedSubjects.isEmpty) {
                                  showSnackbar(context,
                                      "Please select at least one subject");
                                  return;
                                }
                                context.read<AuthBloc>().add(AuthSignUp(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      firstNameController.text.trim(),
                                      lastNameController.text.trim(),
                                      middleNameController.text.trim(),
                                      gradeController.text,
                                      selectedSubjects,
                                    ));
                              },
                            ),
                            const SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                  text:
                                      "By continuing you are agreeing to the ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: "Terms of Service",
                                        style: TextStyle(
                                            color: Pallete.primaryColor,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: " and ",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(
                                            color: Pallete.primaryColor,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 1,
                                  width: 100,
                                  color: Colors.grey,
                                ),
                                const Text("Or sign in with google"),
                                Container(
                                  height: 1,
                                  width: 100,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // AuthButton(
                            //   text: 'Continue with Google',
                            //   // onPressed: () {
                            //   //   context.read<AuthBloc>().add(AuthGoogle SignIn()),
                            //   // },
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Pallete.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
