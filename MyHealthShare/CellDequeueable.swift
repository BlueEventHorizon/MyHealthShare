//
//  CellDequeueable.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation
import UIKit

public protocol CellDequeueable: IdentifierGettable where Self: UITableViewCell
{
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self
    static func dequeue(from tableView: UITableView) -> Self
}

// Cell Identifierがクラス名と同一の場合に使用できます。
extension CellDequeueable
{
    static public func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self
    {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Self
    }
    static public func dequeue(from tableView: UITableView) -> Self
    {
        return tableView.dequeueReusableCell(withIdentifier: identifier) as! Self
    }
}

public protocol CollectionCellDequeueable: IdentifierGettable where Self: UICollectionViewCell
{
    static func dequeue(from collection: UICollectionView, for indexPath: IndexPath) -> Self
}

// Cell Identifierがクラス名と同一の場合に使用できます。
extension CollectionCellDequeueable
{
    static public func dequeue(from collection: UICollectionView, for indexPath: IndexPath) -> Self
    {
        return collection.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Self
    }
}
