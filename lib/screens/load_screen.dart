import 'package:flutter/material.dart';
import 'package:weather/screens/home_screen.dart';
import 'package:weather/services/local_data.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });
  }

  void fetchData() async{
    final response = await getCurrentWeather(context).catchError((err){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Oopsie !"),
        content: Text(err.toString()),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear)),
        ],
      ));
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(weatherData: response,)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12.0,horizontal: 5.0),
                height: MediaQuery.of(context).size.height * 0.45,
                child: Image.asset("assets/images/common.png",fit: BoxFit.cover,),
              ),
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Text("WEATHER"),
              ),
            ),
            SizedBox(
              width: 80.0,
              child: LinearProgressIndicator(),
            ),
          ],
        )
    );
  }
}
