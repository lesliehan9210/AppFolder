//
//  AppFolder.swift
//  AppFolder
//
//  Created by Oleg Dreyman on 1/18/18.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

fileprivate func fixClassName(_ classname: String) -> String {
    // check out SR-6787 for more
    return classname.components(separatedBy: " ")[0]
}

open class Directory {
    
    public let baseURL: URL
    public final let previous: [Directory]
    
    private var all: [Directory] {
        return previous + [self]
    }
    
    required public init(baseURL: URL, previous: [Directory] = []) {
        self.baseURL = baseURL
        self.previous = previous
    }
    
    open var folderName: String {
        let className = String.init(describing: type(of: self))
        let fixedClassName = fixClassName(className)
        return fixedClassName
            .components(separatedBy: "_")
            .joined(separator: " ")
    }
    
    public final var subpath: String {
        return all.map({ $0.folderName }).joined(separator: "/")
    }
    
    public var url: URL {
        return baseURL.appendingPathComponent(subpath, isDirectory: true)
    }
    
    func adding<Subdirectory : Directory>(_ subdirectory: Subdirectory.Type = Subdirectory.self) -> Subdirectory {
        return Subdirectory(baseURL: baseURL, previous: all)
    }
    
}

extension URL {
    
    public init(of directory: Directory) {
        self = directory.url
    }
    
}

public final class Library : Directory {
    
    public final class Caches : Directory { }
    public var caches: Caches {
        return adding()
    }
    
    public final class Application_Support : Directory { }
    public var applicationSupport: Application_Support {
        return adding()
    }
    
}

public final class Documents : Directory { }
public final class Temporary : Directory {
    public override var folderName: String {
        return "tmp"
    }
}