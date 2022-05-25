# Pzz Delivery App
Pzz Delivery App
![](photo.url)


## Objective
The application can be used by customers to simplify the work with the company's website.

## Summary

The application includes:
0. Registration screen.
1. Login screen. By clicking on the "Log in" button, a request is sent to the server to log in. Then user goes to MainWrapperViewController which include Custom UITabBarController.
2. Custom UITabBarController with viewControllers = [Products, Basket, Profile].
3. Products screen. 
4. Basket screen. 
5. Profile screen, contains UIViewController with UITableView. By clicking on a table cell, the user goes to the screens written in SwiftUI:
    5.1. AdressesView;
    5.2. HistoryView;
    5.3. SettingsView; 
6. MapView screen, which uses MapBox maps on which delivery zones and pick-up points are programmatically added using GeoJSON.

## Registration Screen

The user needs to enter his phone number, and then click the "Register" button, after which an SMS message with a password will be sent to the user.

## Custom UITabBarController

Tab bar includes custom icons. The basket icon is dynamicly changes according to the items in the basket.

![TabBar](https://media.giphy.com/media/XVNtX7ngk5lEKAJJky/giphy.gif)

## Products screen

UITableViewController with custom cells and UICollectionView for navigation at screen.

![Products](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/products.PNG)

## Basket screen with settings menu

Contains UITableView with custom cells.

![Basket](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/basketSettings.PNG)

## Profile screen

![Profile](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/profileTextField.PNG)

## Addresses View
Contains List with addresses, which is load from pzz.by server.
![Addresses](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/AddressesView.PNG)

## History View
Contains List of orders, which is load from realm database.

![History](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/HistoryView.PNG)

## Settings View
Contains List of settings, that can also be seen on the Basket screen by clicking on the gear button.

![Settings](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/SettingsView.PNG)

## Map screen

![Map](https://github.com/R1ick/Pzz/blob/dev/PzzApp/Images/MapVC.jpeg)

# Backend

Data on products and addresses are downloaded from the pzz server. The server is also used for registration and login. The settings are implemented using realm.
