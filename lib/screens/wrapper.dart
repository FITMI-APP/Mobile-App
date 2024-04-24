import 'package:flutter/cupertino.dart';
import 'package:grad/models/user.dart';
import 'package:grad/screens/authenticate/authenticate.dart';
import 'package:grad/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);

    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
