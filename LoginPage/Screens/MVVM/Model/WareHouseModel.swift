//
//  WareHouseModel.swift
//  LoginPage
//
//  Created by Digitalflake on 23/12/24.
//

import Foundation
struct House: Codable {
    var warehouseID: Int?
    var warehouseName: String?
    var warehouseDescription: JSONNull?
    var cityID: Int?
    var cutOffTime: String?
    var status, createdBy, updatedBy: Int?
    var createdDate, updatedDate: String?

    enum CodingKeys: String, CodingKey {
        case warehouseID = "warehouse_id"
        case warehouseName = "warehouse_name"
        case warehouseDescription = "warehouse_description"
        case cityID = "city_id"
        case cutOffTime = "cut_off_time"
        case status
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.warehouseID, forKey: .warehouseID)
        try container.encodeIfPresent(self.warehouseName, forKey: .warehouseName)
        try container.encodeIfPresent(self.warehouseDescription, forKey: .warehouseDescription)
        try container.encodeIfPresent(self.cityID, forKey: .cityID)
        try container.encodeIfPresent(self.cutOffTime, forKey: .cutOffTime)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.createdBy, forKey: .createdBy)
        try container.encodeIfPresent(self.updatedBy, forKey: .updatedBy)
        try container.encodeIfPresent(self.createdDate, forKey: .createdDate)
        try container.encodeIfPresent(self.updatedDate, forKey: .updatedDate)
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.warehouseID = try container.decodeIfPresent(Int.self, forKey: .warehouseID)
        self.warehouseName = try container.decodeIfPresent(String.self, forKey: .warehouseName)
        self.warehouseDescription = try container.decodeIfPresent(JSONNull.self, forKey: .warehouseDescription)
        self.cityID = try container.decodeIfPresent(Int.self, forKey: .cityID)
        self.cutOffTime = try container.decodeIfPresent(String.self, forKey: .cutOffTime)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.createdBy = try container.decodeIfPresent(Int.self, forKey: .createdBy)
        self.updatedBy = try container.decodeIfPresent(Int.self, forKey: .updatedBy)
        self.createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        self.updatedDate = try container.decodeIfPresent(String.self, forKey: .updatedDate)
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
