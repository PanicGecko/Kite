//
//  MultipartFormDataRequest.swift
//  Kite
//
//  Created by Adam on 2/3/24.
//

import Foundation


struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    private var body = ""
    private var httpBody = NSMutableData()
    let url: URL

    init(url: URL) {
        self.url = url
    }

    mutating func addTextField(named name: String, value: String) {
        httpBody.append("--\(boundary)\r\n")
        httpBody.append("Content-Disposition:form-data; name=\"\(name)\"")
        httpBody.append("\r\n\r\n\(value)\r\n")
//        body += "--\(boundary)\r\n"
//        body += "Content-Disposition:form-data; name=\"\(name)\""
//        body += "\r\n\r\n\(value)\r\n"
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: application/json; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    mutating func addDataField(named name: String, data: Data, mimeType: String, imgId: String) {
        let strData = data.base64EncodedString(options: .lineLength64Characters)
//        if String(data: data.description.utf8, encoding: .utf8) == nil {
//            print("addDataField is null")
//        }
        httpBody.append("--\(boundary)\r\n")
        httpBody.append("Content-Disposition:form-data; name=\"\(name)\"")
        httpBody.append("; filename=\"\("paramSrc")\"\r\n"
                        + "Content-Type: \"\(imgId)\"\r\n\r\n")
//        httpBody.append(String(data: data, encoding: .utf8)!)
        httpBody.append(data.base64EncodedString())
        httpBody.append("\r\n")
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"\(name)\""
        body += "; filename=\"\("paramSrc")\"\r\n"
        + "Content-Type: \"content-type header\"\r\n\r\n\(strData)\r\n"
    }

    private func dataFormField(named name: String,
                               data: Data,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
    
    mutating func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        httpBody.append("--\(boundary)--")
//        body.append("--\(boundary)--")
//        request.httpBody = body.data(using: .utf8)
        request.httpBody = httpBody as Data
        return request
    }
}

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
