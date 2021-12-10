//
//  FirebaseImagesLoader.swift
//  IceHockey
//
//  Created by  Buxlan on 11/23/21.
//

import Firebase

protocol FirebaseImagesLoader: FirebaseLoader, AnyObject {
    var objectIdentifier: String { get }
    var imagesPath: String { get }
    func load(completionHandler: @escaping (StorageFlowData?) -> Void)
    var handlers: [String: (UIImage?) -> Void] { get set }
    var imagesIdentifiers: [String] { get set }
    init(objectIdentifier: String,
         imagesIdentifiers: [String])
}

extension FirebaseImagesLoader {
    
    func load(completionHandler: @escaping (StorageFlowData?) -> Void) {
        guard !objectIdentifier.isEmpty,
              !imagesIdentifiers.isEmpty else {
            completionHandler(nil)
            return
        }
        let imagesManager = ImagesManager.shared
        handlers.removeAll()
        var images: [ImageData] = []
        for imageID in imagesIdentifiers {
            if imageID.isEmpty {
                return
            }
            images.append(ImageData(imageID: imageID))
            let handler: (UIImage?) -> Void = { [weak self] (image) in
                guard let self = self else {
                    completionHandler(nil)
                    return
                }
                self.handlers[imageID] = nil
                if let image = image,
                   let index = images.firstIndex(where: { $0.imageID == imageID }) {
                    let imageData = ImageData(imageID: imageID, image: image)
                    images[index] = imageData
                }
                if self.handlers.count == 0 {
                    let object = StorageFlowDataImpl(objectIdentifier: self.objectIdentifier,
                                              images: images)
                    completionHandler(object)
                }
            }
            handlers[imageID] = handler
        }
        for imageID in imagesIdentifiers {
            if imageID.isEmpty {
                return
            }
            if let handler = handlers[imageID] {
                imagesManager.getImage(withID: imageID,
                                              path: imagesPath,
                                              completion: handler)
            }
        }
    }
    
}
