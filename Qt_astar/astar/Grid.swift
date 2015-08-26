//
//  Grid.swift
//  Qt_astar
//
//  Created by qiter on 15/7/26.
//  Copyright (c) 2015年 qiter. All rights reserved.
//

import UIKit

class Grid: NSObject {
    //
    var _startNode:Node?
    var _endNode:Node?
    //var _nodes:Array2D<Node>?
    var _numCols:Int = 10
    var _numRows:Int = 10
    var _nodes:Array2DTyped<Node>?
    //
    init(numCols:Int,rows numRows:Int)
    {
        _numCols = numCols
        _numRows = numRows
        _nodes = Array2DTyped(cols: _numCols, rows: _numRows, defaultValue: Node(_x: 0, positionY: 0))
        
        for(var i:Int = 0; i < _numCols; i++)
        {
            for(var j:Int = 0; j < _numRows; j++)
            {
                _nodes?[i,j] = Node(_x: CGFloat(i), positionY: CGFloat(j))
            }
        }
        if let nods = _nodes{
            
            //println(nods[1,1])

        }
        //println(_nodes!)
        
    }
    
    /**
    * Returns the node at the given coords.
    * @param x The x coord.
    * @param y The y coord.
    */
    func getNode(x:Int,py y:Int)->Node?
    {
        if let node = _nodes{
            return node[x,y];
        }else{
            return nil
        }
        
    }
    /**
    * Sets the node at the given coords as the end node.
    * @param x The x coord.
    * @param y The y coord.
    */
    func setEndNode(x:Int,py y:Int)
    {
        if let node = _nodes{
            _endNode =  node[x,y];
        }
    }
    /**
    * Sets the node at the given coords as the start node.
    * @param x The x coord.
    * @param y The y coord.
    */
    func setStartNode(x:Int,py y:Int)
    {
        
        if let node = _nodes{
            _startNode = node[x,y];
        }
    }
    
    /**
    * Sets the node at the given coords as walkable or not.
    * @param x The x coord.
    * @param y The y coord.
    */
    func setWalkable(x:Int,py y:Int, val value:Bool)
    {
        
        if let node = _nodes{
            node[x,y].walkable = value;
        }
        
        
    }
    
    
}