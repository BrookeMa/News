//
//  HTTPURLResponse+StatusCode.swift
//  News
//
//  Created by Ye Ma on 2024/5/2.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool { 
        return statusCode == HTTPURLResponse.OK_200
    }
}
