import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mita/x_landingPage.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpassController = TextEditingController();

  bool _nameVal = false;
  bool _phoneVal = false;
  bool _emailVal = false;
  bool _passVal = false;
  bool _confpassVal = false;

  String _emailError = '';
  String _passError = '';
  String _confpassError = '';

  bool isLoading = false;

  FocusNode oldpass = FocusNode();
  FocusNode newpass = FocusNode();
  FocusNode confirmpass = FocusNode();

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something

        setState(() {
          isLoading = false;
        });
        showDialogMessage('Password berhasil diganti.');
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
      }).catchError((error) {
        //Error, show something
        setState(() {
          isLoading = false;
        });
        showDialogMessage('Reset password gagal, coba beberapa saat lagi.');
      });
    }).catchError((err) {});
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Reset Password', style: (TextStyle(color: Colors.black))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoFormSection(
                    header: Text('Masukkan informasi berikut'),
                    children: [
                      CupertinoFormRow(
                        child: CupertinoTextFormFieldRow(
                          placeholder: "Enter password",
                          controller: emailController,
                          obscureText: true,
                          focusNode: oldpass,
                        ),
                        error:
                            _emailVal ? Text(_emailError) : SizedBox.shrink(),
                        prefix: Text('Password Lama'),
                      ),
                      CupertinoFormRow(
                        child: CupertinoTextFormFieldRow(
                          placeholder: "Enter password",
                          obscureText: true,
                          controller: passwordController,
                          focusNode: newpass,
                        ),
                        error: _passVal ? Text(_passError) : SizedBox.shrink(),
                        prefix: Text('Password Baru'),
                      ),
                      CupertinoFormRow(
                        child: CupertinoTextFormFieldRow(
                          placeholder: "Enter password",
                          obscureText: true,
                          controller: confirmpassController,
                          focusNode: confirmpass,
                        ),
                        error: _confpassVal
                            ? Text(_confpassError)
                            : SizedBox.shrink(),
                        prefix: Text('Confirm Password'),
                      )
                    ]),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        if (emailController.text.isEmpty) {
                          setState(() {
                            _emailVal = true;
                          });
                          _emailError = 'This field can not be empty.';
                        } else if (passwordController.text.isEmpty) {
                          setState(() {
                            _passVal = true;
                          });
                          _passError = 'This field can not be empty.';
                        } else if (passwordController.text.length < 6) {
                          setState(() {
                            _passVal = true;
                          });
                          _passError =
                              'Password must be at least 6 Characters.';
                        } else if (passwordController.text !=
                            confirmpassController.text) {
                          setState(() {
                            _confpassVal = true;
                          });
                          _confpassError = 'Password is not match.';
                        } else {
                          setState(() {
                            _nameVal = false;
                            _phoneVal = false;
                            _emailVal = false;
                            _passVal = false;
                            _confpassVal = false;
                            isLoading = true;
                          });

                          oldpass.unfocus();
                          newpass.unfocus();
                          confirmpass.unfocus();
                          _changePassword(
                              emailController.text, passwordController.text);
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 150,
                        height: 50,
                        alignment: Alignment.center,
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                "Reset",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDialogMessage(message) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('MESSAGE'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          );
        });
  }
}
