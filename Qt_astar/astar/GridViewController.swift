//
//  GridViewController.swift
//  Qt_astar
//
//  Created by qiter on 15/7/26.
//  Copyright (c) 2015年 qiter. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    
    var screenW:CGFloat = 0.0;
    var screenH:CGFloat = 0.0;
    
    var leftNum:CGFloat = 0
    var topNum:CGFloat = 0
    
    var blockWidth:CGFloat = 32.0
    var blockHeight:CGFloat = 32.0
    var _titleLabel:UILabel?
    
    var _cellSize:CGFloat = 32.0
    var _scaleNum:CGFloat = 2
    
    var _grid:Grid?;
    
    var _player:UIButton?
    
    var _gridView:UIView?
    
    var _changBtn:UIButton?
    var _scaleBtn:UIButton?
    
    var _tempNum:Int = 0;
    var _timer:NSTimer?
    //搜索路径结果
    var _resultPath:[Node]?
    
    var _dicts:Dictionary<String,UIButton>?
    
    //var _tileArrs:[Dictionary<String,UIButton>]?
    
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        screenW = self.view.frame.width;
        screenH = self.view.frame.height;
        
        
        _dicts = Dictionary<String,UIButton>()
        
        
        _cellSize = _cellSize/_scaleNum
        
        
        _gridView = UIView()
        _gridView?.frame = CGRectMake(0, 0, screenW, screenH)
        self.view.addSubview(_gridView!)
        
        leftNum = (screenW - floor(screenW/_cellSize)*_cellSize)/2
        topNum = CGFloat(Int(screenH*0.15)-20)

        
        createUI()
        
        createGrid()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createUI(){
        
        
        _titleLabel = UILabel()
        _titleLabel?.frame = CGRectMake(0, 20, screenW, 44)
        _titleLabel?.textAlignment = NSTextAlignment.Center
        _titleLabel?.text = "Qt AStar"
        self.view.addSubview(_titleLabel!)
        
        //
        _changBtn = UIButton(frame: CGRect(x: 10, y: screenH - 50, width: 100, height: 35))
        _changBtn?.backgroundColor = UIColor.grayColor()
        _changBtn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _changBtn?.setTitle("变换地图", forState: UIControlState.Normal)
        _changBtn?.layer.cornerRadius = 0
        _changBtn?.addTarget(self, action: Selector("changBtnBlockClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(_changBtn!)
        
        //
        _scaleBtn = UIButton(frame: CGRect(x: 120, y: screenH - 50, width: 100, height: 35))
        _scaleBtn?.backgroundColor = UIColor.grayColor()
        _scaleBtn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _scaleBtn?.setTitle("缩放地图", forState: UIControlState.Normal)
        _scaleBtn?.layer.cornerRadius = 0
        _scaleBtn?.addTarget(self, action: Selector("scaleBtnBlockClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(_scaleBtn!)
        //
        _player = UIButton(frame: CGRect(x: leftNum, y: topNum, width: _cellSize, height: _cellSize))
        _player?.backgroundColor = UIColor.blueColor()
        
        _player?.layer.cornerRadius = 15
        
        self.view.addSubview(_player!)

    }
    
    func createGrid(){
        
        _gridView?.subviews.map{ $0.removeFromSuperview()}

        var colNum:Int = Int(screenW/_cellSize)
        var rowNum:Int = Int(screenH*0.7/_cellSize)
        
        _grid = Grid(numCols: colNum, rows: rowNum)
        
        var startPosX:Int = randDiscUniform(0, colNum-1)
        var startPosY:Int = randDiscUniform(0, rowNum-1)
        
        //_grid!._startNode = Node(_x: CGFloat(startPosX), positionY: CGFloat(startPosY))
        //_grid!.setStartNode(startPosX, py:startPosY)
        _grid!.setStartNode(0, py:0)
        _player?.frame.origin.x = leftNum
        _player?.frame.origin.y = topNum
        
        for (var i:Int = 0;i<Int(colNum*rowNum/4);i++){
            var posX:CGFloat = CGFloat(randDiscUniform(0, colNum-1))
            var posY:CGFloat = CGFloat(randDiscUniform(0, rowNum-1))
            var node:Node = Node(_x: posX, positionY: posY)
            if(posX != CGFloat(startPosX) || posY != CGFloat(startPosY)){
                _grid?.setWalkable(Int(node.x), py: Int(node.y), val: false)
            }
        }
        
        
        drawGrid()
        

    }
    
    /**
    *
    */
    func drawGrid()
    {
       
        
        if let grid = _grid{
            for(var i:Int = 0; i < grid._numCols; i++)
            {
                for(var j:Int = 0; j < grid._numRows; j++)
                {
                    
                    if let node = grid.getNode(i,py:j){
                        
                        var btn:QtButton = QtButton();
                        btn.node = node;
                        btn.name = "btn_\(i)_\(j)"
                        btn.frame = CGRectMake(leftNum+CGFloat(i)*_cellSize, topNum+CGFloat(j)*_cellSize, _cellSize, _cellSize)
                        btn.backgroundColor = self.getColor(node)
                        btn.layer.borderColor = UIColor.grayColor().CGColor
                        btn.layer.borderWidth = 1
                        btn.layer.cornerRadius = 0
                        btn.addTarget(self, action: Selector("gridBlockClick:"), forControlEvents: UIControlEvents.TouchUpInside)
                        
                        _dicts?[btn.name] = btn
                        
                        self._gridView?.addSubview(btn)
                        
                    }
                    
                    
                    
                }
            }
        }
        
        
        
    }
    
    
    func getColor(node:Node)->UIColor{
        
        if !node.walkable {
            return UIColor.grayColor()
        }
        if node == _grid?._startNode {
            return UIColor.redColor()
        }
        if node == _grid?._endNode{
            return UIColor.yellowColor()
        }
        return UIColor.whiteColor()
    }
    
    func findPath(){
        
        var astarObj:Astar = Astar()
        if(astarObj.findPath(_grid!)){
            //
            
        }
        
        _resultPath = astarObj._path
        
        createTimer()
        
        if let len = _resultPath?.count{
            //
            
            
            _titleLabel?.text = "总消耗:\(astarObj._titleCost)"

        }else{
            var alertView = UIAlertView()
            alertView.delegate = self
            alertView.title = "通知"
            alertView.message = "没有找到路径"
            alertView.addButtonWithTitle("关闭")
            alertView.show()
        }
        
        println("\(_resultPath?.count)")
        
    }
    
    func gridBlockClick(sender:QtButton){
        
        var btn = sender as QtButton;
        
        /*
        if(btn.node != _grid?._startNode){
            if(btn.node?.walkable == true){
                btn.node?.walkable = false
                btn.backgroundColor = UIColor.grayColor()
            }else{
                btn.node?.walkable = true
                btn.backgroundColor = UIColor.whiteColor()
                
            }
        }

        */
        
        var endPosX :Int = Int(btn.node!.x)
        var endPosY :Int = Int(btn.node!.y)

        _grid?.setEndNode(endPosX, py: endPosY)
        
        clearBlock()
        findPath()
        
    }
    
    
    func changBtnBlockClick(sender:UIButton){
        
        createGrid();
        
    }
    
    func scaleBtnBlockClick(sender:UIButton){
        if(_scaleNum==2){
            _scaleNum = 1
        }else{
            _scaleNum = 2
        }
        _cellSize = 32
        _cellSize = _cellSize/_scaleNum
        createGrid();
    }
    
    func clearBlock(){
        
        if let dic=_dicts{
            for(key,val) in dic{
                if(val.backgroundColor==UIColor.greenColor()){
                    val.backgroundColor = UIColor.whiteColor()
                }
            }
        }
        
    }
    
    //创建定时器
    //------------------------------------
    
    
    func createTimer(){
        //
        _tempNum = 0
        //
        if let t = _timer{
            _timer?.invalidate()
        }
        //
        _timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "doTimer:", userInfo: nil, repeats: true)
        //
    }
    
    func timerPause(timer:NSTimer){
        //_timer?.fireDate
    }
    
    func timerDestory(timer:NSTimer?){
        if let t = timer{
            t.invalidate()
        }else{
            _timer?.invalidate()
        }
    }
    
    func createTimerStar()->NSTimer{
       var timer = NSTimer.scheduledTimerWithTimeInterval(100, target: self, selector: "doTimer:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        return timer
    }
    
    
    func doTimer(timer:NSTimer){
        
        if let loopNum = _resultPath?.count{
            
            
            
            var len:Int = loopNum
            
            
            _player?.frame.origin.x = leftNum + _resultPath![_tempNum].x * _cellSize
            _player?.frame.origin.y = topNum + _resultPath![_tempNum].y * _cellSize
            
            var btnNameStr:String = "btn_\(Int(_resultPath![_tempNum].x))_\(Int(_resultPath![_tempNum].y))"
            _dicts?[btnNameStr]?.backgroundColor = UIColor.greenColor()
           
            
            _tempNum++
            
            if(_tempNum == loopNum){
                var nodeX:Int = Int(_resultPath![_tempNum-1].x)
                var nodeY:Int = Int(_resultPath![_tempNum-1].y)
                _grid!.setStartNode(nodeX, py: nodeY)
                //
                _timer?.invalidate()
            }
            
            
        }else{
            
            _timer?.invalidate()
            
        }
        
       
        
        
    }
    
}


