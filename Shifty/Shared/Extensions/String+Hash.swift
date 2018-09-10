//
//  String.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 15/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import Foundation

extension String {
    func sha256() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash).base64EncodedString()
    }
}
