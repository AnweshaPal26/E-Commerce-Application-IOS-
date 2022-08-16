//
//  NetworkManager.swift
//  Frashly
//
//

import Foundation
import UIKit

final class NetworkManager {
    func getApiData<T:Decodable>(requestUrl: URLRequest, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                //parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result)
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                    counter = false
                }
            }
            
            }.resume()
    }
    
    func postSignup(requestUrl: URL, requestBody: Data)
    {
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            
            if let httpResponse = httpUrlResponse as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            {
                print("Signup Successfull")
                DispatchQueue.main.async{
                    let alertController = UIAlertController(title: "SUCCESS", message: "Your account is successfully created. Now Please log in with your credentials ", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    alertController.presentInOwnWindow(animated: true, completion: {
                        print("completed")
                    })
                }
            }
            else{
                print("please enter valid crenedtials")
                DispatchQueue.main.async{
                    let alertController = UIAlertController(title: "Alert", message: "An account with this Email already exists", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    alertController.presentInOwnWindow(animated: true, completion: {
                        print("completed")
                    })
                }
                
                
            }
            }.resume()
        
    }
    func postLogin<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if let httpResponse = httpUrlResponse as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            {
                print("Login Successfull")
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
                
            }
            else{
                print("please enter valid crenedtials")
                DispatchQueue.main.async{
                    let alertController = UIAlertController(title: "Alert", message: "Please enter Valid credentials", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    alertController.presentInOwnWindow(animated: true, completion: {
                        print("completed")
                    })
                }
            }
            }.resume()
    }
    func postResetPassword<T:Decodable>(requestUrl: URLRequest, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = requestUrl
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if let httpResponse = httpUrlResponse as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
                
            }
            else{
                print("some thing went wrong")
            }
            }.resume()
    }
    func deleteRequest(requestUrl: URLRequest, requestBody: Data)
    {
        
        var urlRequest = requestUrl
        urlRequest.httpMethod = "delete"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            
            if let httpResponse = httpUrlResponse as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            {
                print("Deletion Successfull")
            }
            else{
                print("something went wrong")
                counter = false
            }
            }.resume()
        
    }
    func addRequest(requestUrl: URLRequest, requestBody: Data)
    {
        
        var urlRequest = requestUrl
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            
            if let httpResponse = httpUrlResponse as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            {
                print("adding Successfull")
            }
            else{
                print("something went wrong")
                counter = false
            }
            }.resume()
        
    }
    
    func decode(_ token: String) -> [String: AnyObject]? {
        let string = token.components(separatedBy: ".")
        let toDecode = string[1] as String
        
        
        var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
        stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
        switch (stringtoDecode.utf16.count % 4) {
        case 2: stringtoDecode = "\(stringtoDecode)=="
        case 3: stringtoDecode = "\(stringtoDecode)="
        default: // nothing to do stringtoDecode can stay the same
            print("")
        }
        let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
        let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)
        
        var values: [String: AnyObject]?
        if let string = base64DecodedString {
            if let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) {
                values = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, AnyObject>
            }
        }
        return values
    }

    
    
}
