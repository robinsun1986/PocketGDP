//
//  AllCountryGDPResponse.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

struct CountryRegion: Decodable, Equatable, Hashable {
    let id: String
    let name: String
    
    // MARK: - Codable
    // Coding Keys
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case id = "id"
    }
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .value)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Country: Decodable, Equatable {
    let id: String
    let name: String
    let region: CountryRegion
    
    // MARK: - Codable
    // Coding Keys
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case iso2Code = "iso2Code"
        case region = "region"
    }
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .iso2Code)
        name = try container.decode(String.self, forKey: .name)
        region = try container.decode(CountryRegion.self, forKey: .region)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AllCountryResponse: Decodable {
    // MARK: - Properties
    var items = [Country]()
    
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
                    if let item = try? unkeyedContainer.decode(Country.self) {
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
