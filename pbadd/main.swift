//
//  main.swift
//  pbadd
//
//  Created by yujinqiu on 9/15/20.
//

import Foundation
import AppKit
import ArgumentParser
import PathKit

struct Directory {
    static func CurrentWorkingDirectory()-> String {
        return  FileManager.default.currentDirectoryPath
    }
}


struct Options: ParsableCommand {
    @Argument(help: "Add to pasteboard files")
    var files: [String]
}

let options = Options.parseOrExit()

var urls: [NSURL] = []

for file in options.files {
    let path = Path(file)
    if path.exists {
        let normalizedPath = path.absolute().normalize()
        let url = NSURL(fileURLWithPath: normalizedPath.string)
        urls.append(url)
    }else{
        print("File:\(path.string) not exists, ignored.")
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
