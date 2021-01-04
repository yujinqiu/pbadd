//
//  main.swift
//  pbadd
//
//  Created by yujinqiu on 9/15/20.
//

import Foundation
import AppKit
import ArgumentParser

struct Directory {
    static func CurrentWorkingDirectory()-> String {
        return  FileManager.default.currentDirectoryPath
    }
}


struct Path {
    static let seperator = "/"
    static let home = "~"
    let fm = FileManager.default
    var path: String
    var cwd: String
    
    init(path: String) {
        self.path = path
        self.cwd = Directory.CurrentWorkingDirectory()
    }
    
    
    var isAbsolute: Bool {
        return path.hasPrefix(Path.seperator) || path.hasPrefix(Path.home)
    }
    
    var isRelative: Bool {
        return !isAbsolute
    }
    
    var absPath: String {
        if isAbsolute {
            return path
        }
        return "\(self.cwd)/\(self.path)"
    }
    
    var exists: Bool {
        return fm.fileExists(atPath: self.absPath)
    }
}


struct Options: ParsableCommand {
    @Argument(help: "Add to pasteboard files")
    var files: [String]
}

let options = Options.parseOrExit()

var urls: [NSURL] = []

for file in options.files {
    let path = Path(path: file)
    if path.exists {
        let url = NSURL(fileURLWithPath: path.absPath)
        // standardizing path: transform ../.. to the right path
        guard let standardizedPath = url.standardizingPath else {
            continue
        }
        urls.append(standardizedPath as NSURL)
    }else{
        print("File:\(path.absPath) not exists, ignored.")
    }
}

if urls.count > 0 {
    let pb = NSPasteboard.general
    // we must clear contents before write to it.
    pb.clearContents()
    let isSuccess = pb.writeObjects(urls)
    
    if(!isSuccess) {
        print("Add to pasteboard failed.")
        exit(1)
    }
}
print("\nTotal add \(urls.count) item\(urls.count > 1 ? "s":"") into pasteboard")
