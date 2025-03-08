class Weather {
  final String cityName;
  final double temperature;
  final double temp_max;
  final double temp_min;
  final int date;
  final String main;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.temp_max,
    required this.temp_min,
    required this.date,
    required this.main,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      date: json['dt'] as int,
      main: json['weather'][0]['main'] as String,
      temp_max: (json['main']['temp_max'] as num).toDouble(),
      temp_min: (json['main']['temp_min'] as num).toDouble(),
      icon: json['weather'][0]['icon'] as String
    );
  }
}
