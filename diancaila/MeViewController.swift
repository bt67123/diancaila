//
//  MeViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/10.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    // tableview 数据源
    let titles = [["个人信息"], ["设置"], ["服务员"]]
    let imageNames = [[], ["settings"], ["waiter"]]
    
    var user: User?
    
    var numOfSection = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        if user?.auth == "3" {
            numOfSection = 4
        }
        

        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    
    func gotoSettingsVC() {
        let settingsVC = SettingsTableViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func gotoWaiterVC() {
        let waiterVC = WaiterViewController()
        self.navigationController?.pushViewController(waiterVC, animated: true)
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        if section == 1 {
//            return titles.count
//        } else {
//            return 1
//        }
        return titles[section].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userInfoCell = "userInfoCell"
        let imageCell = "imageCell"
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell = UserInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: userInfoCell, image: UIImage(named: "iron_man")!, title: "\(user!.name)", detailTitle: "啦号: \(user!.phoneNumber)")
            
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: imageCell)
            cell.imageView?.image = UIImage(named: imageNames[indexPath.section][indexPath.row])
            cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                gotoSettingsVC()
            }
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                gotoWaiterVC()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 90
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func setUser(user: User) {
        self.user = user
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
