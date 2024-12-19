//
//  ODLDecoder.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

class ODLDecoder: JSONDecoder {
    override init() {
        super.init()
        configure()
    }
    
    func configure() {
        dateDecodingStrategy = .custom({ (decoder) -> Date in
            let dateString = try decoder.singleValueContainer().decode(String.self)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate, .withFullTime]
            
            let formatterFractionalSeconds = ISO8601DateFormatter()
            formatterFractionalSeconds.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]

            let formatterWithoutTime = DateFormatter()
            formatterWithoutTime.dateFormat = "yyyy-MM-dd"
            
            if let date = formatter.date(from: dateString) {
                return date
            } else if let date = formatterFractionalSeconds.date(from: dateString) {
                return date
            } else if let date = formatterWithoutTime.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not convert string to Date"))
            }
        })
    }
}
