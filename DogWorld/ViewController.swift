//
//  ViewController.swift
//  DogWorld
//
//  Created by BarisOdabasi on 6.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var api = DogAPI()
    var breeds = [String]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 12
        
        api.requestBreedList { (breeds, error) in
            if !breeds.isEmpty {
                self.breeds = breeds.sorted()
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                    self.selectBreed(self.breeds[0])
                }
            }
        }
    }
    
    // MARK: - Methods
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?) {
        if let dogImage = dogImage {
            api.requestImage(forURL: dogImage.imageURL) { (image, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    UIView.transition(with: self.imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.imageView.image = image
                    }, completion: nil)
                }
            }
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func selectBreed(_ breed: String) {
        UIView.transition(with: self.imageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.imageView.image = nil
        }, completion: nil)
        
        activityIndicator.startAnimating()
        api.randomImage(forBreed: breed) { (dogImage, error) in
            self.handleRandomImageResponse(dogImage: dogImage, error: error)
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ barButton: UIBarButtonItem) {
        let currentRow = pickerView.selectedRow(inComponent: 0)
        let selectedBreed = breeds[currentRow]
        
        selectBreed(selectedBreed)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBreed = breeds[row]
        selectBreed(selectedBreed)
    }
}
