import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/device_details.dart';

class DeviceConfigResult {
  final String deviceName;
  final String ip;
  final bool configured;
  DeviceConfigResult({
    required this.deviceName,
    required this.ip,
    this.configured = true,
  });
}

class LoginCard extends StatefulWidget {
  final Future<void> Function(DeviceConfigResult result)? onConnect;
  final String initialName;
  final String initialIp;

  const LoginCard({
    super.key,
    this.onConnect,
    this.initialName = '',
    this.initialIp = '',
  });

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final UserControllers deviceDetails = Get.find<UserControllers>();
  late TextEditingController _nameC;
  late TextEditingController _ipC;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.initialName);
    _ipC = TextEditingController(text: widget.initialIp);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _ipC.dispose();
    super.dispose();
  }

  Future<void> _onConnectPressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = DeviceConfigResult(
      deviceName: _nameC.text.trim(),
      ip: _ipC.text.trim(),
    );

    // update Getx controller
    final deviceCtrl = Get.find<UserControllers>();
    deviceCtrl.deviceDetails(result.deviceName, result.ip);

    // return result to the caller and close dialog
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.86,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  focusNode: _focusNode1,
                  controller: _nameC,
                  decoration: InputDecoration(
                    labelText: 'Device Name',
                    hintText: "CGW0954",
                    prefixIcon: Icon(Icons.devices_outlined),
                    labelStyle: TextStyle(
                      color: _focusNode1.hasFocus
                          ? Color(0xFFA10E3A)
                          : Colors.grey,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: _focusNode1.hasFocus
                          ? Color(0xFFA10E3A)
                          : Colors.white,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA10E3A),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // IP address field
                TextFormField(
                  focusNode: _focusNode2,
                  controller: _ipC,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.settings_ethernet),
                    labelText: 'IP Address',
                    hintText: '000.000.000.000',
                    labelStyle: TextStyle(
                      color: _focusNode2.hasFocus
                          ? Color(0xFFA10E3A)
                          : Colors.grey,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: _focusNode2.hasFocus
                          ? Color(0xFFA10E3A)
                          : Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA10E3A),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14), // Connect button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _onConnectPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA10E3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('CONNECT'),
                  ),
                ),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
