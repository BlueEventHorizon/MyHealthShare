//
//  ViewController.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import RxSwift

class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var firebaseUtil = {FirebaseUtil.shared}()
    private lazy var healthUtil = {HealthUtil.shared}()
    private lazy var slackUtil = {SlackUtil.shared}()
    
    var users = [User]()
    //lazy var viewModel = { return ViewModel() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "My Health Share"
        tableView.layoutMargins = UIEdgeInsets.zero // [※1] separatorsを端から端まで伸ばす
        tableView.separatorInset = UIEdgeInsets.zero // [※1] separatorsを端から端まで伸ばす
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        firebaseUtil.observables.users.subscribe(onNext: {[weak self] (users) in
            guard let _self = self else { return }
            
            _self.users = users

        }).disposed(by: disposeBag)
        firebaseUtil.readUsers(team_id: "momo")


        //viewModel.configure()
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
    public func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        let cell = UserCell.dequeue(from: tableView, for: cellForRowAt)
        cell.configure(nickName: "ニックネーム", stepCount: 100)
        
        return cell
    }

    // セクション数
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション毎のアイテム数
    public func tableView(_ tableView: UITableView, numberOfRowsInSection: Int)  -> Int {
        return users.count
    }
}

open class UserCell: UITableViewCell, CellDequeueable
{
    @IBOutlet weak var UserNameText: UILabel!
    @IBOutlet weak var walkImage: UIImageView!
    @IBOutlet weak var StepCount: UILabel!
    
    let walkSpeedFast = UIImage.gif(name: "animation-walkman0")
    let walkSpeedNomal = UIImage.gif(name: "animation-walkman1")
    let walkSpeedSlow = UIImage.gif(name: "animation-walkman2")
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(nickName: String, stepCount: Int) {
        self.layoutMargins = UIEdgeInsets.zero
        self.selectionStyle = .none
        self.UserNameText.text = nickName
        self.StepCount.text = String(stepCount) + "歩"
        switch stepCount {
        case 10000... :
            self.walkImage.image = walkSpeedFast
        case 5000... :
            self.walkImage.image = walkSpeedNomal
        default:
            self.walkImage.image = walkSpeedSlow
        }
        self.imageView!.contentMode = .scaleAspectFit
    }
}
