import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather2/models/weather_model.dart';
import 'package:weather2/services/weather_service.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('YOUR_API_KEY');
  Weather? _weather;
  // fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/loading.json';

    switch (mainCondition) {
      case 'Dust':
        return 'assets/dusty.json';
      case 'Clouds':
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Fog':
        return 'assets/cloud.json';
      case 'Rain':
      case 'Drizzle':
      case 'Shower Rain':
        return 'assets/rain.json';
      case 'Thunderstorm':
        return 'assets/thunder.json';
      case 'Clear':
        return 'assets/sunny.json';
      default:
        return 'assets/loading.json';
    }
  }

  // initial state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    _weather?.cityName ?? 'loading city...',
                    // 'Abbottabad',
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      fontSize: 60,
                      fontFamily: 'Augustus',
                    ),
                  ),
                ),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_weather?.temperature.round()}°C',
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Augustus',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Clouds ${_weather?.description.round()} %',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Augustus',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _weather?.mainCondition ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Augustus',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Humidity ${_weather?.humidity.round()} %',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Augustus'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Feels Like ${_weather?.feels_like.round()} C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Augustus',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition();
                    launch(
                        'https://weather.com/weather/today/l/${position.latitude},${position.longitude}');
                  },
                  child: Text(
                    'Weather Report',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Augustus',
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
