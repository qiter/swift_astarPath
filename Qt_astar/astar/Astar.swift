//
//  Astar.swift
//  Qt_astar
//
//  Created by tencent on 15/7/27.
//  Copyright (c) 2015年 qiter. All rights reserved.
//

import UIKit

class Astar {
    
    var _open:[Node]?
    var _closed:[Node]?
    var _grid:Grid?
    var _startNode:Node?
    var _endNode:Node?
    var _path:[Node]?
    var _heuristic:()
    var _straightCost:CGFloat = 1.0
    var _diagCost:CGFloat = 1.4
    
    var _titleCost:CGFloat = 0
    
    init(){
        //_heuristic = diagonal
        
        
        
    }
    
    func findPath(grid:Grid)->Bool{
        
        _grid = grid
        _open = [Node]()
        _closed = [Node]()
        
        _startNode = _grid!._startNode
        _endNode = _grid!._endNode
        
        _startNode!.g = 0
        _startNode!.h = diagonal(_startNode!)
        _startNode!.f = _startNode!.g + _startNode!.h
        
        
        
        return search()
        //return false
    }
    
    
    func search()->Bool{
        var node:Node = _startNode!
        var temploop:Int = 0;
        while(node != _endNode!){
            
            var startX:Int = max(0,Int(node.x)-1)
            var endX:Int = min(_grid!._numCols-1,Int(node.x)+1)
            var startY:Int = max(0, Int(node.y)-1)
            var endY:Int = min(_grid!._numRows-1,Int(node.y)+1)
            
            temploop++
            
            
            for(var i:Int = startX;i<=endX;i++){
                for(var j:Int = startY;j<=endY;j++){
                  
                    var test:Node = _grid!.getNode(i, py: j)!
                    var testPosX:Int = Int(test.x)
                    var testPosY:Int = Int(test.y)
                    var nodePosX:Int = Int(node.x)
                    var nodePosY:Int = Int(node.y)
                    if(test == node || !test.walkable || !_grid!.getNode(nodePosX, py: testPosY)!.walkable || !_grid!.getNode(testPosX, py: nodePosY)!.walkable){
                        continue
                    }
                    
                    //计算花费
                    var cost:CGFloat = _straightCost;
                    if(!((node.x==test.x)||(node.y==test.y))){
                        cost = _diagCost
                    }
                    
                    //
                    var g:CGFloat = node.g + cost * test.costMultiplier
                    var h:CGFloat = diagonal(test)
                    var f:CGFloat = g + h
                    //
                    if(isOpen(test) || isClosed(test)){
                        
                        if(test.f > f){
                            test.f = f
                            test.g = g
                            test.h = h
                            test.parent = node
                        }
                        
                    }else{
                        
                            test.f = f
                            test.g = g
                            test.h = h
                            test.parent = node
                            _open?.append(test)
                        
                    }
                    
                    
                    
                }
            }//for end
            
            
            for(var o:Int = 0;o<_open?.count;o++){
            
            }
            
            _closed?.append(node)
            
            if(_open?.count==0){
                
                
                println("没有找到路径")
                
                return false
            }
            
            _open?.sort(onSort)
            node = _open!.removeAtIndex(0)
            
        }
        buildPath()
        return true
    }
    
    func onSort(n1:Node, n2:Node) -> Bool{
        return n1.f < n2.f
    }
    
    func diagonal(node:Node)->CGFloat
    {
        
        
        var dx:CGFloat = abs(node.x - _endNode!.x);
        var dy:CGFloat = abs(node.y - _endNode!.y);
        var diag:CGFloat = min(dx, dy);
        var straight:CGFloat = dx + dy;
        //短边 * 对角线代价 + （长边-短边）*直线代价
        return _diagCost * diag + (straight - 2 * diag)*_straightCost;
        
    }
    
    func buildPath(){
        //计算总消耗
        _titleCost = 0
        _path = [Node]()
        var node:Node = _endNode!
        _path?.append(node)
        while(node != _startNode){
            node = node.parent!
            _path?.insert(node, atIndex: 0)
            _titleCost += node.f
        }
        
    }
    
    func isOpen(node:Node)->Bool{
        for (var i:Int = 0;i<_open?.count;i++){
            if(_open?[i] == node){
                return true
            }
        }
        return false
    }
    
    func isClosed(node:Node)->Bool{
        for(var i:Int = 0;i<_closed?.count;i++){
            if(_closed?[i]==node){
                return true
            }
        }
        return false
    }
    
    func visited()->[Node]{
        
        return _closed!+_open!
        //return _closed!.join(_open?)
    }
    
    
}
