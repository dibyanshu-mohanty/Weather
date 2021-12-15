import 'package:flutter/material.dart';
import 'package:weather/constants.dart';
import 'package:weather/services/local_data.dart';
import 'package:intl/intl.dart';
import 'package:weather/widgets/search_bar.dart';
class HomeScreen extends StatefulWidget {
  final dynamic weatherData;
  const HomeScreen({Key? key, required this.weatherData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double temp = 0.0;
  String message = "";
  String imagePath = "";
  String cityName = "";
  double minTemp = 0.0;
  double maxTemp = 0.0;
  double feelTemp = 0.0;
  int humidity = 0;
  double windSpeed = 0.0;
  int visibility = 0;
  @override
  void initState() {
    super.initState();
    setUI(widget.weatherData);
  }

  void setUI(dynamic locationData) {
    if (locationData == null) {
      AlertDialog(
        title: Text("Oopsie !"),
        content: Text("Something Went Wrong !"),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear)),
        ],
      );
      return;
    }
    setState(() {
      temp = locationData['main']['temp'];
      message = locationData['weather'][0]['main'];
      int cond = locationData['weather'][0]['id'];
      imagePath = getWeatherImage(cond);
      cityName = locationData['name'];
      minTemp = locationData['main']['temp_min'];
      maxTemp = locationData['main']['temp_max'];
      feelTemp = locationData['main']['feels_like'];
      humidity = locationData['main']['humidity'];
      windSpeed = locationData['wind']['speed'] == 0 ? 0.0 : locationData['wind']['speed'];
      visibility = locationData['visibility'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHeightMaker,
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(child: Text(cityName,style: TextStyle(fontSize: 18.0),)),
                ),
                kHeightMaker,
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(child: Text(message,style: TextStyle(fontSize: 22.0),)),
                ),
                kHeightMaker,
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(imagePath,fit: BoxFit.cover,),
                ),
                kHeightMaker,
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Text(
                              temp.round().toString() + "°",
                              style: TextStyle(fontSize: 56.0),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "🔻" + minTemp.floor().toString() + "°",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "🔺"+ maxTemp.round().toString() + "°",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FEELS LIKE : " + feelTemp.round().toString() + "°",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          kSizedBox,
                          Text(
                            "HUMIDITY : " + humidity.round().toString() + " %",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          kSizedBox,
                          Text(
                            "WIND : " + windSpeed.round().toString() + " Km/h",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          kSizedBox,
                          Text(
                            "VISIBILITY : " + visibility.round().toString() +" m",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          kSizedBox,
                        ],
                      ),
                    ],
                  ),
                ),
                kHeightMaker,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                ),
                Text(DateFormat('EEEE').format(DateTime.now()),style: TextStyle(fontSize: 22.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var cityName = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCity())).catchError((err){
            // showDialog(context: context, builder: (context) => AlertDialog(
            //   title: Text("Oopsie !"),
            //   content: Text(err.toString()),
            //   actions: [
            //     IconButton(onPressed: (){
            //       Navigator.pop(context);
            //     }, icon: Icon(Icons.clear)),
            //   ],
            // ));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
          });
          if (cityName!=null){
            final cityData = await getCityWeather(cityName.toString());
            setUI(cityData);
          }
        },
        child: Icon(Icons.search),
      )
    );
  }
}
