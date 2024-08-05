//
//  FileListViewController.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit

class FileListViewController: UITableViewController {
    
    let model = FileListViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        model.refresh()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FileListTableViewCell.self,
                                forCellReuseIdentifier: FileListTableViewCell.kCellId)
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fileList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileListTableViewCell.kCellId, for: indexPath)
        let item = self.model.fileList[indexPath.row]
        
        switch item.fileType {
        case .image:
            cell.imageView?.image = UIImage(contentsOfFile: item.fileUrl.path)
        case .video:
            cell.imageView?.image = Utils.extractFirstFrame(from: item.fileUrl)
        default:
            NSLog("not a image or video type.")
        }
        
        switch item.fileType {
        case .image, .video:
            let itemSize = CGSizeMake(36, 36);
            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0);
            let imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
            cell.imageView?.image?.draw(in: imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.textLabel?.text = item.filename
        default:
            NSLog("not a image or video type.")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = model.fileList[indexPath.row]
        let viewController = ImageViewerViewController(image)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
    }
}

