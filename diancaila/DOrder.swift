//
//  DOrder.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/3.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

// 订单表
class DOrder: NSObject {
    

    
    var id: String = ""
    var deskId: Int = 0
    var orderTime: String = ""
    var price: Double = 0.0 // 原价
    var vipPrice: Double = 0.0
    var truePrice: Double = 0.0 // 实际结账
    var orderList = [Order]()
    
    init(id: String, deskId: Int, orderTime: String, price: Double, vipPrice: Double) {
        self.id = id
        self.deskId = deskId
        self.orderTime = orderTime
        self.price = price
        self.vipPrice = vipPrice
    }
    
    init(id: String, deskId: Int, orderTime: String, price: Double, vipPrice: Double, orderList : [Order]) {
        self.id = id
        self.deskId = deskId
        self.orderTime = orderTime
        self.price = price
        self.vipPrice = vipPrice
        self.orderList = orderList
    }
    
    
    init(id: String, deskId: Int, orderTime: String, truePrice: Double) {
        self.id = id
        self.deskId = deskId
        self.orderTime = orderTime
        self.truePrice = truePrice
    }
}