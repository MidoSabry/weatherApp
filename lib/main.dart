import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temparature = 0;
  String location = "London";
  int woeid = 44418;
  String weather = "clear";
  String abbreviation = " ";
  String errorMsg = " ";

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
  }

  void fetchSearch(String input) async {
    try {
      var searchResults = await http.get(searchApiUrl + input);
      var result = json.decode(searchResults.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMsg = '';
      });
    } catch (error) {
      errorMsg = "Sorry , we don`t have the data";
    }
  }

  void fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolatedweather = result["consolidated_weather"];
    var data = consolatedweather[0];

    setState(() {
      temparature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
    });
  }

  void onTextFieldSubmitted(String input) async {
    // ignore: await_only_futures
    await fetchSearch(input);
    // ignore: await_only_futures
    await fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/$weather.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      temparature.toString() + 'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      location,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input) {
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      decoration: InputDecoration(
                          hintText: "Search another location",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          prefixIcon: Icon(Icons.search, color: Colors.white)),
                    ),
                  ),
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.red),
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
