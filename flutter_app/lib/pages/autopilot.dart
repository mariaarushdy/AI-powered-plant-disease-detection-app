import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class Autopilot extends StatefulWidget {
  const Autopilot({super.key});

@override
  // ignore: library_private_types_in_public_api
  _AutopilotState createState() => _AutopilotState();
}

class _AutopilotState extends State<Autopilot> {
  GoogleMapController? mapController;
  late LatLng _center =  LatLng(-35.36317206, 149.16524436);
  Set<Marker> _markers = {};
  List<LatLng> _waypoints = [];
  Set<Polyline> _polylines = {};
  List<LatLng> _waypointschosen = [];
  Set<Polyline> _polylineschosen = {};
  Set<Marker> _markerschosen = {};
  final _databaseReference = FirebaseDatabase.instance.ref().child('waypoints');
  final _loc = FirebaseDatabase.instance.ref().child('location');
  final _chose = FirebaseDatabase.instance.ref().child('chosen_places');
  BitmapDescriptor? _customIcon;

// make sure to initialize before map loading

@override
  
 
  void initState() {
    super.initState();
    _loadCustomMarker();
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final firstWaypoint = data.values.first;
        setState(() {
        _center = LatLng(firstWaypoint['latitude'], firstWaypoint['longitude']);
      });
        _updateWaypoints(data);
        print("****");
        print(data);
      }
      
    });
     
 
    _loc.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final locc = Map<String, dynamic>.from(event.snapshot.value as Map);

        _updateLoc(locc);
        print("****");
        print(locc);
      }
    });

     _chose.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final chosen_pos = Map<String, dynamic>.from(event.snapshot.value as Map);

        _updateChosen(chosen_pos);
        print("/////////////////////////////////////////");
        print(chosen_pos);
      }
    });
  }
  void _loadCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(5, 5)),
      'assets/drone_logo.png',
    ).then((d) {
      setState(() {
        _customIcon = d;
      });
    });
  }

  void _updateLoc(Map<String, dynamic> data) {
  final LatLng point = LatLng(data['latitude'], data['longitude']);
  setState(() {
    _markers.add(Marker(
      markerId: const MarkerId('location'), // Ensure unique markerId
      position: point, // Set the position
      infoWindow: InfoWindow(
        title: 'Drone Location',
        snippet: '${point.latitude}, ${point.longitude}',
      ),
      //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  });
}
  void _updateWaypoints(Map<String, dynamic> data) {
    List<LatLng> newWaypoints = [];
    // Set<Marker> newMarkers = {};
    // data.forEach((key, value) {
    //   final LatLng point = LatLng(value['latitude'], value['longitude']);
    //   newWaypoints.add(point);
    //   newMarkers.add(Marker(
    //     markerId: MarkerId(key),
    //     position: point,
    //     infoWindow: InfoWindow(
    //       title: 'generated_Waypoint',
    //       snippet: '${point.latitude}, ${point.longitude}',
    //     ),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //   ));
    // });
     Set<Marker> newMarkers = {};
  data.forEach((key, value) {
    final LatLng point = LatLng(value['latitude'], value['longitude']);
    newWaypoints.add(point);
    newMarkers.add(Marker(
      markerId: MarkerId('waypoint_$key'),
      position: point,
      infoWindow: InfoWindow(title: 'Generated Waypoint', snippet: '${point.latitude}, ${point.longitude}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));
  });
    setState(() {
      _waypoints = newWaypoints;
      _markers = newMarkers;
      _updatePolylines();
      _zoomToFitWaypoints();
    });
  }
  void _updatePolylines() {
    final polyline = Polyline(
      polylineId: const PolylineId('Waypoint'),
      points: _waypoints,
      color: const  Color.fromARGB(255, 27, 94, 8),
      width: 5,
    );

    setState(() {
      _polylines = {polyline};
    });
  }
  void _updateChosen(Map<String, dynamic> data) {
    List<LatLng> newWaypoints = [];
      Set<Marker> newMarkers = {};
  data.forEach((key, value) {
    final LatLng point = LatLng(value['latitude'], value['longitude']);
    newWaypoints.add(point);
    newMarkers.add(Marker(
      markerId: MarkerId('chosen_$key'),
      position: point,
      infoWindow: InfoWindow(title: 'Selected Waypoint', snippet: '${point.latitude}, ${point.longitude}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
  });
    setState(() {
      _waypointschosen = newWaypoints;
      _markerschosen = newMarkers;
      
    });
  }
  

 

  void _zoomToFitWaypoints() {
    if (_waypoints.isEmpty || mapController == null) return;

    LatLngBounds bounds;
    if (_waypoints.length == 1) {
      bounds = LatLngBounds(
        southwest: _waypoints.first,
        northeast: _waypoints.first,
      );
    } else {
      final southwest = LatLng(
        _waypoints.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
        _waypoints.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
      );
      final northeast = LatLng(
        _waypoints.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
        _waypoints.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
      );
      bounds = LatLngBounds(southwest: southwest, northeast: northeast);
    }

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _zoomToFitWaypoints(); // Call zoom function on map creation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drone Waypoints'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          
          target: _center,
          zoom: 11.0,
        ),
        markers: {..._markers, ..._markerschosen},
        
        polylines: _polylines,
      ),
    );
  }
}