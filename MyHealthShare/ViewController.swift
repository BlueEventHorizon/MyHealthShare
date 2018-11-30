//
//  ViewController.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Int]()
    lazy var viewModel = { return ViewModel() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        list.append(0)
        list.append(2)

        viewModel.configure()
    }
}

// =============================================================================
// MARK: - UITableViewDelegate
// =============================================================================

extension ViewController: UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {

    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {

    }
}

// =============================================================================
// MARK: - UITableViewDataSource
// =============================================================================

extension ViewController: UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell
    {
        let cell = UserCell.dequeue(from: tableView, for: cellForRowAt)

        return cell
    }
    
    // セクション数
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // セクション毎のアイテム数
    public func tableView(_ tableView: UITableView, numberOfRowsInSection: Int)  -> Int
    {
        return list.count
    }
}

open class UserCell: UITableViewCell, CellDequeueable
{

}
