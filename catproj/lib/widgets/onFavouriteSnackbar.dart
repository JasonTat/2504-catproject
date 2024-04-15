// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:catproj/main.dart';

class OnFavouriteSnackbar {


  void show() {
    print(scaffoldMessengerKey.currentState);
    print(scaffoldMessengerKey.currentWidget);
    scaffoldMessengerKey.currentState?.showSnackBar(createSnackBar());
  }

  SnackBar createSnackBar(){
  return const SnackBar(
    duration:  Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    content:  Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Text('Favourited!'),
      ],
    ),
    // action: SnackBarAction(
    //     label: 'undo',
    //     onPressed: () {
    //       print('fact favourited');
    //     },
    //   ),
  );
}
}