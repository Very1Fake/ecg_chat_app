import 'dart:math';

import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/isar_service.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/utils/validation.dart';
import 'package:ecg_chat_app/widgets/bottom_progress_indicator.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

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
  taken;

  String? get string {
    switch (this) {
      case InvalidUsername.none:
        return null;
      case InvalidUsername.format:
        return 'Minimum username length is 3';
      case InvalidUsername.taken:
        return 'Account with this username is already taken';
    }
  }
}

enum InvalidEmail {
  none,
  format,
  taken;

  String? get string {
    switch (this) {
      case InvalidEmail.none:
        return null;
      case InvalidEmail.format:
        return 'Make sure you entered valid email';
      case InvalidEmail.taken:
        return 'Account for this email already exists';
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
  InvalidEmail invalidEmail = InvalidEmail.none;
  bool invalidPassword = false;
  bool invalidPasswordRepeat = false;
  bool loading = false;

  @override
  void dispose() {
    inputUsername.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
    inputPasswordRepeat.dispose();
    super.dispose();
  }

  backgroundTask<T>(Future<T> task, Function(T) onResult) {
    setState(() => loading = true);
    task.then((value) {
      if (mounted) {
        onResult(value);
        setState(() => loading = false);
      }
    });
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
      loading = true;
      finish();
    }
  }

  finish() async {
    final username = inputUsername.text.trim();
    final password = inputPassword.text.trim();

    // TODO: Make GET /auth/login request
    // TODO: Make POST /user request if signing up
    Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 500))
        .then((_) async => (action == Action.signIn)
            ? await IsarService.login(username, password)
            : await IsarService.register(
                username, inputEmail.text.trim(), password))
        .then((_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).popAndPushNamed('/');
      }
    });
  }

  onContinue() {
    switch (stage) {
      case Stage.askUsername:
        final username = inputUsername.text.trim();

        if (username.isValidUsername()) {
          if (IsarService.db.accounts
                  .where()
                  .usernameEqualTo(username)
                  .findFirstSync() !=
              null) {
            invalidUsername = InvalidUsername.taken;
          } else {
            // TODO: Make GET /user request
            backgroundTask(
              Future.delayed(
                  Duration(milliseconds: Random().nextInt(1000) + 500)),
              (_) {
                Random().nextBool()
                    ? action = Action.signIn
                    : action = Action.signUp;

                invalidUsername = InvalidUsername.none;
                next();
              },
            );
          }
        } else {
          invalidUsername = InvalidUsername.format;
        }

        break;
      case Stage.askEmail:
        final email = inputEmail.text.trim();
        if (email.isValidEmail()) {
          if (IsarService.db.accounts
                  .where()
                  .emailEqualTo(email)
                  .findFirstSync() !=
              null) {
            invalidEmail = InvalidEmail.taken;
          } else {
            invalidEmail = InvalidEmail.none;
            next();
          }
        } else {
          invalidEmail = InvalidEmail.format;
        }

        break;
      case Stage.askPassword:
        final password = inputPassword.text.trim();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: !loading ? () => Navigator.of(context).pop() : null,
              )
            : null,
        title: const Text('Add Account'),
        bottom: loading ? const BottomProgressIndicator() : null,
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
                const SizedBox(width: 8.0),
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
        onStepCancel: !loading ? () => setState(() => back()) : null,
        onStepContinue: !loading ? onContinue : null,
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
                    errorText: invalidEmail.string,
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
            content: Align(
                alignment: Alignment.centerLeft,
                child: (action == Action.signIn)
                    ? Text("Add @${inputUsername.text} account to this app?")
                    : Text(
                        "Are you sure you want to create new account @${inputUsername.text} for ${inputEmail.text} email?")),
          ),
        ],
      ),
    );
  }
}
