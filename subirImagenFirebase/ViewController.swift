//
//  ViewController.swift
//  subirImagenFirebase
//
//  Created by d182_oscar_a on 12/05/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var storageImage = UIImage()
    var ref : DatabaseReference!
    
    let uploadImage : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "deadmau5"), for: .normal)
        b.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
        
    }()
    
    let botonEnviar : UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.red
        b.setTitle("Subir imagen", for: .normal)
        b.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(uploadImage)
        view.addSubview(botonEnviar)
        
        uploadImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 100).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        botonEnviar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        botonEnviar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        botonEnviar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        botonEnviar.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        ref = Database.database().reference() //inicializo mi referencia
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController() //para seleccionar una imagen
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker,animated: true,completion: nil) //lo muestra de forma modal, hay que hacer un dismiss
    }
    
    @objc func saveImage(){
        let id = ref.childByAutoId().key
        let storage = Storage.storage().reference() //referencia al storage
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        //cambiamos el metadata para que se guarde en png
        let metadata = StorageMetadata()
        metadata.contentType = "imagen/png"
        
        //metodo que se encarga de subir la informacion al storage
        //coN UIImagePNGRepresentation agarra la imagen, lo convierte a PNG
        directorio.putData(UIImagePNGRepresentation(storageImage)!, metadata: metadata) { (data, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            print("Se subio la imagen")
        }
        let values = ["nombre": String(describing: directorio)]
        ref.child("imagenes").child(id).setValue(values)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //info trae todo el metadata de la imagen, es un diccionario con varios datos de la imagen
        if let imagen = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            //tratar la informacion que viene como una imagen, por eso escribo el as?
            self.uploadImage.setImage(imagen, for: .normal)
            storageImage = imagen
            dismiss(animated: true, completion: nil) //
        }
        
    }


}

