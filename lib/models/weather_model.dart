class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double description;
  final double humidity;
  final double low;
  final double high;
  final double feels_like;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.low,
    required this.high,
    required this.feels_like,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['weather'][0]['main'],
      temperature: json['main']['temp'],
      description: json['clouds']['all'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      feels_like: json['main']['feels_like'],
    );
  }
}
