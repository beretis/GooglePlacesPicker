import UIKit
import GoogleMaps

class PlacePickerView2: UIView {
    var mapView: GMSMapView!
    var pinView: UIImageView!
    var circularButton: UIButton!
    var parentStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupMapView()
        setupBottomView()
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate(
            [mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
             mapView.topAnchor.constraint(equalTo: topAnchor),
             mapView.leftAnchor.constraint(equalTo: leftAnchor),
             mapView.rightAnchor.constraint(equalTo: rightAnchor)])
        
        NSLayoutConstraint.activate([
            pinView.heightAnchor.constraint(equalToConstant: 40),
            pinView.widthAnchor.constraint(equalToConstant: 40),
            pinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            pinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            circularButton.heightAnchor.constraint(equalToConstant: 40),
            circularButton.widthAnchor.constraint(equalToConstant: 40),
            circularButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -4),
            circularButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setupPinView() {
        let pin = UIImage(named: "pin")
        pinView = UIImageView(image: pin)
        pinView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pinView)
    }
    
    private func setupMapView() {
        self.mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        
        self.setupPinView()
        self.setupCurrentLocationButton()
    }
    
    private func setupCurrentLocationButton() {
        circularButton = UIButton(type: .system)
        circularButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let image = UIImage(named: "localization")?.withRenderingMode(.alwaysTemplate)
        circularButton.setImage(image, for: .normal)
        circularButton.tintColor = .black
        circularButton.backgroundColor = .white
        circularButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        circularButton.layer.masksToBounds = false
        circularButton.layer.cornerRadius = circularButton.frame.width / 2
        circularButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circularButton)
    }
    
    private func setupBottomView() {
        let contenView = UIView()
        contenView.backgroundColor = .white
        contenView.translatesAutoresizingMaskIntoConstraints = false
        
        parentStackView = UIStackView()
        parentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        parentStackView.isLayoutMarginsRelativeArrangement = true
        parentStackView.axis = .vertical
        parentStackView.distribution = .fill
        parentStackView.backgroundColor = .white
                
        let infoLabel = UILabel()
        infoLabel.text = "Set your destination"
        infoLabel.textAlignment = .center
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        let addressLabel = UILabel()
        addressLabel.text = "SOMETHING"
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.tintColor = .white
        confirmButton.backgroundColor = .black
        
        let lastSpacer = UIView()
        lastSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        parentStackView.addArrangedSubview(infoLabel)
        parentStackView.addArrangedSubview(divider)
        parentStackView.addArrangedSubview(addressLabel)
        parentStackView.addArrangedSubview(confirmButton)
        parentStackView.addArrangedSubview(lastSpacer)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contenView.addSubview(parentStackView)
        addSubview(contenView)
        
        NSLayoutConstraint.activate([
            contenView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            contenView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contenView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contenView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            parentStackView.topAnchor.constraint(equalTo: contenView.topAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: contenView.leadingAnchor),
            parentStackView.trailingAnchor.constraint(equalTo: contenView.trailingAnchor),
            parentStackView.bottomAnchor.constraint(equalTo: contenView.bottomAnchor, constant: -(contenView.layoutMargins.bottom + 20)),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            infoLabel.heightAnchor.constraint(equalToConstant: 50),
            addressLabel.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
