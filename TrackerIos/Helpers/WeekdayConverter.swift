import Foundation

extension Set where Element == WeekDay {
    init?(rawValue: String?) {
        guard let rawValue = rawValue else {
            return nil
        }
        
        let daysArray = rawValue
            .split(separator: ",")
            .compactMap { WeekDay(rawValue: Int($0) ?? 0) }
        
        if daysArray.isEmpty {
            return nil
        } else {
            self = Set(daysArray)
        }
    }
    
    
    func toRawString() -> String {
        self.map { String($0.rawValue) }
            .sorted()
            .joined(separator: ",")
    }
}
