//
//  WeatherModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/6/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
