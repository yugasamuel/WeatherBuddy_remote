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
}
