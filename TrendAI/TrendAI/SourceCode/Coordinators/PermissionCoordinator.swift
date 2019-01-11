//
//  PermissionCoordinator.swift
//  TaxiHungLong
//
//  Created by Administrator on 7/6/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications
import Contacts

typealias StatusCompletion = (UInt) -> ()

enum LocationStatus {
  case notYet
  case denied
  case authorized
}

typealias Coordinate = CLLocationCoordinate2D

typealias LocationStatusCompletion = (LocationStatus) -> ()

class PermissionCoordinator: NSObject{
  
  static let share = PermissionCoordinator()
  
  let locationManager: CLLocationManager = CLLocationManager()
  
  let contactStore = CNContactStore()
  var userLocation:CLLocation? = nil
  
  var locCompletion:LocationStatusCompletion? = nil
  
  var  notiCompletion:StatusCompletion? = nil
  
  override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 10.0
  }
  
  func checkLocationPermission() -> LocationStatus {
    switch(CLLocationManager.authorizationStatus()) {
      case .authorizedAlways, .authorizedWhenInUse:
        return LocationStatus.authorized
      case .restricted, .denied:
        return LocationStatus.denied
      case  .notDetermined:
        return LocationStatus.notYet
    }
  }
  
  func requestLocationPermission( completion: @escaping LocationStatusCompletion) {
    locationManager.requestWhenInUseAuthorization()
    self.locCompletion = completion
  }
  
  func checkLocalNotification(completion: @escaping StatusCompletion) {
    
    if #available(iOS 10.0, *) {
      let current = UNUserNotificationCenter.current()
      current.delegate = self
      current.getNotificationSettings(completionHandler: { (settings) in
        if settings.authorizationStatus == .notDetermined {
          // Notification permission has not been asked yet, go for it!
          completion(0)
        }
        
        if settings.authorizationStatus == .denied {
          // Notification permission was previously denied, go to settings & privacy to re-enable
          completion(1)
        }
        
        if settings.authorizationStatus == .authorized {
          // Notification permission was already granted
          completion(2)
        }
      })
    } else {
      // Fallback on earlier versions
      if let notificationSettings = UIApplication.shared.currentUserNotificationSettings {
        print( "notificationSettings.type \(notificationSettings.types.rawValue)")
        completion(2)
      } else {
        print("notificationSettings == nill ")
        completion(0)
      }
    }
  }
    
  func checkContactPermission(completion: @escaping StatusCompletion) {
    switch CNContactStore.authorizationStatus(for: .contacts) {
    case .authorized:
      completion(2)
    case .denied,.restricted:
      completion(1)
    case .notDetermined:
      completion(0)
    }
  }
  
//  func requestNotificationPermission(completion:@escaping StatusCompletion) {
//    if #available(iOS 10.0, *) {
//      //iOS 10 or above version
//      UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
//        if (granted) {
//          print("UNUserNotificationCenter granted true")
//          DispatchQueue.main.async {
//            UIApplication.shared.registerForRemoteNotifications()
//          }
//          completion(1)
//        } else {
//          print("UNUserNotificationCenter granted false")
//          //Do stuff if unsuccessful...
//          completion(0)
//        }
//      })
//    } else {
//      //iOS 9
//      let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
//      let setting = UIUserNotificationSettings(types: type, categories: nil)
//      UIApplication.shared.registerUserNotificationSettings(setting)
//      UIApplication.shared.registerForRemoteNotifications()
//
//      completion(1)
//    }
//  }
  
  func requestContactPermission(completion:@escaping StatusCompletion) {
    contactStore.requestAccess(for: .contacts) { (access, accessError) in
      if access {
        completion(1)
      } else {
        completion(0)
      }
    }
  }
  
  func startLocationUpdate() {
    locationManager.startUpdatingLocation()
  }
 
  func stopLocationUpdate() {
    locationManager.stopUpdatingLocation()
  }
  
  func openUserSetting(completion:LocationStatusCompletion? = nil) {
      let alertController = UIAlertController (title: "Warning", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)

      let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
              print("Settings opened: \(success)") // Prints true
            })
          } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(settingsUrl)
          }
        }
      }
    
      alertController.addAction(settingsAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
      alertController.addAction(cancelAction)

    
      topViewController()?.present(alertController, animated: true, completion: nil)
    
    if completion != nil {
      self.locCompletion = completion
    }
    
  }
  
  func updateLocationServiceStatus() {
    locCompletion?(checkLocationPermission())
//    locCompletion = nil
  }
  
  func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
extension PermissionCoordinator: CLLocationManagerDelegate{
  
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
    print("didChangeAuthorization 1 \(status)")
    if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
      openUserSetting()
    } else {
      updateLocationServiceStatus()
      startLocationUpdate()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = manager.location {
      print("location: \(location)")
      userLocation = location
    }
  }
}

extension PermissionCoordinator: UNUserNotificationCenterDelegate {
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("userNotificationCenter center: \(notification.request.content.userInfo) -- completionHandler")
    
    completionHandler([.alert,.sound,.badge])
  }
}
