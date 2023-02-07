import 'dart:math';

import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/state_manager.dart';
import 'package:ecg_chat_app/utils/validation.dart';
import 'package:ecg_chat_app/widgets/bottom_progress_indicator.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../utils/api.dart';

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

enum InputError {
  none,
  usernameFormat,
  usernameTaken,
  emailFormat,
  emailTaken;

  String? get string {
    switch (this) {
      case InputError.none:
        return null;
      case InputError.usernameFormat:
        return 'Minimum username length is 3';
      case InputError.usernameTaken:
        return 'Account with this username is already taken';
      case InputError.emailFormat:
        return 'Make sure you entered valid email';
      case InputError.emailTaken:
        return 'Account for this email already exists';
    }
  }
}

enum FinishError {
  wrongPassword,
  internalServerError,
  emailTaken;

  String get string {
    switch (this) {
      case FinishError.wrongPassword:
        return 'Wrong password. Try again.';
      case FinishError.internalServerError:
        return 'Internal Server Error (500)';
      case FinishError.emailTaken:
        return 'Email has been taken. Use another one.';
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

  InputError inputError = InputError.none;
  FinishError? finishError;
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
    if (stage.index != 0) {
      stage = Stage.values[stage.index - 1];
      inputError = InputError.none;
    }

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
      finishError = null;
      finish();
    }
  }

  finish() async {
    final username = inputUsername.text.trim();
    final password = inputPassword.text.trim();

    Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 500))
        .then((_) async {
      if (action == Action.signIn) {
        final login = await API.userLogin(username, password);

        if (login != null) {
          API.beginTempSession(login.refresh);
          final userData = (await API.userData())!;
          API.endTempSession();
          await StateManager.addAccount(Account(
            userData.uuid,
            userData.username,
            userData.email,
            login.refresh,
          ));
          return null;
        } else {
          return FinishError.wrongPassword;
        }
      } else {
        final email = inputEmail.text.trim();
        final register = await API.userRegister(username, email, password);

        if (register != null) {
          if (register) {
            final login = (await API.userLogin(username, password))!;
            API.beginTempSession(login.refresh);
            final userData = (await API.userData())!;
            API.endTempSession();

            await StateManager.addAccount(Account(
              userData.uuid,
              userData.username,
              userData.email,
              login.refresh,
            ));
            return null;
          } else {
            return FinishError.emailTaken;
          }
        } else {
          return FinishError.internalServerError;
        }
      }
    }).then((status) {
      if (status == null) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).popAndPushNamed('/');
        }
      } else {
        if (mounted) {
          setState(() {
            finishError = status;
            loading = false;
          });
        }
      }
    });
  }

  onContinue() {
    switch (stage) {
      case Stage.askUsername:
        final username = inputUsername.text.trim();

        if (username.isValidUsername()) {
          if (StateManager.db.accounts
                  .where()
                  .usernameEqualTo(username)
                  .findFirstSync() !=
              null) {
            inputError = InputError.usernameTaken;
          } else {
            inputError = InputError.none;
            backgroundTask(
              API.userInfo(username),
              (userData) {
                action = userData != null ? Action.signIn : Action.signUp;
                next();
              },
            );
          }
        } else {
          inputError = InputError.usernameFormat;
        }

        break;
      case Stage.askEmail:
        final email = inputEmail.text.trim();
        if (email.isValidEmail()) {
          if (StateManager.db.accounts
                  .where()
                  .emailEqualTo(email)
                  .findFirstSync() !=
              null) {
            inputError = InputError.emailTaken;
          } else {
            inputError = InputError.none;
            next();
          }
        } else {
          inputError = InputError.emailFormat;
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
                      onPressed: details.onStepCancel,
                      child: const Text('Back')),
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
                errorText: inputError.string,
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
              textInputAction: TextInputAction.next,
              onSubmitted: !loading ? (_) => onContinue() : null,
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
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Email',
                    hintMaxLines: 1,
                    hintText: 'mail@example.com',
                    errorMaxLines: 2,
                    errorText: inputError.string,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: !loading ? (_) => onContinue() : null,
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
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Password',
                    errorMaxLines: 3,
                    errorText:
                        invalidPassword ? 'Minimum password length is 6' : null,
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: action != Action.signUp
                      ? !loading
                          ? (_) => onContinue()
                          : null
                      : null,
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
                    textInputAction: TextInputAction.done,
                    onSubmitted: !loading ? (_) => onContinue() : null,
                    controller: inputPasswordRepeat,
                  ),
              ],
            ),
          ),
          Step(
            isActive: stage == Stage.confirm,
            title: const Text('Confirmation'),
            content: Column(
              children: [
                (action == Action.signIn)
                    ? Text("Add @${inputUsername.text} account to this app?")
                    : Text(
                        "Are you sure you want to create new account @${inputUsername.text} for ${inputEmail.text} email?"),
                if (finishError != null) const SizedBox(height: 8.0),
                if (finishError != null)
                  Text(
                    finishError!.string,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
