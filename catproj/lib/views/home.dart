
import 'package:catproj/widgets/onFavouriteSnackbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:catproj/services/restapi.dart';
import 'package:catproj/services/db-service.dart';

import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;


class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {

  final RestAPIService restAPIService = RestAPIService();
  final SQFliteDbService databaseService = SQFliteDbService();
  List<Map<String, dynamic>> listOfFactsToAdd = [];
  String catFact = "";
  String catFactToAddToDb = "";



  @override
  void initState() {
    print('HomeView initState begin');
    super.initState();
    getOrCreateDbAndDisplayToConsole();
    initializeFactOnStartup();    
  }

  void getOrCreateDbAndDisplayToConsole() async {
    print('HomeView getOrCreateDbAndDisplayToConsole start');
    await databaseService.getOrCreateDb();
    listOfFactsToAdd = await databaseService.getAllFactsFromDb();
    await databaseService.printAllRecordsInDbToConsole();
    print('HomeView getOrCreateDbAndDisplayToConsole end');
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    print('homeview build start');
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 100),
                padding: const EdgeInsets.all(15.0),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Text(
                    catFact,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                    fontSize: 25.0,                  
                    )
                  ),
                ),                
              ),
            ),
            Container(
              width: 300,
              height: 37,
              margin: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                child: const Text(
                'new cat fact',
                ),
                onPressed: () async {
                  var data = await restAPIService.getRestfulAPIData();
                  updateFact(data);
                  print('this is fact: $catFact');
                },
              ),  
            ),   
            Container(
              width: 75,
              height: 50,
              margin: const EdgeInsets.only(bottom: 150),
              child: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () async {
                  await databaseService.insertFact({
                    'catFacts': catFact
                  });
                  await databaseService.printAllRecordsInDbToConsole();   


                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  OnFavouriteSnackbar().show();                  

                },
              ),  
            ), 

          ],
          

          
    );
    
  }

  void updateFact(dynamic data){
    catFact = data['data'][0];
    setState((){});
  }

  void initializeFactOnStartup() async {
    print('fact initialized on startup');
    var data = await restAPIService.getRestfulAPIData();
    updateFact(data);
  }









}