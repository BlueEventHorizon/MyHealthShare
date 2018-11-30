//
//  IdentifierGettable.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation

// クラス文字列を返す classのみ適用
public protocol IdentifierGettable: class
{
    var identifier: String { get }
    static var identifier: String { get }
    
    var classIdentifier: String { get }
    static var classIdentifier: String { get }
}

// クラス文字列を返す
extension IdentifierGettable
{
    public var identifier: String { return String(describing: type(of: self)) }
    public static var identifier: String { return String(describing: Self.self) }
    
    public var classIdentifier: String { return self.identifier }
    public static var classIdentifier: String { return Self.identifier }
}
