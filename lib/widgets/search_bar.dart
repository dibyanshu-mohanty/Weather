import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:weather/services/local_data.dart';


class SearchCity extends StatefulWidget {
  const SearchCity({Key? key}) : super(key: key);

  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 6.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios)),
                    Text("Find Weather of your Fav City",style: TextStyle(fontSize: 19.0),),
                  ],
                ),
                AnimSearchBar(
                  width: MediaQuery.of(context).size.width * 0.9,
                  textController: textController,
                  rtl: true,
                  suffixIcon: Icon(Icons.search),
                  onSuffixTap: () {
                    Navigator.pop(context,textController.text);
                  },
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.asset("assets/images/cityscape.png",fit: BoxFit.cover,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
