
import 'package:flutter/cupertino.dart';
import 'package:new1/address.dart';

class AppData extends ChangeNotifier
{
  Address pickupLocation, dropOffLocation;

  void updatePickupAddress (Address pickupAddress)
  {
    pickupLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress (Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}