//
//  Node.swift
//  Qt_astar
//
//  Created by qiter on 15/7/26.
//  Copyright (c) 2015年 qiter. All rights reserved.
//

import UIKit

class Node: NSObject {
    
    var x:CGFloat = 0
    var y:CGFloat = 0
    var f:CGFloat = 0
    var g:CGFloat = 0
    var h:CGFloat = 0
    var walkable:Bool = true
    var parent:Node?
    var costMultiplier:CGFloat = 1.0
    
    init(_x:CGFloat, positionY _y:CGFloat) {
        //super.init()
        self.x = _x
        self.y = _y
    }
    

}
