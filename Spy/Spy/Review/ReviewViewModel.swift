//
//  ReviewViewModel.swift
//  Spy
//
//  Created by Вячеслав on 1/3/24.
//

import SwiftUI
import Alamofire

final class ReviewViewModel: ObservableObject {
    
    @Published var total_stars: Int = 5
    @Published var selected_stars: Int = 0
    
    @Published var last_selectedStar: Int = 0
    
    @Published var isShowButton: Bool = false
    @Published var isOpenEmail: Bool = false
    
    @AppStorage("isReviewedAlready") var isReviewedAlready: Bool = false
    
    var timerWorkItem: DispatchWorkItem?
    
    func resetTimer() {
        
        timerWorkItem?.cancel()
        
        timerWorkItem = DispatchWorkItem { [weak self] in
            
            self?.isShowButton = true
            self?.sendStar()
            self?.isReviewedAlready = true
        }
        
        if let timerWorkItem = timerWorkItem {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: timerWorkItem)
        }
    }
    
    func isGoodRate() -> Bool {
        
        return selected_stars <= 3 ? false : true
    }
    
    func sendStar() {
        
        let url = "https://spyappbackend1.site/api/feedback"
        
        let parameters: [String: Any] = [
            
            "token": "2ec61a22-855a-4f00-a561-5f2b6447653e",
            "stars": selected_stars,
            "text": ""
        ]
        
        let headers: HTTPHeaders = [
            
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("Pretty JSON: \(jsonString)")
                    }
                } else {
                    print("Failed to pretty print JSON")
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
