//
//  SportUserStorageFlowData.swift
//  IceHockey
//
//  Created by  Buxlan on 11/17/21.
//

import UIKit

protocol SportUserStorageFlowData {
    var image: ImageData? { get set }
    init(imageID: String)
    func load(completionHandler: @escaping () -> Void)
}

class SportUserStorageFlowDataImpl: SportUserStorageFlowData {
    
    // MARK: - Properties
    
    var image: ImageData?
    private var imageID: String
    private var handler: (UIImage?) -> Void = { _ in }
    
    private var path: String {
        return "users"
    }
    
    // MARK: - Lifecircle
    
    init() {
        image = nil
        imageID = ""
    }
    
    required init(imageID: String) {
        image = nil
        self.imageID = imageID
    }
    
    // MARK: - Helper methods
    
    func load(completionHandler: @escaping () -> Void) {
        if imageID.isEmpty {
            return
        }
        image = ImageData(imageID: imageID)
        let handler: (UIImage?) -> Void = { (image) in
            guard let image = image else {
                return
            }
            let imageData = ImageData(imageID: self.imageID, image: image)
            self.image = imageData
            completionHandler()
        }
        ImagesManager.shared.getImage(withID: imageID, path: path, completion: handler)
    }
}
