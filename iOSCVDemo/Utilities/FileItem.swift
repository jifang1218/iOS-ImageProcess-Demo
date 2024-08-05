//
//  FileItem.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import Foundation

struct FileItem {
    var fileUrl:URL = URL(fileURLWithPath: "")
    var filename : String {
        get {
            return fileUrl.lastPathComponent
        }
    }
    var fileType:FileType = .unknown
}
