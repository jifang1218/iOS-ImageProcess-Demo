//
//  Utils.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import Foundation
import UIKit
import AVFoundation

class Utils {
    
    static func isImage(url: URL) -> Bool {
        var ret = false
        
        if let _ = UIImage(contentsOfFile: url.path) {
            ret = true
        }
        
        return ret
    }
    
    static func isVideo(url: URL) -> Bool {
        return extractFirstFrame(from: url) != nil
    }
    
    static func extractFirstFrame(from url: URL) -> UIImage? {
        var ret : UIImage?
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 0, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            ret = UIImage(cgImage: cgImage)
        } catch {
            print("Error extracting first frame: \(error)")
        }
        
        return ret
    }
    
    static func getDocumentsDir() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func refreshFiles(_ url:URL) -> [FileItem] {
        var files = Utils.listFiles(url)
        
        // for testing purpose only, copy some demo files.
        if files.count == 0 {
            Utils.copyTestFiles()
            files = Utils.listFiles(url)
        }

        return files
    }
    
    static private func listFiles(_ url:URL) -> [FileItem] {
        var ret = [FileItem]()
        
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at:url, includingPropertiesForKeys: nil)
            var isDir: ObjCBool = false
            for fileUrl in fileUrls {
                FileManager.default.fileExists(atPath:fileUrl.path, isDirectory: &isDir)
                if isDir.boolValue {
                    continue
                }
                var item = FileItem()
                item.fileUrl = fileUrl
                if Utils.isImage(url: fileUrl) {
                    item.fileType = .image
                    ret.append(item)
                } else if Utils.isVideo(url: fileUrl) {
                    item.fileType = .video
                    ret.append(item)
                }
            }
        } catch {
            NSLog("Error while enumerating files in \(url.path): \(error.localizedDescription)")
        }
        
        return ret
    }
    
    static func copyTestFiles() -> Void {
        let files = listFiles(Bundle.main.bundleURL)
        let docDir = getDocumentsDir()
        var isDir: ObjCBool = false
        for file in files {
            let src = file.fileUrl
            FileManager.default.fileExists(atPath: src.path, isDirectory: &isDir)
            if isDir.boolValue {
                continue
            }
            let dst = docDir.appending(component: file.filename)
            do {
                try FileManager.default.copyItem(at: src, to: dst)
            } catch {
                NSLog("Error while copying files in from: \(src.path), to: \(dst.path), error: \(error.localizedDescription)")
            }
        }
    }
    
    static func mapValue(from range1: (Float, Float), to range2: (Float, Float), value: Float) -> Float {
        let (oldMin, oldMax) = range1
        let (newMin, newMax) = range2
        
        let oldRange = oldMax - oldMin
        let newRange = newMax - newMin
        
        return ((value - oldMin) * newRange / oldRange) + newMin
    }

}
