import 'dart:developer' as developer;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/providers/lib/providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  TextEditingController textController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isLandscape = screenSize.width > screenSize.height;
    
    // Get the current city from provider
    final currentCity = ref.watch(currentCityProvider);
    
    // Watch the weather data based on current city
    final weatherData = ref.watch(weatherProvider(currentCity));

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3366FF), // Top gradient color
                Color(0xFFFF9933), // Bottom gradient color
              ],
            ),
          ),
          child: isLandscape 
              ? _buildLandscapeLayout(weatherData, screenSize, isSmallScreen)
              : _buildPortraitLayout(weatherData, screenSize, isSmallScreen),
        ),
      ),
    );
  }

  // Layout for portrait orientation
  Widget _buildPortraitLayout(AsyncValue weatherData, Size screenSize, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05, // 5% of screen width
      ),
      child: Column(
        children: [
          // Search bar at the top with responsive sizing
          Padding(
            padding: EdgeInsets.only(
              top: screenSize.height * 0.02, // 2% of screen height
            ),
            child: AnimSearchBar(
              rtl: true,
              width: screenSize.width * 0.9, // 90% of screen width
              color: Color(0xffffb56b),
              textController: textController,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: isSmallScreen ? 22 : 26,
              ),
              onSuffixTap: _handleSearch,
              onSubmitted: (_) {},
              style: TextStyle(color: Colors.red),
            ),
          ),
          
          SizedBox(height: screenSize.height * 0.03), // 3% of screen height
          
          // Weather content
          Expanded(
            child: _buildWeatherContent(
              weatherData, 
              isSmallScreen ? 0.8 : 1.0, // Text size scale factor
              isLandscape: false,
            ),
          ),
        ],
      ),
    );
  }

  // Layout for landscape orientation
  Widget _buildLandscapeLayout(AsyncValue weatherData, Size screenSize, bool isSmallScreen) {
    return Row(
      children: [
        // Left side with search
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Search bar
                AnimSearchBar(
                  rtl: true,
                  width: screenSize.width * 0.4, // 40% of screen width
                  color: Color(0xffffb56b),
                  textController: textController,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  onSuffixTap: _handleSearch,
                  onSubmitted: (_) {},
                  style: TextStyle(color: Colors.red),
                ),
                
                SizedBox(height: screenSize.height * 0.05),
                
                // Location button
                ElevatedButton.icon(
                  onPressed: showCurrentLocationWeather,
                  icon: Icon(Icons.my_location),
                  label: Text(
                    "Use My Location",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right side with weather info
        Expanded(
          flex: 3,
          child: _buildWeatherContent(
            weatherData, 
            isSmallScreen ? 0.7 : 0.9, // Text size scale factor
            isLandscape: true,
          ),
        ),
      ],
    );
  }

  // Weather content (used in both layouts)
  Widget _buildWeatherContent(AsyncValue weatherData, double textScaleFactor, {required bool isLandscape}) {
    return weatherData.when(
      data: (weather) {
        return Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/location.svg',
                      color: Colors.white,
                      width: 20 * textScaleFactor,
                      height: 20 * textScaleFactor,
                    ),
                    SizedBox(width: 10 * textScaleFactor),
                    Text(
                      weather.city,
                      style: TextStyle(
                        fontSize: 27 * textScaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12 * textScaleFactor),
                Text(
                  weather.desc,
                  style: TextStyle(
                    fontSize: 16 * textScaleFactor,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 15 * textScaleFactor),
                Text(
                  '${weather.temp}°C',
                  style: TextStyle(
                    fontSize: 30 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Only show the location button in portrait mode
                if (!isLandscape) ...[
                  SizedBox(height: 30 * textScaleFactor),
                  ElevatedButton.icon(
                    onPressed: showCurrentLocationWeather,
                    icon: Icon(Icons.my_location),
                    label: Text("Use My Location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: $error',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Handle search functionality
  void _handleSearch() {
    if (textController.text.isNotEmpty) {
      // Update the city provider which will trigger a rebuild
      ref.read(currentCityProvider.notifier).state = textController.text;
      developer.log("Searching for city: ${textController.text}");
    } else {
      developer.log("No city entered");
    }
    FocusScope.of(context).unfocus();
    textController.clear();
  }

  void showCurrentLocationWeather() {
    // Watch the current location weather provider
    ref.read(currentLocationWeatherProvider.future).then((weather) {
      // Update the city provider with the current location's city name
      ref.read(currentCityProvider.notifier).state = weather.city;
    }).catchError((error) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $error')),
      );
    });
  }
}