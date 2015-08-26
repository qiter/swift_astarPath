//
//  Array2DTyped.swift
//  2049
//
//  Created by Daniel Beard on 12/6/14.
//  Copyright (c) 2014 DanielBeard. All rights reserved.
//

import Foundation

public class Array2DTyped<T: Equatable>: Printable {
    
    var cols:Int, rows:Int
    var matrix:[T]
    
    init(cols:Int, rows:Int, defaultValue:T){
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows,repeatedValue:defaultValue)
    }
    
    public subscript(col:Int, row:Int) -> T {
        get{
            return matrix[cols * row + col]
        }
        set{
            matrix[cols * row + col] = newValue
        }
    }
    
    func colCount() -> Int {
        return self.cols
    }
    
    func rowCount() -> Int {
        return self.rows
    }
    
    func withinBounds(x: Int, y: Int) -> Bool {
        return x >= 0 && x < cols && y >= 0 && y < rows
    }
    
    func contains(element: T) -> Bool {
        return find(matrix, element) != nil
    }
 
    func indexOf(element: T) -> (col: Int, row: Int)? {
        for x in 0..<cols {
            for y in 0..<rows {
                if self[x, y] == element {
                    return (x, y)
                }
            }
        }
        return nil
    }
    
    public var description: String {
        var result = ""
        for y in 0..<rows {
            for x in 0..<cols {
                result += "\(self[x, y]) "
            }
            result += "\n"
        }
        return result
    }
}