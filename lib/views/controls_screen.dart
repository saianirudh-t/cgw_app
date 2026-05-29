import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/AirconHeating.dart';

class ControlsScreen extends StatelessWidget {
  const ControlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and locate controller initialization loop
    // Grab the argument string first
    final String currentArgument = Get.arguments ?? 'Aircon';

    // Use the argument string as a unique identifier tag!
    final controller = Get.put(ControlsController(), tag: currentArgument);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(), // GetX back route transition
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          '${controller.controlType} Control',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA10E3A),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Obx(
              () => IconButton(
                tooltip: controller.useGrid.value ? 'Show list' : 'Show grid',
                icon: Icon(
                  controller.useGrid.value ? Icons.view_list : Icons.grid_view,
                ),
                color: Colors.white,
                onPressed: () => controller.toggleView(),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Text('Failed to load ${controller.controlType} data'),
          );
        }

        if (controller.items.isEmpty) {
          return Center(child: Text('No ${controller.controlType} items'));
        }

        return controller.useGrid.value
            ? _buildGridView(controller)
            : _buildListView(controller);
      }),
    );
  }

  // --- UI Layout Partials ---

  Widget _buildGridView(ControlsController controller) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.isAircon ? 3 : 2,
          childAspectRatio: controller.isAircon ? 0.9 : 1.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: controller.items.length,
        itemBuilder: (context, i) {
          final it = controller.items[i];
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isAircon
                        ? Icons.ac_unit
                        : Icons.local_fire_department,
                    size: 28,
                    color: it.status == 'error'
                        ? Colors.red
                        : (controller.isAircon
                              ? Colors.blue
                              : Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    it.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  _statusSmallLabel(it.status),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(ControlsController controller) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: controller.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final it = controller.items[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: controller.isAircon
                  ? Colors.blue
                  : Colors.deepOrange,
              child: Icon(
                controller.isAircon
                    ? Icons.ac_unit
                    : Icons.local_fire_department,
                color: Colors.white,
              ),
            ),
            title: Text(it.name),
            subtitle: Text(it.id),
            trailing: _statusIcon(it.status),
          ),
        );
      },
    );
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case 'running':
        return const Icon(Icons.bolt, color: Colors.green);
      case 'error':
        return const Icon(Icons.warning_amber_rounded, color: Colors.red);
      default:
        return const Icon(Icons.hourglass_top, color: Colors.orange);
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(txt, style: const TextStyle(fontSize: 10)),
    );
  }
}
