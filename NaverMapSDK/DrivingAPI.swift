//
//  DrivingAPI.swift
//  NaverMapSDK
//
//  Created by 황재영 on 11/1/23.
//

import Foundation
import NMapsMap

class DrivingAPI {

    static let shared = DrivingAPI()

    // API 키
    let apiKey = NMFAuthManager.shared().clientId



    func driveRoute(start: String, goal: String, option: String, apiKey: String, completion: @escaping (Any?, Error?) -> Void) {
        // 출발지와 목적지 좌표(경도, 위도, 옵션 형식)
        let urlString = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=\(start)&goal=\(goal)&option=\(option)"

        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                return
            }

            do {
                // JSON 데이터 파싱
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completion(json, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }


}
