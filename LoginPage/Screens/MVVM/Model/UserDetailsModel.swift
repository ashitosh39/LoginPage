//
//  UserDetailsModel.swift
//  LoginPage
//
//  Created by Digitalflake on 07/01/25.
//

import Foundation
struct UserDetailsModel: Codable {
    let status: Int?
    let message: String?
    let userDetailsModelResult: UserDetailsModelResult?
    enum CodingKeys:String, CodingKey {
            case status
            case message
            case userDetailsModelResult = "result"
        }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.userDetailsModelResult = try container.decodeIfPresent(UserDetailsModelResult.self, forKey: .userDetailsModelResult)
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.userDetailsModelResult, forKey: .userDetailsModelResult)
    }
    
}

// MARK: - Result
struct UserDetailsModelResult: Codable {
    let customerID: Int?
    let customerFirstName, customerLastName: String?
//    let avatar, blockComment: JSONNull?
    let mobile, email, registeredDate: String?
    let isNew, addressID: Int?
    let referralCode: String?
    let groupID: Int?
    let devicePlatform: String?
    let canRingBell, canSMSSend, canNotificationSend, canEmailSend: Int?
    let canWhatsappSend, blockStatus, status, userID: Int?
//    let sourceName, sourceOfReferral: JSONNull?
    let isEmailVerified: Int?
    let customerBalance: CustomerBalance?
//    let profileDetails: ProfileDetails?
    let defaultAddress: DefaultAddress?
    
    
//    let proMembership: JSONNull?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case customerFirstName = "customer_first_name"
        case customerLastName = "customer_last_name"
//        case avatar
//        case blockComment = "block_comment"
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
//        case sourceName = "source_name"
//        case sourceOfReferral = "source_of_referral"
        case isEmailVerified = "is_email_verified"
        case customerBalance, profileDetails
        case defaultAddress = "default_address"
//        case proMembership = "pro_membership"
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.customerID, forKey: .customerID)
        try container.encodeIfPresent(self.customerFirstName, forKey: .customerFirstName)
        try container.encodeIfPresent(self.customerLastName, forKey: .customerLastName)
        try container.encodeIfPresent(self.mobile, forKey: .mobile)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.registeredDate, forKey: .registeredDate)
        try container.encodeIfPresent(self.isNew, forKey: .isNew)
        try container.encodeIfPresent(self.addressID, forKey: .addressID)
        try container.encodeIfPresent(self.referralCode, forKey: .referralCode)
        try container.encodeIfPresent(self.groupID, forKey: .groupID)
        try container.encodeIfPresent(self.devicePlatform, forKey: .devicePlatform)
        try container.encodeIfPresent(self.canRingBell, forKey: .canRingBell)
        try container.encodeIfPresent(self.canSMSSend, forKey: .canSMSSend)
        try container.encodeIfPresent(self.canNotificationSend, forKey: .canNotificationSend)
        try container.encodeIfPresent(self.canEmailSend, forKey: .canEmailSend)
        try container.encodeIfPresent(self.canWhatsappSend, forKey: .canWhatsappSend)
        try container.encodeIfPresent(self.blockStatus, forKey: .blockStatus)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.isEmailVerified, forKey: .isEmailVerified)
        try container.encodeIfPresent(self.customerBalance, forKey: .customerBalance)
//        try container.encodeIfPresent(self.profileDetails, forKey: .profileDetails)
        try container.encodeIfPresent(self.defaultAddress, forKey: .defaultAddress)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerID = try container.decodeIfPresent(Int.self, forKey: .customerID)
        self.customerFirstName = try container.decodeIfPresent(String.self, forKey: .customerFirstName)
        self.customerLastName = try container.decodeIfPresent(String.self, forKey: .customerLastName)
        self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.registeredDate = try container.decodeIfPresent(String.self, forKey: .registeredDate)
        self.isNew = try container.decodeIfPresent(Int.self, forKey: .isNew)
        self.addressID = try container.decodeIfPresent(Int.self, forKey: .addressID)
        self.referralCode = try container.decodeIfPresent(String.self, forKey: .referralCode)
        self.groupID = try container.decodeIfPresent(Int.self, forKey: .groupID)
        self.devicePlatform = try container.decodeIfPresent(String.self, forKey: .devicePlatform)
        self.canRingBell = try container.decodeIfPresent(Int.self, forKey: .canRingBell)
        self.canSMSSend = try container.decodeIfPresent(Int.self, forKey: .canSMSSend)
        self.canNotificationSend = try container.decodeIfPresent(Int.self, forKey: .canNotificationSend)
        self.canEmailSend = try container.decodeIfPresent(Int.self, forKey: .canEmailSend)
        self.canWhatsappSend = try container.decodeIfPresent(Int.self, forKey: .canWhatsappSend)
        self.blockStatus = try container.decodeIfPresent(Int.self, forKey: .blockStatus)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.userID = try container.decodeIfPresent(Int.self, forKey: .userID)
        self.isEmailVerified = try container.decodeIfPresent(Int.self, forKey: .isEmailVerified)
        self.customerBalance = try container.decodeIfPresent(CustomerBalance.self, forKey: .customerBalance)
//        self.profileDetails = try container.decodeIfPresent(ProfileDetails.self, forKey: .profileDetails)
        self.defaultAddress = try container.decodeIfPresent(DefaultAddress.self, forKey: .defaultAddress)
    }
}

