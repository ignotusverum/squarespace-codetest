import UIKit

extension Node {
    //if using Objective-C, leave this alone and implement the function in WebsiteVisitObjectiveC.m
    //if using Swift, implement this function
    static func findPathToNode(rootNode: Node, drawnAtPixel pixel: CGPoint) -> [String]{
        let result = findFirstNode(in: rootNode,
                                   drawnAtPixel: pixel)

        return result
            .map { $0.nodeId }
            .uniques
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
        return node.children.reduce([] as [Node]) { result, element in
            
            let (isChildrenIntersect, topIntersectionNode) = checkIfChildrenIntersect(nodes: result,
                                                                                      currentElement: element,
                                                                                      pixel: pixel)
            
            if isChildrenIntersect {
                if let topIntersectionNode = topIntersectionNode {
                    /// Checking  if top note contains children 
                    return topIntersectionNode.children.isEmpty ? [topIntersectionNode] : [topIntersectionNode] + getTopChildrenIntersection(for: topIntersectionNode, in: pixel)
                }
                
                return result
            }
            
            return result + [element]
        }
        .filter { $0.frame.contains(pixel) }
    }
    
    static private func checkIfChildrenIntersect(nodes: [Node],
                                                 currentElement: Node,
                                                 pixel: CGPoint)-> (Bool, Node?) {
        var tempNode: Node?
        let checkCondition = nodes.contains(where: { resultElement in
            if currentElement.frame.intersects(resultElement.frame),
                currentElement.frame.contains(pixel),
                resultElement.frame.contains(pixel) {
                tempNode = resultElement
                
                return true
            }
            
            return false
        })
        
        return (checkCondition,
                tempNode)
    }
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
