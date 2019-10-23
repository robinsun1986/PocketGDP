//
//  AllCountryGDPResponse.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

struct CountryGDP : Decodable {
    let gdp: Double
    let countryName: String
    let countryId: String
    let year: String
    
    // MARK: - Codable
    // Coding Keys
    private enum CodingKeys: String, CodingKey {
        case country = "country"
        case id = "id"
        case value = "value"
        case date = "date"
    }
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gdp = try container.decode(Double.self, forKey: .value)
        year = try container.decode(String.self, forKey: .date)
        let countryContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .country)
        countryId = try countryContainer.decode(String.self, forKey: .id)
        countryName = try countryContainer.decode(String.self, forKey: .value)
    }
}

struct AllCountryGDPResponse: Decodable {
    // MARK: - Properties
    var items = [CountryGDP]()
    
    // Coding Keys
    private enum CodingKeys: CodingKey {
    }
    
    private struct DummyCodable: Codable {}
    
    // Decoding
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        while !container.isAtEnd {
            if var unkeyedContainer = try? container.nestedUnkeyedContainer() {
                while !unkeyedContainer.isAtEnd {
                    if let item = try? unkeyedContainer.decode(CountryGDP.self) {
                        items.append(item)
                    } else {
                        _ = try? unkeyedContainer.decode(DummyCodable.self)
                    }
                }
            } else {
                _ = try? container.decode(DummyCodable.self)
            }
        }
    }
}
