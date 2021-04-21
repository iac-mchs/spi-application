import 'package:fire_notifications_new/app/components/map_zoom_buttons.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart' as C;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final C.Notification _notification;

  MapView(this._notification);

  Color get color {
    switch (_notification.type) {
      case 'warn':
        return Color(0xFFFFC600);
      case 'error':
        return Color(0xFFE13131);
      default:
        return Color(0xFF6DD400);
    }
  }

  IconData get icon {
    switch (_notification.type) {
      case 'error':
        return Icons.local_fire_department_sharp;
      case 'warn':
        return Icons.warning_amber_outlined;
      default:
        return Icons.check;
    }
  }

  Marker get marker {
    return new Marker(
      width: 160.0,
      height: 160.0,
      point: new LatLng(_notification.object.lat, _notification.object.lon),
      builder: (context) {
        return Container(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    border: Border.all(color: color),
                    shape: BoxShape.circle
                ),
                child: SizedBox(width: 160, height: 160),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    border: Border.all(color: color),
                    shape: BoxShape.circle
                ),
                child: SizedBox(width: 80, height: 80),
              ),
              Icon(icon, color: color, size: 40.0)
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(_notification.object.lat, _notification.object.lon),
        zoom: 18,
        maxZoom: 18,
        plugins: [
          MapZoomButtonsPlugin(),
        ]
      ),
      layers: [
        MapZoomButtonsOptions(
          key: Key('zoom-btn'),
          minZoom: 4,
          maxZoom: 16,
          mini: true,
          padding: 10,
          alignment: Alignment.centerLeft,
        ),
        new MarkerLayerOptions(
          markers: [
            marker,
          ],
        ),
      ],
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
      ],
    );
  }
}