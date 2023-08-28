import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpobject;
import 'package:githubapiassignment9/Requestdata.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 // String? URL = 'https://api.github.com/users/';
  bool hasentered = false;
  final TextEditingController userinput = TextEditingController();
   bool isloading = false;
   //'https://api.github.com/users/$userinput.text'
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top:60),
            child: const Center(
              child: Text("Github Searcher", style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,color: Colors.lightBlue))
            )
          ),
          Container(
            margin: EdgeInsets.only(top:30),
            width: double.infinity,
              child: Flexible(
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(left: 15, right : 15), width: 250,child: TextField(controller : userinput, decoration : InputDecoration(hintText: "Please enter a Username", border: OutlineInputBorder()),)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          onPressed: () =>{
                            setState(() {
                              if(userinput.text == "")
                              {
                                print("Enter something");
                                hasentered = false;
                              }else{
                                hasentered = true;
                              }
                            })
                          },
                          child: Text('Search', style: TextStyle(color: Colors.black)))
                    ],
                  )
              )
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child:
             Flexible(
                child:
                    hasentered ? FutureBuilder<List<dynamic>>(
                        future: Getuserdata(),
                        builder: (context, AsyncSnapshot snapped) {
                          if(snapped.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          }else if(snapped.hasError)
                            {
                              return Text('Error found - ${snapped.error}');
                            }else {
                            return ListView.builder(
                              itemCount: snapped.data!.length,
                              itemBuilder: (context, index) {
                                ListTile(
                                  leading: Image.network(snapped.data![index]['avatar_url']),
                                    title: Text(snapped.data![index]['Name']),
                                  subtitle: Text(snapped.data![index]['location']),
                                );
                              },
                            );
                          }
                    }) :  const Center(
                        child: Text("Nothing was done yet")
                    )

              )
          )
        ],
      )
    );
  }
  Future<List<dynamic>> Getuserdata() async{
    List<Userdata> dataofuser = [];
      final Data = await httpobject.get(Uri.parse("https://api.github.com/users"));
      if(Data.statusCode == 200)
        {
          return jsonDecode(Data.body);
        }else{
        print('Something went wrong with the api');
      }
      /*var responseData =  jsonDecode(Data.body);
      for( var userdata in responseData)
        {
          Userdata user = Userdata(
              Username: userdata["login"],
              Name: userdata["name"],
              Location: userdata["location"]
          );
          dataofuser.add(user);
        }
       */
    return Future.value([]);
  }
}
