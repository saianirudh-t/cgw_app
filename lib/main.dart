import 'package:cgw_app/time.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  _ShellState createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  bool _showControls = false;

  void _showControlsPage() => setState(() => _showControls = true);
  void _showMainPage() => setState(() => _showControls = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'CGW(46A5)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  LocalTimeText(style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey, height: 1),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(
                        width: 600,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // the white container you want preserved
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, anim) {
                                final offsetAnim = Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(anim);
                                return SlideTransition(
                                  position: offsetAnim,
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                );
                              },
                              child: _showControls
                                  ? ControlsContent(
                                      key: const ValueKey('controls'),
                                      onBack: _showMainPage,
                                    )
                                  : MainContent(
                                      key: const ValueKey('main'),
                                      onNext: _showControlsPage,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              height: 64,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 40,
                      onPressed: () async {
                        await Navigator.of(context).maybePop();
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 20),
                            SizedBox(width: 5),
                            Text("Name: CGW(46A5)"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.settings_ethernet, size: 20),
                            SizedBox(width: 5),
                            Text("IP Address:176.891.198"),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Home',
                      icon: const Icon(Icons.home),
                      iconSize: 40,
                      onPressed: _showMainPage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final running = 0;
final stop = 0;
final error = 1;
final total = running + stop + error;

class MainContent extends StatelessWidget {
  final VoidCallback onNext;
  const MainContent({required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            key: key,
            spacing: 40,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Running status', style: TextStyle(fontSize: 25)),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statusCircle('Running', Colors.green, running, total),
                  _statusCircle('Stop', Colors.orange, stop, total),
                  _statusCircle('Error', Colors.red, error, total),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 111, 111, 111),
                    ),
                    onPressed: () {},
                    child: Text("ON"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 111, 111, 111),
                    ),
                    onPressed: () {},
                    child: Text("OFF"),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Replace ElevatedButton with this:
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onNext,
          splashColor: Colors.black12,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(
                Icons.chevron_right, // ">" style arrow
                size: 30,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusCircle(String label, Color color, int count, int total) {
    final fraction = total > 0 ? count / total : 0.0;
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // background ring
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey.shade300,
                  ),
                ),
              ),
              // foreground progress
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    count == 0 ? Colors.grey : color,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              // center text
              Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class ControlsContent extends StatelessWidget {
  final VoidCallback onBack;
  const ControlsContent({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 600,
              child: Row(
                children: [
                  // Replace ElevatedButton with this:
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onBack,
                    splashColor: Colors.black12,
                    highlightColor: Colors.transparent,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _controlTile(Icons.ac_unit, 'Aircon control'),
                        _controlTile(Icons.whatshot, 'Heating control'),
                        _controlTile(Icons.settings, 'Setting'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _controlTile(IconData icon, String label) {
  return Card(
    child: InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
