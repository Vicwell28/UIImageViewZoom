//
//  ViewController.swift
//  ZoomUIImageView
//
//  Created by soliduSystem on 30/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Override Func
     override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognized(_:)))
        tapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGesture)
        
        let screenEdgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanGestureRecognizerRight(_:)))
        screenEdgePanRight.edges = .left
        view.addGestureRecognizer(screenEdgePanRight)
        
        let screenEdgePanLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanGestureRecognizerLeft(_:)))
        screenEdgePanLeft.edges = .right
        view.addGestureRecognizer(screenEdgePanLeft)
        
        self.btnsChangeImage.forEach{$0.isHidden = true}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTotalImage: UILabel!
    @IBOutlet var btnsChangeImage: [UIButton]!

    
    // MARK: - Public let / var
    
    // MARK: - Private let / var
    private var dataSourceImages : [UIImage] = [UIImage]()
    private var indexImage : Int = -1

    // MARK: - IBAction
    @IBAction func actionTakePhoto(_ sender: UIButton) {
        self.showAlerActionSheet()
    }

     @IBAction func actionChangeImage(_ sender: UIButton) {
        
        if sender.tag == 0 {
           self.showNextImage()
        } else {
            self.showPreviousImage()
        }
        
    }

}



// MARK: - Public Func
extension ViewController {
    
}

// MARK: - Private Func
extension ViewController {
    


     private func showAlerActionSheet(){
        let ac = UIAlertController(title: "Toma O Elige Una Foto", message: "Agrega una foto a la coleccion de zoom", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Toma Foto", style: .default, handler: { _ in self.showCamera() }))
        
        ac.addAction(UIAlertAction(title: "Abrir Galeria", style: .default, handler: { _ in self.showGaleria() }))
        
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        self.present(ac, animated: true)
    }

     private func showCamera() -> Void {
        self.selectSourceTypeiImagePicker(.camera)
    }

     private func showGaleria() -> Void {
        self.selectSourceTypeiImagePicker(.photoLibrary)
    }

    private func showPreviousImage(){
         if self.dataSourceImages.count >= 2 {
                
                self.hiddenButton(by: 1)
                
                self.indexImage = self.indexImage == 0 ? 0 : self.indexImage - 1
               
                self.animationChangeImage(isNext: true)
            }
    }

    private func showNextImage(){
        if self.dataSourceImages.count >= 2 {
                
                self.hiddenButton(by: 1)

                self.indexImage = self.indexImage < self.dataSourceImages.count - 1 ? self.indexImage + 1 : self.indexImage
                
                self.animationChangeImage()
            }
    }

    private func hiddenButton(by tag : Int){
         if self.btnsChangeImage[tag].isHidden {
                    self.btnsChangeImage[tag].isHidden = false
            }
    }

    private func animationChangeImage(isNext : Bool = false){

        if isNext {
             if self.indexImage == self.dataSourceImages.count - 1 {
                    self.btnsChangeImage[1].isHidden = true
                }
        } else {
             if self.indexImage == 0 {
                    self.btnsChangeImage[0].isHidden = true
                }
        }

        self.lblTotalImage.text = "\(self.indexImage + 1)/\(self.dataSourceImages.count)"

                UIView.animate(withDuration: 0.2) {
                    self.imageView.alpha = 0
                } completion: { Bool in
                    UIView.animate(withDuration: 0.2) {
                        self.imageView.image = self.dataSourceImages[self.indexImage]
                        self.imageView.alpha = 1
                    }
                }
    }

     private func selectSourceTypeiImagePicker(_ st : UIImagePickerController.SourceType ){
        if UIImagePickerController.isSourceTypeAvailable(st) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = st;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }

     @objc func screenEdgePanGestureRecognizerRight(_ sender: UITapGestureRecognizer) {
        print("Right")
    }
    
    @objc func screenEdgePanGestureRecognizerLeft(_ sender: UITapGestureRecognizer) {
        print("Left")
    }
    
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

// MARK: - Services
extension ViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - Services
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.imageView.image = image
        self.dataSourceImages.append(image)
        self.indexImage = self.dataSourceImages.count - 1
        self.lblTotalImage.text = "\(self.indexImage + 1)/\(self.dataSourceImages.count)"
        
        if self.dataSourceImages.count >= 2 {
            self.btnsChangeImage[0].isHidden = false
        }
    }
}
