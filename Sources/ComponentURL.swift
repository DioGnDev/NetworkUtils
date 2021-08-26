//
//  ComponentURL.swift
//  Coinin
//
//  Created by Ilham Hadi Prabawa on 28/04/21.
//

import Foundation

public class ComponentURL {
  
  private var scheme = ""
  private var host = ""
  private var path = ""
  
  public init(scheme: String = "https", host: String = "", path: String) {
    self.scheme = scheme
    self.host = host
    self.path = path
  }
  
  lazy var getPath: String = {
    return self.path
  }()
  
  lazy var getScheme: String = {
    return self.scheme
  }()
  
  lazy var getHost: String = {
    return self.host
  }()
  
  lazy var getURL: URL? = {
    return URL(string: "\(scheme)://\(host)\(path)")
  }()
  
  public func setPath(_ path: String) {
    self.path = path
  }
  
  public func setScheme(_ scheme: String) {
    self.scheme = scheme
  }
  
  public func setHost(_ host: String) {
    self.host = host
  }
  
}
