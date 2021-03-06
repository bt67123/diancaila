//
//  OrderConfirmViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

protocol OrderConfirmViewControllerDelegate {
    func OrderDidFinish()
}

class OrderConfirmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CustomActionSheetDelegate, HttpProtocol, JSONParseProtocol, UIAlertViewDelegate {
    
    var tableView: UITableView!
    
    var deskInfoView: UITableView!
    var orderListView: UITableView!
    var deskIdPicker: UIPickerView?
    var customerNumPicker: UIPickerView?
    var alertLabel: UILabel!
    var okButton: UIButton!
    
    var customerNumSheet: CustomActionSheet?
    
    var deskIdSheet: CustomActionSheet?
    
    // 值由外面一层传入
    var orderList: [Order]!
    
    let cellHeight =  CGFloat(42)

    var user: User!
    
    // deskInfoView 数据源 
    var deskInfoViewTitles = ["是否外面", "请选择桌号", "请选择人数"]
    
    
    // 桌号
    var deskId: Int = 0
    var selectDeskid: Int = 1
    var numOfDesk: Int = 20
    
    // 人数
    var customerNum: Int = 0
    var selectCustomerNum: Int = 1
    var maxNumOfCustom: Int = 25
    
    // 是否外面
    var isTakeaway = false
    
    // 订单号
    var orderId = ""
    
    // jsonDic
    var jsonDic = NSMutableDictionary()
    
    var ehttp: HttpController = HttpController()
    
    var jsonController = JSONController()
    
    var delegate: OrderConfirmViewControllerDelegate?
    
    let httpIdWithSubmitOrder = "submitOrderId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单确认"
        
        ehttp.deletage = self
        
        jsonController.parseDelegate = self
        
//        var scrollViewHeight = cellHeight * CGFloat(orderList.count) + 350
//        if scrollViewHeight < UIUtil.screenHeight {
//            // 为了当 scrollview没有超出界的时候拖动也有动画效果
//            scrollViewHeight = UIUtil.screenHeight+1
//        }
//        let scrollView = UIScrollView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
//        scrollView.delegate = self
//        scrollView.contentSize = CGSize(width: UIUtil.screenWidth, height: scrollViewHeight)
//        scrollView.scrollEnabled = true
//        scrollView.bounces = true
//        self.view.addSubview(scrollView)
        
        
        
//        self.view.backgroundColor = UIUtil.gray_system
//        self.title = "下单确认"
//
//        self.deskInfoView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, cellHeight*4), style: UITableViewStyle.Grouped)
//        self.deskInfoView.delegate = self
//        self.deskInfoView.dataSource = self
//        self.deskInfoView.scrollEnabled = false
//        scrollView.addSubview(deskInfoView)
        
//        self.orderListView = UITableView(frame: CGRectMake(0, cellHeight * 5, UIUtil.screenWidth, 44 * CGFloat(orderList.count) - 1))
//        self.orderListView.scrollEnabled = false
//        self.orderListView.delegate = self
//        self.orderListView.dataSource = self
//        scrollView.addSubview(orderListView)
        
        
        // 下方偏移量
//        var heightOffset = CGFloat(0)
//        var radius = CGFloat(70)
//        if scrollViewHeight > UIUtil.screenHeight + 1 {
//            heightOffset =  scrollViewHeight - 150
//        } else {
//            heightOffset = UIUtil.screenHeight - 160
//        }
//        
       
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
         // 下单按钮

        okButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2 - 35, UIUtil.screenHeight - UIUtil.contentOffset - 112, 70, 70))
        okButton.setTitle("下单", forState: UIControlState.Normal)
        okButton.backgroundColor = UIColor.orangeColor()
        okButton.setTitle("松开～", forState: UIControlState.Highlighted)
        okButton.layer.cornerRadius = 70/2
        okButton.addTarget(self, action: "didPressOkButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(okButton)
        
    }
    
    func didPressOkButton(sender: UIButton) {
        
        if !isTakeaway {
            
            if deskId == 0 {
                okButton.setTitle("没桌号", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
                okButtonShake()
                
                return
                
            } else if customerNum == 0 {
                okButton.setTitle("没人数", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
                okButtonShake()
                
                return
            }
        }
            
    
        // 生成json
        let defaults = NSUserDefaults.standardUserDefaults()
        
        jsonDic["user_id"] = defaults.objectForKey("userId") as String
        jsonDic["shop_id"] = defaults.objectForKey("shopId") as String
        jsonDic["tab_id"] = deskId
        jsonDic["cus_num"] = customerNum
        jsonDic["card_id"] = 0
        
        var dishList = NSMutableArray()
        
        for order in orderList {
            var dish: NSMutableDictionary = NSMutableDictionary()
            
            dish["dish_id"] = order.menu.id
            dish["dish_num"] = order.count
            
            dishList.addObject(dish)
        }
        jsonDic["dish_list"] = dishList
        
        println(jsonDic)
        ehttp.postWithUrl(HttpController.apiSubmitOrder, andJson: jsonDic, forIdentifier: httpIdWithSubmitOrder, inView: self.view)
    }
    
    
    func okButtonShake() {
        let moveLeft = CGAffineTransformMakeTranslation(-20, 0)
        let moveRight = CGAffineTransformMakeTranslation(20, 0)
        let resetTransform = CGAffineTransformMakeTranslation(0, 0)
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
            self.okButton.transform = moveLeft
            
            }) { (finished: Bool) -> Void in
                
                if finished {
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                        self.okButton.transform = moveRight
                        
                        }, completion: { (finished: Bool) -> Void in
                            
                            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                                
                                self.okButton.transform = resetTransform
                                }, completion: { (finished: Bool) -> Void in
                            })
                    })
                }
        }
    }
    
    // about tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return orderList.count
        } else {
            return deskInfoViewTitles.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let orderCell = "orderCell"
            var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(orderCell)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: orderCell)
            }
            let tempCell = cell as UITableViewCell
            tempCell.textLabel?.text = orderList[indexPath.row].menu.name
            tempCell.detailTextLabel?.text = "\(orderList[indexPath.row].count)份"
            tempCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return tempCell
            
        } else {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            
            if indexPath.row == 1 {
                cell.textLabel?.text = "桌号"
                if deskId == 0 {
                    cell.detailTextLabel?.text = deskInfoViewTitles[indexPath.row]
                } else {
                    cell.detailTextLabel?.text = "\(deskId)号桌"
                }
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "人数"
                if customerNum == 0 {
                    cell.detailTextLabel?.text = deskInfoViewTitles[indexPath.row]
                } else {
                    cell.detailTextLabel?.text = "\(customerNum)人"
                }
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
            } else {
                cell.textLabel?.text = "是否外带"
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                let takeawaySwitch = UISwitch()
                takeawaySwitch.on = isTakeaway
                takeawaySwitch.addTarget(self, action: "switchAction:", forControlEvents: UIControlEvents.ValueChanged)
                cell.accessoryView = takeawaySwitch
            }
            
            return cell
        }
    }
    
    
    func switchAction(sender: UISwitch) {
        if sender.on {
            deskInfoViewTitles.removeAtIndex(1)
            deskInfoViewTitles.removeAtIndex(1)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0), NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
            deskId = 0
            customerNum = 0
            
            okButton.setTitle("下单", forState: UIControlState.Normal)
            okButton.backgroundColor = UIColor.orangeColor()
            
            isTakeaway = true
        } else {
            isTakeaway = false
            
            deskInfoViewTitles = ["是否外面", "请选择桌号", "请选择人数"]
            
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0), NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
            
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0{
            
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            
            
            if indexPath.row == 1 {
                if (deskIdPicker == nil) {
                    deskIdPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                    deskIdPicker?.delegate = self
                    deskIdPicker?.dataSource = self
                    deskIdPicker?.selectRow(numOfDesk, inComponent: 0, animated: true)
                }
                deskIdSheet = CustomActionSheet(customView: deskIdPicker!)
                deskIdSheet!.deletage = self
                deskIdSheet!.show()
                
            } else if indexPath.row == 2 {
                if customerNumPicker == nil {
                    customerNumPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                    customerNumPicker?.delegate = self
                    customerNumPicker?.dataSource = self
                    customerNumPicker?.selectRow(maxNumOfCustom, inComponent: 0, animated: true)
                }
                customerNumSheet = CustomActionSheet(customView: customerNumPicker!)
                customerNumSheet!.deletage  = self
                customerNumSheet!.show()
            }
                
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // about picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == deskIdPicker {
            return numOfDesk * 50
        } else {
            return maxNumOfCustom * 50
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == deskIdPicker {
            return "\(row % numOfDesk + 1)号桌"
            
        } else {
            return "\(row % maxNumOfCustom + 1)人"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == deskIdPicker {
            self.selectDeskid = row % numOfDesk + 1
            
            pickerView.selectRow(numOfDesk * 24 + (row % numOfDesk), inComponent: 0, animated: false)
            
        } else {
            self.selectCustomerNum = row % maxNumOfCustom + 1
            pickerView.selectRow(maxNumOfCustom * 24 + (row % maxNumOfCustom), inComponent: 0, animated: false)
        }
        
        
    }
    
    // actionsheet deletage
    func didPressDoneButton(actionSheet: UIView) {
        if actionSheet == deskIdSheet {
            deskId = selectDeskid
            tableView.reloadData()
            
            if customerNum == 0 {
                okButton.setTitle("没人数", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
            } else {
                okButton.setTitle("下单", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.orangeColor()
            }
            
        } else {
            customerNum = selectCustomerNum
            tableView.reloadData()
            
            if deskId == 0 {
                okButton.setTitle("没桌号", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
            } else {
                okButton.setTitle("下单", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.orangeColor()
            }
        }
    }
    
    // HttpProtocol
    func httpControllerDidReceiveResult(result: NSDictionary, forIdentifier identifier: String) {
        switch identifier {
        case httpIdWithSubmitOrder:
            jsonController.parseOrderId(result)
        default:
            return
        }
    }
    
    // JSONProtocol
    func didFinishParseOrderId(orderId: String) {
        self.orderId = orderId
        
        let alert = UIAlertView(title: "下单成功", message: "订单号: \(self.orderId)", delegate: self, cancelButtonTitle: "确定")
        alert.delegate = self
        alert.show()
    }
    
    // UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.delegate?.OrderDidFinish()
        
        self.navigationController?.popViewControllerAnimated(true)
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
