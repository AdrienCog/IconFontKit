import UIKit


final class IconFontListController: UIViewController {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var fontsControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "IconFontCell"
    
    var icons: [IconFont] = []
    
    let fonts: [[IconFont]] = [FontAwesomeEnum.allIcons, IcoFontEnum.allIcons]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fonts.enumerated().forEach { (i, icons) in
            fontsControl.setTitle(icons.first?.fontName ?? "", forSegmentAt: i)
        }
        refreshIcons()
    }

    @IBAction func changeFont(_ sender: Any) {
        refreshIcons()
    }
    
    func refreshIcons() {
        icons = fonts[fontsControl.selectedSegmentIndex].filter({ (icon) -> Bool in
            if let search = searchBar.text, search != "" {
                return icon.name.lowercased().contains(search.lowercased())
            }else{
                return true
            }
        })
        collectionView.reloadData()
        if let icon = icons.first {
            setSelected(icon: icon)
        }
    }
    
    func setSelected(icon: IconFont) {
        iconLabel.setIcon(icon, size: 20)
        nameLabel.text = icon.name
    }
}

extension IconFontListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshIcons()
    }
}

extension IconFontListController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let icon = icons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.setIcon(icon, size: 20)
        (cell.viewWithTag(2) as? UILabel)?.text = icon.name
        (cell.viewWithTag(3) as? UILabel)?.text = icon.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let icon = icons[indexPath.item]
        setSelected(icon: icon)
    }
}
