//
//  CSVDecoder.swift
//  KMPK
//
//  Created by Karol Bukowski on 09.02.2018.
//  Copyright © 2018 Karol Bukowski. All rights reserved.
//

import Foundation

class CSVDecoder {
    private typealias CSV = [[String : String]]
    
    init() {}
    
    func decode<T>(type: T.Type, from data: Data) throws -> T {
        switch type {
        case is [OPLivePositions].Type:
            return try CSVDecoder.decode(data: data) as [OPLivePositions] as! T
        case is [OPStationPositions].Type:
            return try CSVDecoder.decode(data: data) as [OPStationPositions] as! T
        default:
            fatalError("Not found decoder for \(T.self)")
        }
    }
    
    // MARK:- supported types
    private class func decode(data: Data) throws -> [OPLivePositions] {
        let csv = try CSVDecoder.parse(data, delimiter: ",", newLine: "\r\n")
        
        var output = [OPLivePositions]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        for row in csv {
            guard
                let _id = row["_id"],
                let id = Int(_id),
                let _vehicle = row["Nr_Boczny"],
                let vehicle = Int(_vehicle),
                let plate = row["Nr_Rej"],
                let squad = row["Brygada"],
                let line = row["Nazwa_Linii"],
                let _lat = row["Ostatnia_Pozycja_Szerokosc"],
                let lat = Double(_lat),
                let _long = row["Ostatnia_Pozycja_Dlugosc"],
                let long = Double(_long),
                let date = row["Data_Aktualizacji"],
                let updateDate = dateFormatter.date(from: date)
                else {
                    throw NSError(domain: "Serialization error", code: 0, userInfo: row)
            }
            
            output.append(OPLivePositions(id: id,
                                          vehicle: vehicle,
                                          plate: plate,
                                          squad: squad,
                                          line: line,
                                          lat: lat,
                                          long: long,
                                          updateDate: updateDate))
        }
        
        return output
    }
    
    private class func decode(data: Data) throws -> [OPStationPositions] {
        let csv = try CSVDecoder.parse(data, delimiter: ";", newLine: "\r\n")
        var output = [OPStationPositions]()
        
        for row in csv {
            guard
                let _id = row["ID Słupka"],
                let id = Int(_id),
                let _lat = row["Szerokość Geograficzna"],
                let lat = Double(_lat),
                let _long = row["Długość Geograficzna"],
                let long = Double(_long),
                let type = row["Typ Przystanku"]
                else {
                    throw NSError(domain: "Serialization error", code: 0, userInfo: row)
            }
            
            output.append(OPStationPositions(id: id,
                                             type: type,
                                             lat: lat,
                                             long: long))
        }
        
        return output
    }
}

// MARK:- parse helpers
extension CSVDecoder {
    private class func parse(_ data: Data, delimiter: Character, newLine: Character, encoding: String.Encoding = .utf8) throws -> CSV {
        guard let string = String(data: data, encoding: encoding) else {
            throw CSVDecoderError.corruptedData(row: 41)
        }
        
        return try parse(string, delimiter: delimiter, newLine: newLine)
    }
    
    private class func parse(_ string: String, delimiter: Character, newLine: Character) throws -> [[String : String]] {
        let rows = string.split(separator: newLine)
        var headers = [Substring]()
        var output = [[String : String]]()
        
        for (rowIndex, row) in rows.enumerated() {
            let cols = row.split(separator: delimiter, omittingEmptySubsequences: false)
            var dic = [String : String]()
            
            if cols.count != headers.count && rowIndex != 0 {
                throw CSVDecoderError.corruptedData(row: rowIndex)
            }
            
            for (colIndex, col) in cols.enumerated() {
                if rowIndex == 0 {
                    headers.append(col)
                } else {
                    dic[String(describing: headers[colIndex])] = String(describing: col)
                }
            }
            
            if rowIndex != 0 {
                output.append(dic)
            }
            
        }
        
        return output
    }
}

// MARK:- Error
extension CSVDecoder {
    enum CSVDecoderError: Error {
        case corruptedData(row: Int)
        case notFoundDecoder(forType: String)
    }
}
