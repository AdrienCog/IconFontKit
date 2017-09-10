import UIKit

extension UILabel {
    
    func setIcon(_ icon: IconFont, size: CGFloat) {
        font = icon.font(size: size)
        text = icon.rawValue
    }
}

extension UIImage {
    
    static func from(icon: IconFont, size: CGFloat = 20, color: UIColor = .black) -> UIImage? {
        
        let font = icon.font(size: size)
        
        let glyphSize: CGSize = icon.rawValue.size(
            withAttributes: [
                .font: font
            ])
        
        let rect = CGRect(origin: .zero, size: glyphSize)
        
        UIGraphicsBeginImageContextWithOptions(glyphSize, false, 0.0)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        icon.rawValue.draw(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes:[
                .font: font,
                .paragraphStyle: style,
                .foregroundColor: color
            ],
            context:nil)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImageView {
    
    static func from(icon: IconFont, frame: CGRect, color: UIColor = .black) -> UIImageView {
        
        let size = min(frame.width, frame.height)
        
        let view = UIImageView(image: UIImage.from(icon: icon, size: size, color: color))
        view.contentMode = .center
        view.frame = frame
        
        return view
    }
}

extension UITabBarItem {
    
    func setIcon(_ icon: IconFont) {
        image = UIImage.from(icon: icon)
    }
}
