//
//  FirebaseUtils.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

let db = Firestore.firestore()
let userCollection = db.collection("users")
let destinationCollection = db.collection("destinations")
let reviewCollection = db.collection("reviews")
let tripCollection = db.collection("trips")
let profileCollection = db.collection("profiles")
let eventCollection = db.collection("events")
let imageCollection = db.collection("images")

let storageRef = Storage.storage().reference()

let firebaseDecoder: Firestore.Decoder = {
    let decoder = Firestore.Decoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

let firebaseEncoder: Firestore.Encoder = {
    let encoder = Firestore.Encoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()
