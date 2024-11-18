//
//  UserDetailsModel.swift
//  LoginPage
//
//  Created by Digitalflake on 18/11/24.
//


import Foundation

// MARK: - Welcome
struct UserDetailsModel: Codable {
    let status: Int?
    let message: String?
    let result: Results?
}

// MARK: - Result
struct Results: Codable {
    let customerID: Int?
    let customerFirstName, customerLastName: String?
    let avatar, blockComment: JSONNull?
    let mobile, email, registeredDate: String?
    let isNew, addressID: Int?
    let referralCode: String?
    let groupID: Int?
    let devicePlatform: String?
    let canRingBell, canSMSSend, canNotificationSend, canEmailSend: Int?
    let canWhatsappSend, blockStatus, status, userID: Int?
    let sourceName, sourceOfReferral: JSONNull?
    let isEmailVerified: Int?
    let customerBalance: CustomerBalance?
    let profileDetails: ProfileDetails?
    let defaultAddress: DefaultAddress?
    let proMembership: JSONNull?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case customerFirstName = "customer_first_name"
        case customerLastName = "customer_last_name"
        case avatar
        case blockComment = "block_comment"
        case mobile, email
        case registeredDate = "registered_date"
        case isNew = "is_new"
        case addressID = "address_id"
        case referralCode = "referral_code"
        case groupID = "group_id"
        case devicePlatform = "device_platform"
        case canRingBell = "can_ring_bell"
        case canSMSSend = "can_sms_send"
        case canNotificationSend = "can_notification_send"
        case canEmailSend = "can_email_send"
        case canWhatsappSend = "can_whatsapp_send"
        case blockStatus = "block_status"
        case status
        case userID = "user_id"
        case sourceName = "source_name"
        case sourceOfReferral = "source_of_referral"
        case isEmailVerified = "is_email_verified"
        case customerBalance, profileDetails
        case defaultAddress = "default_address"
        case proMembership = "pro_membership"
    }
}

// MARK: - CustomerBalance
struct CustomerBalance: Codable {
    let walletBalance: Double?
    let cashbackBalance: Int?
    let cashbackMessage: String?

    enum CodingKeys: String, CodingKey {
        case walletBalance = "wallet_balance"
        case cashbackBalance = "cashback_balance"
        case cashbackMessage = "cashback_message"
    }
}

// MARK: - DefaultAddress
struct DefaultAddress: Codable {
    let customerAddressID, customerID, warehouseID, clusterID: Int?
    let clusterName: String?
    let cityID: Int?
    let cityName, stateName: String?
    let areaID: Int?
    let areaName: String?
    let pinCode, subareaID: Int?
    let subareaName: String?
    let deliveryManagerID, isApartment: Int?
    let flatNo: String?
    let societyID: Int?
    let societyName: String?
    let deliveryBoyDetails: DeliveryBoyDetails?
    let firstName, address1, address2: String?
    let latitude, longitude: Double?
    let addressTag: String?
    let status, isDefault, createdBy, updatedBy: Int?

    enum CodingKeys: String, CodingKey {
        case customerAddressID = "customer_address_id"
        case customerID = "customer_id"
        case warehouseID = "warehouse_id"
        case clusterID = "cluster_id"
        case clusterName = "cluster_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case stateName = "state_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case pinCode = "pin_code"
        case subareaID = "subarea_id"
        case subareaName = "subarea_name"
        case deliveryManagerID = "delivery_manager_id"
        case isApartment = "is_apartment"
        case flatNo = "flat_no"
        case societyID = "society_id"
        case societyName = "society_name"
        case deliveryBoyDetails = "delivery_boy_details"
        case firstName = "first_name"
        case address1 = "address_1"
        case address2 = "address_2"
        case latitude, longitude
        case addressTag = "address_tag"
        case status
        case isDefault = "is_default"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
    }
}

// MARK: - DeliveryBoyDetails
struct DeliveryBoyDetails: Codable {
    let name, email, mobile: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case name, email, mobile
        case userID = "user_id"
    }
}

// MARK: - ProfileDetails
struct ProfileDetails: Codable {
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
