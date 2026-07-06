import 'package:yamfoods_customer_app/features/map/data/models/delivery_zone_model.dart';

const List<DeliveryZoneModel> deliveryZones = [
  DeliveryZoneModel(
    name: 'Mega Cross-City Zone (Kolfe to Bole)',
    // A massive horizontal strip covering West to East Addis Ababa
    coordinates: [
      [9.0200, 38.6500], // West boundary (Kolfe Keranio)
      [9.0400, 38.7500], // North-Central boundary (Piazza / Arat Kilo)
      [9.0100, 38.8500], // Far East boundary (Ayat / CMC)
      [8.9700, 38.8000], // Southeast boundary (Bole Airport Area)
      [8.9600, 38.7400], // South-Central boundary (Gotera / Meshualekia)
      [8.9400, 38.6800], // Southwest boundary (Lebu / Jemo border)
      [9.0200, 38.6500], // Close polygon back at Kolfe
    ],
  ),

  DeliveryZoneModel(
    name: 'Northern Highlands Zone',
    // Covers the northern stretch from Entoto across to Yeka
    coordinates: [
      [9.0900, 38.7000], // Northwest boundary (Entoto / Gulele)
      [9.0700, 38.8400], // Northeast boundary (Kotebe / Yeka Hills)
      [9.0200, 38.8000], // Southeast boundary (Megenagna Area)
      [9.0300, 38.7200], // Southwest boundary (Autobis Tera / Mercato North)
      [9.0900, 38.7000], // Close polygon back at Entoto
    ],
  ),

  DeliveryZoneModel(
    name: 'Southern Industrial & Residential Zone',
    // Covers the southern lower half including Nifas Silk, Saris, and Akaki Kality
    coordinates: [
      [8.9600, 38.7200], // Northwest boundary (Saris / Nifas Silk)
      [8.9600, 38.8000], // Northeast boundary (Kality Ring Road / Goro)
      [8.8800, 38.8000], // Southeast boundary (Akaki Kality Deep South)
      [8.9000, 38.6600], // Southwest boundary (Jemo / Repi Area)
      [8.9600, 38.7200], // Close polygon back at Saris
    ],
  ),
];

/*
Please make the following improvements to the DeliveryAddressScreen:

1. Initial Map Position
When the screen opens, request the user's current location (using the existing location service if available).
Use the user's current location as the initial center of the map instead of a fixed default location.
2. Automatically Select Current Location
After obtaining the user's current location, immediately check whether it is inside any delivery zone.
If the current location is inside a delivery zone:
Automatically select it as the delivery location.
Place the marker at the current location.
Enable the Continue button.
If possible, reverse geocode the current location to display the address. If reverse geocoding is intentionally deferred to the next screen, that's also acceptable.
If the current location is outside all delivery zones:
Do not automatically select it.
Leave the Continue button disabled.
Do not show the "We don't deliver to this location" toast on initial load. That message should only appear after the user explicitly selects a location (via search or map tap).
3. Zoom After Valid Selection

Whenever the user selects a valid location by:

tapping on the map, or
selecting a search result,

and the location is inside a delivery zone:

Move the map center to the selected location.
Animate the map to a closer zoom level (for example, zoom level 17 or 18).
Update the marker position accordingly.
4. Keep Existing Behavior
The geofence validation logic should remain unchanged.
Invalid selections should still show the existing toast message.
Continue should only be enabled when the selected location is inside a delivery zone.
Follow the existing architecture and avoid introducing breaking changes.

5. on the map there should be info that tell user to search  or tab the delivery location they want.

we already have a method that get's the use current ocation use that
*/