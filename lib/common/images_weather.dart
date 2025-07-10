String getWeatherImage(String description) {
  description = description.toLowerCase();

  if (description.contains("clear")) {
    return 'assets/images/clear-sky.png';
  } else if (description.contains("clouds")) {
    return 'assets/images/cloudy.png';
  } else if (description.contains("sun") || description.contains("sunny")) {
    return 'assets/images/sun.png';
  } else if (description.contains("storm") || description.contains("thunder")) {
    return 'assets/images/storm.png';
  } else if (description.contains("rain")) {
    return 'assets/images/rain.png';
  } else {
    return 'assets/images/clouds.png'; // default fallback
  }
}
