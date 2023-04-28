import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/style/map_style.dart';

class FindFriends extends StatefulWidget {
  const FindFriends({Key? key}) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.038344304774475, -73.07223619010055),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  late GoogleMapController _controller;

  List<dynamic> _contacts = [
    {
      "name": "Me",
      "position": LatLng(7.071095943194607, -73.09542840448717),
      "marker": 'assets/markers/marker-5.png',
      "image": 'assets/images/avatar-5.png',
    },
    {
      "name": "Omar",
      "position": LatLng(7.088264308145569, -73.10577371522287),
      "marker": 'assets/markers/marker-1.png',
      "image": 'assets/images/avatar-1.png',
    },
    {
      "name": "Mario",
      "position": LatLng(7.11576845737679, -73.11480008465625),
      "marker": 'assets/markers/marker-3.png',
      "image": 'assets/images/avatar-3.png',
    },
    {
      "name": "Diego",
      "position": LatLng(7.063775419944369, -73.09406398005157),
      "marker": 'assets/markers/marker-4.png',
      "image": 'assets/images/avatar-4.png',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: _markers,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            controller.setMapStyle(MapStyle().aubergine);
          },
        ),
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _controller.moveCamera(
                          CameraUpdate.newLatLng(_contacts[index]["position"]));
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _contacts[index]['image'],
                            width: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _contacts[index]["name"],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
        )
      ],
    ));
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _contacts.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['name']),
        position: contact['position'],
        icon: await _getAssetIcon(context, contact['marker'])
            .then((value) => value),
        infoWindow: InfoWindow(
          title: contact['name'],
          snippet: 'Street 6 . 2min ago',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }
}
