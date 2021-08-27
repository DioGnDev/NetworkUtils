//
//  Networking.swift
//
//  Created by Ilham Hadi Prabawa on 28/04/21.
//

import Foundation

public enum Method: String{
  case GET
  case POST
  case DELETE
}

public class Networking {
  
  //singleton
  public static let sharedInstance = Networking()
  
  //URLSession
  private let defaultSession = URLSession(configuration: .default)
  
  //URLSessionTask
  public private (set) var dataTask: URLSessionDataTask?
  public private (set) var downloadTask: URLSessionDownloadTask? = nil
  public private (set) var uploadTask: URLSessionUploadTask? = nil
  
  public func request(with componentURL: ComponentURL,
                      method: Method? = .GET,
                      headers: [String: String]? = nil,
                      params: [String: Any]? = nil,
                      completion: @escaping(Result<Data?, NError>) -> Void){
    dataTask?.cancel()
    
    guard let url = componentURL.getURL else { return }
    
    //create request
    var request = URLRequest(url: url)
    if let method = method {
      request.httpMethod = method.rawValue
    }else {
      request.httpMethod = Method.GET.rawValue
    }
    
    //check if header exists
    if let headers = headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let response = response as? HTTPURLResponse,
            let data = data
      else { return }
      
      switch response.statusCode {
      case (200 ... 299):
        completion(.success(data))
        //Log response
        guard let jsonStr = String(data: data, encoding: .utf8) else { return }
        print(jsonStr)
      default:
        completion(.failure(.internalServerError))
        break
      }
    })
    
    dataTask?.resume()
  }
}

