import RxSwift
import Foundation
import Alamofire

final class NetworkManager {
    
    func fetch<T: Decodable>(url: String, parameters: [String: Any]?) -> Observable<T> {
        return Observable.create { observer in
            guard var urlRequest = try? URLRequest(url: url, method: .get) else {
                observer.onError(NetworkError.invalidResponse)
                return Disposables.create()
            }
            urlRequest.timeoutInterval = 10
            
            let encodedRequest = try? URLEncoding.default.encode(urlRequest, with: parameters)
            
            let request = AF.request(encodedRequest ?? urlRequest)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("Received JSON:\n\(jsonString)")
                        } else {
                            print("Failed to parse JSON for logging")
                        }
                        
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(decodedResponse)
                            observer.onCompleted()
                        } catch {
                            print("Failed to decode response: \(error)")
                            observer.onError(NetworkError.decodingFailed(error))
                        }
                        
                    case .failure(let error):
                        print("Network request failed: \(error)")
                        observer.onError(NetworkError.networkFailure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

enum NetworkError: Error {
    case networkFailure(Error)
    case decodingFailed(Error)
    case invalidResponse
}
