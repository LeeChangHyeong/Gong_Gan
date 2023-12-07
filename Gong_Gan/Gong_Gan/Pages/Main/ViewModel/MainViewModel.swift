//
//  MainViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class MainViewModel {
    let addMemoButtonTapped = PublishRelay<Void>()
    let addGalleryButtonTapped = PublishRelay<Void>()
    let addSettingButtonTapped = PublishRelay<Void>()
    let selectedBackgroundImage = BehaviorRelay<String?>(value: nil)
    
    
    func updateSelectedImageName(_ name: String) {
        selectedBackgroundImage.accept(name)
        }
    
    func getWeather(lat: Double, lon: Double) -> Observable<WeatherModel> {
        let apiUrl = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "appid": Keys.weatherKey
        ]
        
        return RxAlamofire
            .data(.get, apiUrl, parameters: parameters)
            .observe(on: MainScheduler.instance)
            .map { data -> WeatherModel in
                    let decoder = JSONDecoder()
                let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                return weatherModel
            }
    }
}
