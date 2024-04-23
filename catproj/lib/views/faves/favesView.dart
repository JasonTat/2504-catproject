import 'package:flutter/material.dart';
import 'dart:async';
import 'package:catproj/services/restapi.dart';
import 'package:catproj/services/db-service.dart';

class Faves extends StatefulWidget {
  @override
  FavesState createState() => FavesState(); 
}

class FavesState extends State<Faves> {
  final RestAPIService restAPIService = RestAPIService();
  final SQFliteDbService databaseService = SQFliteDbService();
  List<Map<String, dynamic>> faveListOfFacts = [];

  @override
  void initState () {
    print('Faves initstate begin');
    super.initState();
    getOrCreateDbAndDisplayToConsole();
    createInitRecord();
  }
  void getOrCreateDbAndDisplayToConsole() async {
    print('fave getOrCreateDbAndDisplayToConsole start');
    await databaseService.getOrCreateDb();
    faveListOfFacts = await databaseService.getAllFactsFromDb();
    await databaseService.printAllRecordsInDbToConsole();
    print('fave getOrCreateDbAndDisplayToConsole end');
    setState(() {});
  }

 void createInitRecord() async {
  print('adding init record');
  String initFact = 'Cat test';
  await databaseService.insertFact({
    'catfacts': initFact
  });
  await databaseService.printAllRecordsInDbToConsole();  
  setState((){});
 }

  @override
  Widget build(BuildContext context) {
    print('Faves build begins');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourite Facts'
        ),          
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text('Clear Favourites List'),
            onPressed: () async {
              await databaseService.deleteDb();
              await databaseService.getOrCreateDb();
              faveListOfFacts = await databaseService.getAllFactsFromDb();
              await databaseService.printAllRecordsInDbToConsole();
              setState((){});
            }
          ),
          //for testing
          // ElevatedButton(
          //   child: const Text('create initial record'),
          //   onPressed: () {
          //     createInitRecord();
          //     setState(() {
                
          //     });
          //   }
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: faveListOfFacts.length,
              itemBuilder: (BuildContext context, index){
                return  Card(
                  child: ListTile(
                    title: Text(
                      '${faveListOfFacts[index]['catfacts']}'
                    ),
                    trailing:  IconButton(
                      iconSize: 25,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState((){
                          removeFromDb(faveListOfFacts[index], index);
                        });
                      },
                    )
                  )
                );
              },
            )
          ),
        ]
      )
    );       
  }

  void removeFromDb(dynamic fact, index) async {
    String data = fact['catfacts'];
    print('removed this: $data');
    print(faveListOfFacts.length);
    await databaseService.deleteRecord({
      'catfacts': data,
      'id': index
    });
    setState(() {});
  }





}