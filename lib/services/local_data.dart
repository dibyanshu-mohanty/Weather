import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
const String apiKey = "3ec72171b250b5db22a26522d7638846";

Future<Position> currentLocation() async{
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

Future getCurrentWeather(BuildContext ctx) async{
  final latLon = await currentLocation().catchError((err){
    showDialog(context: ctx, builder: (context) => AlertDialog(
      title: Text("Oopsie !"),
      content: Text(err.toString()),
      actions: [
        IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.clear)),
      ],
    ));
  });;
  var lat = latLon.latitude;
  var lon = latLon.longitude;
  final url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";
  final http.Response response = await http.get(Uri.parse(url));
  if(response.statusCode==200){
    return jsonDecode(response.body);
  } else {
    return Future.error("Please Check your Network Connection & Try Again");
  }
}

String getWeatherImage(int condition){
  if (condition < 300) {
    return 'assets/images/cloudy.png';
  } else if (condition <400){
    return "assets/images/lightning.png";
  } else if (condition < 600) {
    return 'assets/images/dark-and-stormy.png';
  } else if (condition < 700) {
    return 'assets/images/snowy.png';
  } else if (condition < 800) {
    return 'assets/images/fog.png';
  } else if (condition == 800) {
    return 'assets/images/sun.png';
  } else if (condition <= 804) {
    return 'assets/images/cloudy.png';
  } else {
    return "assets/images/common.png";
  }
}

Future getCityWeather(String city) async{
  final url = "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey";
  final http.Response response = await http.get(Uri.parse(url));
  if(response.statusCode==200){
    return jsonDecode(response.body);
  } else {
    return Future.error("Please Check your Network Connection & Try Again");
  }
}