import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new1/address.dart';
import 'package:new1/appData.dart';
import 'package:new1/configmaps.dart';
import 'package:new1/directionDetails.dart';
import 'package:new1/requestassistant.dart';
import 'package:provider/provider.dart';

class AssistantMethods
{
  static Future<String> searchCordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1,st2,st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDhISWQUTALqAdtvhEcwGeSihUXe535ui0";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed")
    {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      //st3 = response["results"][0]["address_components"][2]["long_name"];
      // st4 = response["results"][0]["address_components"][3]["long_name"];

      placeAddress =st1 + ", " + st2  ;

      Address userPickupAddress = new Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context,listen: false).updatePickupAddress(userPickupAddress);
    }

    return placeAddress;


  }

  static Future <DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed")
    {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
}
