//
//  FileListViewModel.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import Foundation

class FileListViewModel {
    var fileList = [FileItem]()
    
    func refresh() {
        let files = Utils.refreshFiles(Utils.getDocumentsDir())
        fileList = files
        fileList.sort { (a:FileItem, b:FileItem) in
            return a.filename.caseInsensitiveCompare(b.filename) == .orderedAscending
        }
    }
}
