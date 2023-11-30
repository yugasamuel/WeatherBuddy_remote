//
//  WeatherManager.swift
//  WeatherBuddy
//
//  Created by Yuga Samuel on 30/11/23.
//

import Foundation
import WeatherKit

@Observable class WeatherManager {
    private let weatherService = WeatherService()
    var weather: Weather?
    
    func getWeather(lat: Double, long: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) { [weak self] in
                return try await self?.weatherService.weather(for: .init(latitude: lat, longitude: long))
            }.value
            
            let attribution = try await weatherService.attribution
            
        } catch {
            print("Failed to get weather data. \(error)")
        }
    }
    
    var condition: String {
        guard let condition = weather?.currentWeather.condition else { return "--" }
        
        return condition.description
    }
    
    var icon: String {
        guard let iconName = weather?.currentWeather.symbolName else { return "--" }
        
        return iconName
    }
    
    var temperature: String {
        guard let temp = weather?.currentWeather.temperature else { return "--" }
        let convert = temp.converted(to: .celsius).value
        
        return String(Int(convert)) + "°C"
    }
    
    var humidity: String {
        guard let humidity = weather?.currentWeather.humidity else { return "--" }
        let computedHumidity = humidity * 100
        
        return String(Int(computedHumidity)) + "%"
    }
}
