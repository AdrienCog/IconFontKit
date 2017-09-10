import UIKit

public protocol IconFont {
    
    var fontName: String { get }
    var rawValue: String { get }
    var name: String { get }
    
    static var first: IconFont { get }
    static var last: IconFont { get }
    
    init?(rawValue: String)
    static var allIcons: [IconFont] { get }
    
    func font(size: CGFloat) -> UIFont
}

extension IconFont {
    
    public var name: String {
        return String(describing: self)
    }
    
    public static var allIcons: [IconFont] {
        var icons: [IconFont] = []
        var currentValue = first.rawValue
        var i: UInt32 = 0
        while currentValue != last.rawValue {
            var iconValue = ""
            for uS in first.rawValue.unicodeScalars {
                if let v = UnicodeScalar(uS.value + i) {
                    iconValue.append(v.description)
                }
            }
            i += 1
            currentValue = iconValue
            if let icon = self.init(rawValue: currentValue) {
                icons.append(icon)
            }
        }
        return icons
    }
    
    public func font(size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size)!
    }
}


