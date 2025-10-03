//
//  Post.swift
//  CodePath-Project2-BeRealClone
//
//  Created by Tanis Sarbatananda on 10/2/25.
//


// Post.swift
import Foundation
import ParseSwift

struct Post: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    var author: User?
    var image: ParseFile?
    var caption: String?
}