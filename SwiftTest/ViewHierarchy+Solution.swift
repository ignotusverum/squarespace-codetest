import UIKit

extension Node {
    //if using Objective-C, leave this alone and implement the function in WebsiteVisitObjectiveC.m
    //if using Swift, implement this function
    static func findPathToNode(rootNode: Node, drawnAtPixel pixel: CGPoint) -> [String]{
        let result = findFirstNode(in: rootNode, drawnAtPixel: pixel)

        let ids = result
            .filter({ !$0.frame.intersects(rootNode.frame) })
            .map { $0.nodeId }
        
        print("test is here \(rootNode.frame.contains(pixel))")
        print("ids is here - \(ids)")
        
        return ids.count > 0 ? ids : rootNode.frame.contains(pixel) ? [rootNode.nodeId] : []
    }

    static private func findFirstNode(in node: Node, drawnAtPixel pixel: CGPoint)-> [Node] {
        var queue = Queue<Node>()
        queue.enqueue(node)
        
        var result: [Node] = []
        while !queue.isEmpty {
            let dequeuedNode = queue.dequeue()
            if let dequeuedNode = dequeuedNode {
                if dequeuedNode.frame.contains(pixel) {
                    result.append(dequeuedNode)
                }
                
                let childrenIntersected = getTopChildrenIntersection(for: dequeuedNode.children, in: pixel)
                
                queue.enqueue(childrenIntersected)
            }
        }
        
        return result
    }
    
    static private func getTopChildrenIntersection(for children: [Node],
                                                   in pixel: CGPoint)-> [Node] {
        children.reduce([] as [Node]) { result, element in
                                var tempNode: Node?
            let check = result.contains(where: { resultElement in
                if element.frame.intersects(resultElement.frame) &&
                    element.frame.contains(pixel) &&
                    resultElement.frame.contains(pixel) {
                    tempNode = element
                    
                    return true
                }
                
                return false
            })
            
            if check {
                return tempNode != nil ? [tempNode!] : result
            }
            
            return result + (tempNode != nil ? [] : [element])
        }
    }
}
