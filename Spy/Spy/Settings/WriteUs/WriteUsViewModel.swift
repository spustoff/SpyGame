//
//  WriteUsViewModel.swift
//  Spy
//
//  Created by Вячеслав on 12/30/23.
//

import SwiftUI
import Alamofire

final class WriteUsViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var subject: String = ""
    @Published var message: String = ""
    
    @Published var textViewHeight: CGFloat = 100.0
    
    @Published var isLoading: Bool = false
    
    func sendEmail(completion: @escaping () -> (Void)) {
        
        isLoading = true
        
        let url = "https://mail.finanse.space/api/mail"
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""

        message += "\n\nApp version: \(version)(\(buildNumber))\nModel: \(UIDevice.current.model)\nOS version: \(UIDevice.current.systemVersion)"
        
        let parameters: [String: Any] = [
            
            "name": email,
            "email": email,
            "appCode": "spyappback",
            "subject": subject,
            "message": message
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(_):
                completion()
                self.isLoading = false
                print("Запрос успешно отправлен. Статус код: \(String(describing: response.response?.statusCode))")
            case .failure(let error):
                self.isLoading = false
                completion()
                print("Ошибка при отправке запроса: \(error)")
            }
        }
    }
}
