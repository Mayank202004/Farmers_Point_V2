

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';
import '../routes/routeNames.dart';
import '../views/widgets/auth_input.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _signupState();
}

class _signupState extends State<Signup> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController nameController=TextEditingController(text: "");
  final TextEditingController emailController=TextEditingController(text: "");
  final TextEditingController passwordController=TextEditingController(text: "");
  final TextEditingController passwordConfirmController=TextEditingController(text: "");
  final AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  //Submit Method
  void submit(){
    if(_form.currentState!.validate()){
      controller.signup(nameController.text, emailController.text, passwordController.text);
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
                  Image.asset("assets/images/logo_png.png",width: 50,height: 50,),
                  const SizedBox(height:20),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign up",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                          Text("Express your views to the globe"),
                        ],
                      )
                  ),
                  const SizedBox(height:20),
                  authInput(label: "Name",hinttext: "Enter your name",controller:nameController,validatorCallback: ValidationBuilder().required().minLength(3).maxLength(50).build(),),
                  const SizedBox(height:20),
                  authInput(label: "Email",hinttext: "Enter your email",controller:emailController,validatorCallback: ValidationBuilder().required().email().build(),),
                  const SizedBox(height:20),
                  authInput(label: "Password",hinttext: "Enter your password",isPassword: true,controller:passwordController,validatorCallback: ValidationBuilder().required().minLength(5).maxLength(20).build(),),
                  const SizedBox(height:20),
                  authInput(label: "Confirm Password",
                    hinttext: "Confirm your password",
                    isPassword: true,
                    controller: passwordConfirmController,
                    validatorCallback: (arg){
                      if(passwordController.text!=arg) {
                        return "Confirm password not matched";
                      }else {
                        return null;
                      }},),
                  const SizedBox(height:20),
                  Obx(() => ElevatedButton(
                    onPressed: (){
                      submit();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(40)),
                    ),
                    child:  Text(controller.signupLoading.value ? "Processing..." :"Sign up"),
                  ),
                  ),
                  const SizedBox(height: 20,),
                  Text.rich(TextSpan(
                      children: [TextSpan(
                          text: " Sign in ",
                          style: const TextStyle(fontWeight:FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap=()=> Get.toNamed(RouteNames.Login)

                      ),],
                      text: "Already have an account ? "
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
