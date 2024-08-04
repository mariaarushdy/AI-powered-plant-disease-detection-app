import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/pages/my_home_page.dart';
import 'package:flutter_application_1/pages/autopilot.dart';
import 'package:flutter_application_1/pages/video_stream.dart';
import 'package:flutter_application_1/pages/database_img.dart';
import 'package:flutter_application_1/pages/more.dart'; // Replace MorePage with SettingsPage

void main() => runApp(MaterialApp(home: SelectedArea()));

class SelectedArea extends StatefulWidget {
  const SelectedArea({Key? key}) : super(key: key);

  @override
  State<SelectedArea> createState() => _SelectedAreaState();
}

class _SelectedAreaState extends State<SelectedArea> {
  GoogleMapController? mapController;
  Set<Marker> _markers = {};
  Map<String, String> _markerIDs = {};
  Set<String> _selectedMarkerIds = {};
  LatLng _initialPosition = const LatLng(-35.36317206, 149.16524436);
  late bool flag = false; 
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('chosen_places');
  final _loc = FirebaseDatabase.instance.ref().child('location');
  final DatabaseReference _rusure = FirebaseDatabase.instance.ref().child('rusure');
  @override
  void initState() {
    flag =false;
    super.initState();
    _loadMarkers();
    _loc.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final locc = Map<String, dynamic>.from(event.snapshot.value as Map);
        final firstWaypoint = locc.values.first;
        _initialPosition=LatLng(firstWaypoint['latitude'], firstWaypoint['longitude']);
        _zoomToFitWaypoints();
      }
    });
  }

  Future<void> _loadMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    String? markersJson = prefs.getString('markers');
    if (markersJson != null) {
      try {
        Iterable decoded = jsonDecode(markersJson);
        setState(() {

          _markers.clear();
          _markerIDs.clear();
          _markers = Set.from(decoded.map((markerMap) {

            String id = markerMap['id'];
            double latitude = markerMap['latitude'];
            double longitude = markerMap['longitude'];
            String? firebaseKey = markerMap['firebaseKey'];

            // Store firebaseKey safely
            if (firebaseKey != null) {
              _markerIDs[id] = firebaseKey;
            }

            return Marker(
              markerId: MarkerId(id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: 'Chosen Place', snippet: '$latitude, $longitude'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              onTap: () => _selectMarker(id),
            );
          }));
        });
      } catch (e) {
        print('Error loading markers: $e');
      }
    }
  }

  void _selectMarker(String markerId) {
    setState(() {
      if (_selectedMarkerIds.contains(markerId)) {
        _selectedMarkerIds.remove(markerId);
      } else {
        _selectedMarkerIds.add(markerId);
      }
    });
  }

  void _handleTap(LatLng tappedPoint) {
    final String markerId = tappedPoint.toString();
    if (_markers.length == 4) {
      _AreUsure(context);
      if (flag == true){
      final DatabaseReference newRef = _rusure.push();
      newRef.set("true");
      }
      return;
    }
    if (_selectedMarkerIds.contains(markerId)) {
      _removeMarker(markerId);
      return;
    }
    
    if (_markers.length >= 4) {
      _showDialog(context);
      return;
    }
    

    final newMarker = Marker(
      markerId: MarkerId(markerId),
      position: tappedPoint,
      infoWindow: InfoWindow(
        title: 'Chosen Place',
        snippet: '${tappedPoint.latitude}, ${tappedPoint.longitude}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      onTap: () => _selectMarker(markerId),
    );

    setState(() {
      _markers.add(newMarker);
    });

    final DatabaseReference newRef = _databaseReference.push();
    newRef.set({
      'latitude': tappedPoint.latitude,
      'longitude': tappedPoint.longitude,
    }).then((_) {
      _markerIDs[markerId] = newRef.key!;
    });
    
    _saveMarkers();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limit Reached'),
          content: const Text('You can only choose up to 4 places.'),
          backgroundColor: Colors.lightGreen,
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  // ignore: non_constant_identifier_names
  void _AreUsure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you want to procced?'),
          backgroundColor: Colors.lightGreen,
          actions: <Widget>[
            TextButton(
              child: const Text('yes'),
              onPressed: () {
                 flag = true;
                 Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('no'),
              onPressed: () {
                flag = false; 
                Navigator.of(context).pop();// Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  void _removeMarker(String markerId) {
    Marker? markerToRemove;
    for (var marker in _markers) {
      if (marker.markerId.value == markerId) {
        markerToRemove = marker;
        break;
      }
    }

    if (markerToRemove != null) {
      setState(() {
        _markers.remove(markerToRemove);
        if (_markerIDs.containsKey(markerId)) {
          _databaseReference.child(_markerIDs[markerId]!).remove();
          _markerIDs.remove(markerId);
        }
      });
      _saveMarkers();
    }
  }

  Future<void> _saveMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    String markersJson = jsonEncode(_markers.map((m) => {
      'id': m.markerId.value,
      'latitude': m.position.latitude,
      'longitude': m.position.longitude,
      'firebaseKey': _markerIDs[m.markerId.value]
    }).toList());
    await prefs.setString('markers', markersJson);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.moveCamera(CameraUpdate.newLatLngZoom(_initialPosition, 30.0));
  }
  void _zoomToFitWaypoints() {
    LatLngBounds bounds;
      bounds = LatLngBounds(southwest: _initialPosition, northeast: _initialPosition);
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Selected Area'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _selectedMarkerIds.isEmpty ? null : _removeSelectedMarkers,
            tooltip: 'Remove Selected Markers',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0,
              ),
              markers: _markers,
              onTap: _handleTap,
            ),
          ),
          BottomBar(),
        ],
      ),
    );
  }

  void _removeSelectedMarkers() {
    for (String markerId in _selectedMarkerIds.toList()) {
      _removeMarker(markerId);
    }
    _selectedMarkerIds.clear();
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Autopilot()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_chart, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DatabaseImg()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoStream()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            ),
          ),
        ],
      ),
    );
  }
}