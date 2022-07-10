import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/utils.dart';

import '../Widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/color.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text, 
      password: _passwordController.text, 
      username: _usernameController.text, 
      bio: _bioController.text,
      file: _image!,
      );
      
      if(res != 'success') {
        showSnackBar(res, context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLauout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
      ),
    );
      }
      setState(() {
        _isloading = false;
      });
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              // svg image 
              SvgPicture.asset("assets/ic_instagram.svg", color: primaryColor, height: 64,),
              const SizedBox(
                height: 64,
                ),
              // circular widget to accept and show our selected file 
              Stack(
                children: [
                  _image!=null? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                  : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage("https://i.pinimg.com/550x/18/b9/ff/18b9ffb2a8a791d50213a9d595c4dd52.jpg",),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 24,),
              // text field input for username
              TextFieldInput(
                hintText: "Enter your username",
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(height: 24,),
              // text field input for email
              TextFieldInput(
                hintText: "Enter Your email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24,),
              // text field input for password
              TextFieldInput(
                hintText: "Enter Your Password",
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
               const SizedBox(height: 24,),
              
              // text field input for bio
              TextFieldInput(
                hintText: "Enter Your bio",
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
               height: 24,
               ),
              // button for login
            InkWell(
              onTap: signUpUser,
              child: Container(
                  child: _isloading ? const Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  ),) : const Text('Sign up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4),
                    ),
                  ),
                  color: blueColor,
                ), 
              ),
            ),
             const SizedBox(
               height: 12,
               ),
             Flexible(child: Container(),flex: 2,),
              //transition for sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text("Don't have an account !"),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                  Container(
                    child: Text("Sign Up." ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}