// MARK: - CustomerBalance
struct CustomerBalance: Codable {
    let walletBalance: Double?
    let cashbackBalance: Int?
    let cashbackMessage: String?
    
    init(walletBalance: Double, cashbackBalance: Int, cashbackMessage: String) {
                self.walletBalance = walletBalance
                self.cashbackBalance = cashbackBalance
                self.cashbackMessage = cashbackMessage
            }
         
    enum CodingKeys: String, CodingKey {
        case walletBalance = "wallet_balance"
        case cashbackBalance = "cashback_balance"
        case cashbackMessage = "cashback_message"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.walletBalance = try container.decodeIfPresent(Double.self, forKey: .walletBalance)
        self.cashbackBalance = try container.decodeIfPresent(Int.self, forKey: .cashbackBalance)
        self.cashbackMessage = try container.decodeIfPresent(String.self, forKey: .cashbackMessage)
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.walletBalance, forKey: .walletBalance)
        try container.encodeIfPresent(self.cashbackBalance, forKey: .cashbackBalance)
        try container.encodeIfPresent(self.cashbackMessage, forKey: .cashbackMessage)
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
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerAddressID = try container.decodeIfPresent(Int.self, forKey: .customerAddressID)
        self.customerID = try container.decodeIfPresent(Int.self, forKey: .customerID)
        self.warehouseID = try container.decodeIfPresent(Int.self, forKey: .warehouseID)
        self.clusterID = try container.decodeIfPresent(Int.self, forKey: .clusterID)
        self.clusterName = try container.decodeIfPresent(String.self, forKey: .clusterName)
        self.cityID = try container.decodeIfPresent(Int.self, forKey: .cityID)
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
        self.stateName = try container.decodeIfPresent(String.self, forKey: .stateName)
        self.areaID = try container.decodeIfPresent(Int.self, forKey: .areaID)
        self.areaName = try container.decodeIfPresent(String.self, forKey: .areaName)
        self.pinCode = try container.decodeIfPresent(Int.self, forKey: .pinCode)
        self.subareaID = try container.decodeIfPresent(Int.self, forKey: .subareaID)
        self.subareaName = try container.decodeIfPresent(String.self, forKey: .subareaName)
        self.deliveryManagerID = try container.decodeIfPresent(Int.self, forKey: .deliveryManagerID)
        self.isApartment = try container.decodeIfPresent(Int.self, forKey: .isApartment)
        self.flatNo = try container.decodeIfPresent(String.self, forKey: .flatNo)
        self.societyID = try container.decodeIfPresent(Int.self, forKey: .societyID)
        self.societyName = try container.decodeIfPresent(String.self, forKey: .societyName)
        self.deliveryBoyDetails = try container.decodeIfPresent(DeliveryBoyDetails.self, forKey: .deliveryBoyDetails)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.address1 = try container.decodeIfPresent(String.self, forKey: .address1)
        self.address2 = try container.decodeIfPresent(String.self, forKey: .address2)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.addressTag = try container.decodeIfPresent(String.self, forKey: .addressTag)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.isDefault = try container.decodeIfPresent(Int.self, forKey: .isDefault)
        self.createdBy = try container.decodeIfPresent(Int.self, forKey: .createdBy)
        self.updatedBy = try container.decodeIfPresent(Int.self, forKey: .updatedBy)
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.customerAddressID, forKey: .customerAddressID)
        try container.encodeIfPresent(self.customerID, forKey: .customerID)
        try container.encodeIfPresent(self.warehouseID, forKey: .warehouseID)
        try container.encodeIfPresent(self.clusterID, forKey: .clusterID)
        try container.encodeIfPresent(self.clusterName, forKey: .clusterName)
        try container.encodeIfPresent(self.cityID, forKey: .cityID)
        try container.encodeIfPresent(self.cityName, forKey: .cityName)
        try container.encodeIfPresent(self.stateName, forKey: .stateName)
        try container.encodeIfPresent(self.areaID, forKey: .areaID)
        try container.encodeIfPresent(self.areaName, forKey: .areaName)
        try container.encodeIfPresent(self.pinCode, forKey: .pinCode)
        try container.encodeIfPresent(self.subareaID, forKey: .subareaID)
        try container.encodeIfPresent(self.subareaName, forKey: .subareaName)
        try container.encodeIfPresent(self.deliveryManagerID, forKey: .deliveryManagerID)
        try container.encodeIfPresent(self.isApartment, forKey: .isApartment)
        try container.encodeIfPresent(self.flatNo, forKey: .flatNo)
        try container.encodeIfPresent(self.societyID, forKey: .societyID)
        try container.encodeIfPresent(self.societyName, forKey: .societyName)
        try container.encodeIfPresent(self.deliveryBoyDetails, forKey: .deliveryBoyDetails)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.address1, forKey: .address1)
        try container.encodeIfPresent(self.address2, forKey: .address2)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
        try container.encodeIfPresent(self.addressTag, forKey: .addressTag)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.isDefault, forKey: .isDefault)
        try container.encodeIfPresent(self.createdBy, forKey: .createdBy)
        try container.encodeIfPresent(self.updatedBy, forKey: .updatedBy)
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
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
        self.userID = try container.decodeIfPresent(Int.self, forKey: .userID)
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.mobile, forKey: .mobile)
        try container.encodeIfPresent(self.userID, forKey: .userID)
    }
}

// MARK: - ProfileDetails
//struct ProfileDetails: Codable {
//
//}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//    }
//
//    public var hashValue: Int {
//            return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//    }
//}
