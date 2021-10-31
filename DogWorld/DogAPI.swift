//
//  DogAPI.swift
//  DogWorld
//
//  Created by BarisOdabasi on 6.03.2021.
//

import UIKit

class DogAPI {
    
    enum EndPoint {
        case randomImageFromAllDogs
        case randomImageForBreed(breed: String)
        case listAllBreeds
        
        var urlString: String {
            switch self {
            case .randomImageFromAllDogs:
                return "https://dog.ceo/api/breeds/image/random"
                
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
                
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
        
        var url: URL {
            return URL(string: self.urlString)!
        }
    }
    
    // MARK: - Properties
    let decoder = JSONDecoder()
    
    // MARK: - Methods
    func requestBreedList(completion: @escaping (_ breeds: [String], _ error: Error?) -> Void) {
        let requestURL = EndPoint.listAllBreeds.url
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let receivedData = data {
                do {
                    let breedListReponse = try self.decoder.decode(BreedListResponse.self, from: receivedData)
                    let breeds = breedListReponse.message.keys.map({ $0 })
                    
                    completion(breeds, nil)
                }catch {
                    print(error.localizedDescription)
                    completion([], error)
                }
            }else {
                // TODO
                completion([], error)
            }
        }.resume()
    }
    
    func randomImage(forBreed breed: String, completion: @escaping (_ image: DogImage?, _ error: Error?) -> Void) {
        let requestURL = EndPoint.randomImageForBreed(breed: breed).url
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let receivedData = data {
                do {
                    let dogImage = try self.decoder.decode(DogImage.self, from: receivedData)
                    completion(dogImage, nil)
                } catch(let decodingError) {
                    print(decodingError.localizedDescription)
                    completion(nil, decodingError)
                }
            }else {
                print(error!.localizedDescription)
                completion(nil, error)
            }
        }.resume()
    }
    
    func requestImage(forURL url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.downloadTask(with: url) { (url, _, error) in
            if let localPath = url {
                let imageData = try! Data(contentsOf: localPath)
                let image = UIImage(data: imageData)
                
                completion(image, nil)
            }else {
                completion(nil, error)
            }
        }.resume()
    }
}
