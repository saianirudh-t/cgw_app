import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

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

class ControlsController extends GetxController {
  // Grab variable state arguments directly from the navigation pipeline
  late final String controlType;
  late final bool isAircon;

  // Reactive state variables (.obs)
  final isLoading = true.obs;
  final hasError = false.obs;
  final useGrid = false.obs;
  final items = <ControlItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Capture payload data argument or default to 'Aircon'
    controlType = Get.arguments ?? 'Aircon';
    isAircon = controlType.toLowerCase() == 'aircon';

    // 2. Fetch resources immediately
    loadItems();
  }

  // View state switch
  void toggleView() {
    useGrid.value = !useGrid.value;
  }

  Future<void> loadItems() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final assetPath = isAircon ? 'assets/aircon.json' : 'assets/heating.json';
      final raw = await rootBundle.loadString(assetPath);
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final itemsArr = decoded['items'] as List<dynamic>? ?? [];

      items.value = itemsArr
          .map((e) => ControlItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      hasError.value = true;
      print("Error loading asset configurations: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
