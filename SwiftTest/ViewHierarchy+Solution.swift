import UIKit

extension Node {
    //if using Objective-C, leave this alone and implement the function in WebsiteVisitObjectiveC.m
    //if using Swift, implement this function
    static func findPathToNode(rootNode: Node, drawnAtPixel pixel: CGPoint) -> [String]{
        let result = findFirstNode(in: rootNode, drawnAtPixel: pixel)
        
        return result.map { $0.nodeId }
    }
    
    static private func findFirstNode(in node: Node,
                                      drawnAtPixel pixel: CGPoint)-> [Node] {
        var queue = Queue<Node>()
        queue.enqueue(node)
        
        var result: [Node] = []
        while !queue.isEmpty {
            guard let dequeuedNode = queue.dequeue() else { break }
            if dequeuedNode.frame.contains(pixel) { result.append(dequeuedNode) }
            
            let childrenIntersected = getTopChildrenIntersection(for: dequeuedNode,
                                                                 in: pixel)
            
            queue.enqueue(childrenIntersected)
        }
        
        return result
    }
    
    static private func getTopChildrenIntersection(for node: Node,
                                                   in pixel: CGPoint)-> [Node] {
        node.children.reduce([] as [Node]) { result, element in
            let (isChildrenIntersect, topIntersectionNode) = checkIfChildrenIntersect(nodes: result,
                                                                                      currentElement: element,
                                                                                      pixel: pixel)
            if isChildrenIntersect {
                /// If children intersect - return top most, otherwise current result
                return topIntersectionNode != nil ? [topIntersectionNode!] : result
            }
            
            return result + [element]
        }
    }
    
    static private func checkIfChildrenIntersect(nodes: [Node],
                                                 currentElement: Node,
                                                 pixel: CGPoint)-> (Bool, Node?) {
        var tempNode: Node?
        let checkCondition = nodes.contains(where: { resultElement in
            if currentElement.frame.contains(pixel) {
                tempNode = currentElement
                
                return true
            }
            
            return false
        })
        
        return (checkCondition,
                tempNode)
    }
}
