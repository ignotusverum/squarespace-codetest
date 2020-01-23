import Foundation

extension WebsiteVisit {
    //if using Objective-C, leave this alone and implement the function in WebsiteVisitObjectiveC.m
    //if using Swift, implement this function
    static func processWebsiteVisits(websiteVisits: [WebsiteVisit]) -> (websiteVisits: Int, uniqueVisitors: Int, sessions: Int) {
        let uniqueVisits = Array(Set(websiteVisits.map { $0.visitorId }))
        let uniqueSessionsCount = getSessions(for: websiteVisits)
        
        return (websiteVisits.count,
                uniqueVisits.count,
                uniqueSessionsCount.count)
    }

    private static func getSessions(for visits: [WebsiteVisit])-> [WebsiteVisit] {
        visits
        .reduce([] as [WebsiteVisit], { result, element in
            /// Getting latest unique visit by timestamp
            let (isValidSession, latestValidVisit) = checkForValidSession(current: element,
                                                               listOfSessions: result)
            
            if isValidSession {
                var updatedResult = result
                /// Updating results based on latest valid visit
                if let latestElement = latestValidVisit,
                    let index = updatedResult.firstIndex(where: { $0 == latestElement }) {
                    updatedResult[index] = latestElement
                }
                
                return updatedResult
            }
            
            return result + [element]
        })
    }
    
    private static func checkForValidSession(current visit: WebsiteVisit,
                                             listOfSessions: [WebsiteVisit])-> (Bool, WebsiteVisit?) {
        var latestElement: WebsiteVisit?
        let containsCheck = listOfSessions.contains(where: { resultElement in
            /// Check if timestamp is <= 30 mins
            if resultElement == visit,
                visit.timestamp - resultElement.timestamp <= 30 * 60  {
                latestElement = visit
                return true
            }
            
            return false
        })
        
        return (containsCheck,
                latestElement)
    }
}

extension WebsiteVisit {
    static func ==(lhs: WebsiteVisit, rhs: WebsiteVisit) -> Bool {
        return lhs.visitorId == rhs.visitorId
    }
}
