import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  CityScreenState createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen> {
  String? cityName;
  Icon infoIcon = const Icon(Icons.arrow_upward, size: 40.0);
  double containerPosition = -350; // Initial off-screen position

  void toggleContainer() {
    setState(() {
      containerPosition = containerPosition < 0 ? 0 : -350;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('images/mapview.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.5), BlendMode.dstATop),
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 50.0,
                        color: kTopMenuIconColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                      decoration: kTextInputDecoration,
                      onChanged: (value) {
                        cityName = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, cityName);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white38,
                        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                      ),
                      child: const Text(
                        'Get Weather',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          // Sliding up container
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: containerPosition, // Animated position
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 70.0),
              color: const Color(0x57050505),
              child: const Text(
                'Note: The weather information comes from the United States '
                'National Weather Service (NWS) and is only available for '
                'locations within the United States and US territories.',
                style: kMessageTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Button to trigger the sliding container
          Positioned(
            bottom: 30,
            right: 10,
            child: FloatingActionButton(
              onPressed: toggleContainer,
              backgroundColor: Colors.white38,
              child: const Icon(
                FontAwesomeIcons.info,
                size: 35.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
