# iBeacon Playground
This is a little iOS project to showcase iBeacon system.

## Build & run
In order to build and run this project, you must install project dependencies via CocoaPods. To do so (from the project's root folder):

    $ pod install

Once CocoaPods has finished the installation, open the generated `Beacons Playground.xcworkspace` using Xcode and run the project.

## `proximityUUID` setting
The project is configured to monitor Estimote's beacons by default (`proximityUUID` = `B9407F30-F5F8-466E-AFF9-25556B57FE6D`). You can easily change this value modifying the `SPOMainViewControllerBeaconsProximityUUID` constant in `SPONearbyBeaconsViewController.m`.
