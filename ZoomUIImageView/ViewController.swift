//
//  ViewController.swift
//  ZoomUIImageView
//
//  Created by soliduSystem on 30/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let indexImage : Int = 0
    @IBOutlet weak var lblCurrentImage: UILabel!
    
    @IBOutlet weak var lblTotalImage: UILabel!
    
    
    @IBOutlet var btnsChangeImage: [UIButton]!
    
    
    @IBAction func actionTakePhoto(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Toma O Elige Una Foto", message: "Agrega una foto a la coleccion de zoom", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Toma Foto", style: .default, handler: { UIAlertAction in
            self.showCamera()
        }))
        
        ac.addAction(UIAlertAction(title: "Abrir Galeria", style: .default, handler: { UIAlertAction in
            self.showGaleria()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { UIAlertAction in
            
        }))
        
        self.present(ac, animated: true)

    }
    
    private func showCamera() -> Void {
        
    }
    
    private func showGaleria() -> Void {
        
    }
    
    @IBAction func actionChangeImage(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognized(_:)))
        tapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    
    
    
    // Método que maneja el gesto de doble toque
    @objc func doubleTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let pointInView = sender.location(in: imageView)
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
}

extension ViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

