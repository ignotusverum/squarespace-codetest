//
//  Queue.swift
//  iOSTest
//
//  Created by Vlad Z. on 1/22/20.
//  Copyright © 2020 Squarespace. All rights reserved.
//

import Foundation

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func enqueue(_ elements: [T]) {
        array.append(contentsOf: elements)
    }
    
    public mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
}

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
