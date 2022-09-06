import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateExample extends StatelessWidget {
  const IsolateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 35,
          child: ElevatedButton(
            onPressed: () async {
              final receivePort = ReceivePort();
              var data =
                  await Isolate.spawn(computeHeavyTask, receivePort.sendPort);
              receivePort.listen((sum) {
                print(sum);
                data.kill();
              });
            },
            child: const Text('Isolate'),
          ),
        ),
      ],
    );
  }
}

computeHeavyTask(SendPort sendPort) {
  print('Task Started');
  int sum = 0;
  for (int i = 0; i < 10000000000; i++) {
    sum += 1;
  }
  print('Task Finished');
  sendPort.send(sum);
}
