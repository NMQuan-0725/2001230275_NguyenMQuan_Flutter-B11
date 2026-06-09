import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cau4_Maps extends StatefulWidget {
  final String studentId; // Pass the ID from your login
  const Cau4_Maps({super.key, required this.studentId});

  @override
  State<Cau4_Maps> createState() => _Cau4_MapsState();
}

class _Cau4_MapsState extends State<Cau4_Maps> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  String _distanceResult = "Loading your home location...";
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _initializeMapFeatures();
  }

  Future<void> _initializeMapFeatures() async {
    // 1. Request Location Permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() => _distanceResult = "Location permission denied");
      return;
    }

    // 2. Fetch "NhaRieng" coordinates from Supabase
    try {
      final data = await _supabase
          .from('SinhVien')
          .select('NhaRieng_Lat, NhaRieng_Lng')
          .eq('MaSV', widget.studentId)
          .single();

      final lat = data['NhaRieng_Lat'] as double;
      final lng = data['NhaRieng_Lng'] as double;

      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('home'),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(title: 'My Home'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
        _distanceResult = "Home loaded! Tap map to add second marker.";
      });
    } catch (e) {
      setState(() => _distanceResult = "Error loading location: $e");
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      // Keep Home marker, allow replacing the 2nd marker
      _markers.removeWhere((m) => m.markerId.value != 'home');

      _markers.add(
        Marker(markerId: const MarkerId('target'), position: position),
      );

      if (_markers.length == 2) {
        _calculateDistance();
      }
    });
  }

  void _calculateDistance() {
    final home = _markers.firstWhere((m) => m.markerId.value == 'home');
    final target = _markers.firstWhere((m) => m.markerId.value == 'target');

    double distance = Geolocator.distanceBetween(
      home.position.latitude,
      home.position.longitude,
      target.position.latitude,
      target.position.longitude,
    );

    setState(() {
      _distanceResult = "Distance: ${(distance / 1000).toStringAsFixed(2)} km";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Distance Calculator")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.762622, 106.660172),
              zoom: 14,
            ),
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            onTap: _onMapTapped,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withOpacity(0.9),
              child: Text(
                _distanceResult,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
