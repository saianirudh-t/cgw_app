import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Simple model
class ControlItem {
  final String id;
  final String name;
  final String status;
  ControlItem({required this.id, required this.name, required this.status});
  factory ControlItem.fromJson(Map<String, dynamic> j) => ControlItem(
    id: j['id'] ?? '',
    name: j['name'] ?? '',
    status: j['status'] ?? '',
  );
}

// Reusable ControlsScreen — pass controlType either 'Aircon' or 'Heating'
class ControlsScreen extends StatefulWidget {
  final String controlType; // 'Aircon' or 'Heating'
  const ControlsScreen({Key? key, required this.controlType}) : super(key: key);

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> {
  late Future<List<ControlItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItemsFor(widget.controlType);
  }

  Future<List<ControlItem>> _loadItemsFor(String type) async {
    final assetPath = type.toLowerCase() == 'aircon'
        ? 'assets/aircon.json'
        : 'assets/heating.json';
    final raw = await rootBundle.loadString(assetPath);
    final decoded = json.decode(raw);
    final itemsArr = decoded['items'] as List<dynamic>? ?? [];
    return itemsArr.map((e) => ControlItem.fromJson(e)).toList();
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case 'running':
        return Icon(Icons.power, color: Colors.green);
      case 'error':
        return Icon(Icons.error, color: Colors.red);
      default:
        return Icon(Icons.pause_circle_filled, color: Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAircon = widget.controlType.toLowerCase() == 'aircon';
    return Scaffold(
      appBar: AppBar(title: Text('${widget.controlType} Control')),
      body: FutureBuilder<List<ControlItem>>(
        future: _itemsFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Failed to load ${widget.controlType} data'),
            );
          }
          final items = snap.data ?? [];
          if (items.isEmpty)
            return Center(child: Text('No ${widget.controlType} items'));

          if (isAircon) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final it = items[i];
                  return GestureDetector(
                    onTap: () => _onItemTap(it),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.ac_unit,
                            size: 28,
                            color: it.status == 'error'
                                ? Colors.red
                                : Colors.blue,
                          ),
                          SizedBox(height: 8),
                          Text(
                            it.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 6),
                          _statusSmallLabel(it.status),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            // Heating -> List
            return ListView.separated(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemBuilder: (context, i) {
                final it = items[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.deepOrange,
                    ),
                    title: Text(it.name),
                    subtitle: Text(it.id),
                    trailing: _statusIcon(it.status),
                    onTap: () => _onItemTap(it),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _statusSmallLabel(String status) {
    Color bg;
    String txt;
    switch (status) {
      case 'running':
        bg = Colors.green.shade100;
        txt = 'Running';
        break;
      case 'error':
        bg = Colors.red.shade100;
        txt = 'Error';
        break;
      default:
        bg = Colors.orange.shade100;
        txt = 'Stop';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(txt, style: TextStyle(fontSize: 10)),
    );
  }

  void _onItemTap(ControlItem it) {
    // Replace with your detail screen or command flow
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(it.name),
        content: Text('ID: ${it.id}\nStatus: ${it.status}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
