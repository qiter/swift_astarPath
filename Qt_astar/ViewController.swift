//
//  ViewController.swift
//  Qt_astar
//
//  Created by qiter on 15/7/26.
//  Copyright (c) 2015年 qiter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //var gridObj = Grid(__numCols: 10, rows numRows: 10)
        //var gObj = Grid(numCols: 10, rows: 10);
        
        var gridViewCtrl = GridViewController()
        self.view.addSubview(gridViewCtrl.view)
        self.addChildViewController(gridViewCtrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





