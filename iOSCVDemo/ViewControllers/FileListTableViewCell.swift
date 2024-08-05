//
//  FileListTableViewCell.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit

class FileListTableViewCell : UITableViewCell {
    var type = FileType.unknown
    
    static let kCellId = "fileListTableViewCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FileListTableViewCell.kCellId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
