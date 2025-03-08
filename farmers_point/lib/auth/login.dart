

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';
import '../routes/routeNames.dart';
import '../views/widgets/auth_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController emailController=TextEditingController(text: "");
  final TextEditingController passwordController=TextEditingController(text: "");
  final AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  //Submit Method
  void submit(){
    if(_form.currentState!.validate()){
      controller.login(emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Image.asset("assets/images/logo_png.png",width: 60,height: 60,),
                  const SizedBox(height:20),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign in",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                          Text("Welcome Back"),
                        ],
                      )
                  ),
                  const SizedBox(height:20),
                  authInput(label: "Email",hinttext: "Enter your email",controller:emailController,validatorCallback: ValidationBuilder().required().email().build(),),
                  const SizedBox(height:20),
                  authInput(label: "Password",hinttext: "Enter your password",isPassword: true,controller: passwordController,validatorCallback: ValidationBuilder().required().build(),),
                  const SizedBox(height:20),
                  ElevatedButton(
                    onPressed: (){
                      submit();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(40)),
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20,),
                  Text.rich(TextSpan(
                      children: [TextSpan(
                          text: " Sign up ",
                          style: const TextStyle(fontWeight:FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap=()=> Get.toNamed(RouteNames.Signup)

                      ),],
                      text: "Don't have an account ? "
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
