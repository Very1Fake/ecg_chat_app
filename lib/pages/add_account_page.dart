import 'dart:math';

import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/utils/validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

enum Action {
  toDecide,
  signIn,
  signUp,
}

enum Stage {
  askUsername,
  askEmail,
  askPassword,
  confirm,
}

enum InvalidUsername {
  none,
  format,
  exists;

  String? get string {
    switch (this) {
      case InvalidUsername.none:
        return null;
      case InvalidUsername.format:
        return 'Minimum username length is 3';
      case InvalidUsername.exists:
        return 'Account with this username is already added to the app';
    }
  }
}

class _NewAccountPageState extends State<NewAccountPage> {
  TextEditingController inputUsername = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  TextEditingController inputPasswordRepeat = TextEditingController();

  Action action = Action.toDecide;
  Stage stage = Stage.askUsername;

  InvalidUsername invalidUsername = InvalidUsername.none;
  bool invalidEmail = false;
  bool invalidPassword = false;
  bool invalidPasswordRepeat = false;

  @override
  void dispose() {
    inputUsername.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
    inputPasswordRepeat.dispose();
    super.dispose();
  }

  back() {
    if (stage.index != 0) stage = Stage.values[stage.index - 1];

    // Skip email stage if signing in
    if (action == Action.signIn && stage == Stage.askEmail) {
      stage = Stage.askUsername;
    }
  }

  next() {
    if (stage != Stage.values.last) {
      stage = Stage.values[stage.index + 1];

      // Skip email stage if signing in
      if (action == Action.signIn && stage == Stage.askEmail) {
        stage = Stage.askPassword;
      }
    } else {
      Account account;

      String username = inputUsername.text.trim();
      String password = inputPassword.text.trim();

      if (action == Action.signIn) {
        account = AccountManager().add(username, password);
      } else {
        account =
            AccountManager().create(username, inputEmail.text.trim(), password);
      }

      // Update parent after popping
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(account);
      } else {
        Navigator.of(context).popAndPushNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Stepper(
        currentStep: stage.index,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (details.stepIndex != Stage.askUsername.index)
                  TextButton(
                      onPressed: (details.stepIndex == Stage.confirm.index &&
                              action == Action.signIn &&
                              Navigator.of(context).canPop())
                          ? () => Navigator.of(context).pop()
                          : details.onStepCancel,
                      child: (details.stepIndex == Stage.confirm.index)
                          ? const Text('Back')
                          : const Text('Cancel')),
                const SizedBox(width: 16.0),
                TextButton(
                  onPressed: details.onStepContinue,
                  child: (details.stepIndex == Stage.confirm.index)
                      ? const Text('Sure')
                      : const Text('Next'),
                )
              ],
            ),
          );
        },
        margin: const EdgeInsetsDirectional.only(
          top: 12.0,
          start: 60.0,
          end: 24.0,
          bottom: 12.0,
        ),
        onStepCancel: () => setState(() => back()),
        onStepContinue: () {
          switch (stage) {
            case Stage.askUsername:
              var username = inputUsername.text.trim();
              if (username.isValidUsername()) {
                if (AccountManager()
                    .accountList
                    .any((account) => account.username == username)) {
                  invalidUsername = InvalidUsername.exists;
                } else {
                  if (Random().nextBool()) {
                    action = Action.signIn;
                  } else {
                    action = Action.signUp;
                  }

                  invalidUsername = InvalidUsername.none;
                  next();
                }
              } else {
                invalidUsername = InvalidUsername.format;
              }

              break;
            case Stage.askEmail:
              if (inputEmail.text.trim().isValidEmail()) {
                invalidEmail = false;
                next();
              } else {
                invalidEmail = true;
              }

              break;
            case Stage.askPassword:
              String password = inputPassword.text.trim();

              if (password.isValidPassword()) {
                invalidPassword = false;
                if (action == Action.signUp &&
                    password != inputPasswordRepeat.text.trim()) {
                  invalidPasswordRepeat = true;
                } else {
                  invalidPasswordRepeat = false;
                  next();
                }
              } else {
                invalidPassword = true;
              }

              break;
            case Stage.confirm:
              next();
              break;
          }
          setState(() {});
        },
        steps: [
          Step(
            isActive: stage == Stage.askUsername,
            title: const Text('Enter Username'),
            content: TextField(
              // TODO: Symbols validation
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.newUsername
              ],
              autofocus: true,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                filled: true,
                labelText: 'Username',
                hintMaxLines: 1,
                hintText: faker.internet.userName(),
                errorMaxLines: 3,
                errorText: invalidUsername.string,
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
              controller: inputUsername,
            ),
          ),
          Step(
            isActive: stage == Stage.askEmail,
            title: const Text('Enter Email'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account @${inputUsername.text} doesn't exist.\nIf you want to create new account with this username follow the steps.",
                ),
                const SizedBox(height: 16.0),
                TextField(
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Email',
                    hintMaxLines: 1,
                    hintText: 'mail@example.com',
                    errorMaxLines: 2,
                    errorText: invalidEmail
                        ? 'Make sure you entered valid email'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: inputEmail,
                )
              ],
            ),
          ),
          Step(
            isActive: stage == Stage.askPassword,
            title: const Text('Enter Password'),
            content: Column(
              children: [
                TextField(
                  autocorrect: false,
                  autofillHints: const [
                    AutofillHints.password,
                    AutofillHints.newPassword
                  ],
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Password',
                    errorMaxLines: 3,
                    errorText:
                        invalidPassword ? 'Minimum password length is 6' : null,
                  ),
                  obscureText: true,
                  controller: inputPassword,
                ),
                if (action == Action.signUp) const SizedBox(height: 16.0),
                if (action == Action.signUp)
                  TextField(
                    autocorrect: false,
                    autofillHints: const [
                      AutofillHints.password,
                      AutofillHints.newPassword
                    ],
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Repeat Password',
                      errorMaxLines: 3,
                      errorText: invalidPasswordRepeat
                          ? 'Passwords don\'t match'
                          : null,
                    ),
                    obscureText: true,
                    controller: inputPasswordRepeat,
                  ),
              ],
            ),
          ),
          Step(
            isActive: stage == Stage.confirm,
            title: const Text('Confirmation'),
            content: (action == Action.signIn)
                ? Text("Add @${inputUsername.text} account to this app?")
                : Text(
                    "Are you sure you want to create new account @${inputUsername.text} on ${inputEmail.text} email"),
          ),
        ],
      ),
    );
  }
}
