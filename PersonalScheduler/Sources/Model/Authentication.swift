//
//  Authentication.swift
//  PersonalScheduler
//
//  Created by Ari on 2023/01/09.
//

import Foundation

struct Authentication: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let identityToken: String?
    let authorizeCode: String?
    let snsUserName: String?
    let snsUserEmail: String?
    let snsUserId: String?
    let snsProfileUrl: String?
    
    init(
        accessToken: String?,
        refreshToken: String?,
        identityToken: String? = nil,
        authorizeCode: String? = nil,
        snsUserName: String? = nil,
        snsUserEmail: String? = nil,
        snsUserId: String? = nil,
        snsProfileUrl: String? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.identityToken = identityToken
        self.authorizeCode = authorizeCode
        self.snsUserName = snsUserName
        self.snsUserEmail = snsUserEmail
        self.snsUserId = snsUserId
        self.snsProfileUrl = snsProfileUrl
    }
}

struct TokenOption: OptionSet {
    let rawValue: Int
    static let access = TokenOption(rawValue: 1 << 0)
    static let refresh = TokenOption(rawValue: 1 << 1)
}
