import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipfs_rpc/ipfs_rpc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({Key? key}) : super(key: key);

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  // Instantiate IPFS
  final ipfs = IPFS();

  // Result TextEditingController
  final resultAreaController = TextEditingController();

  // Generic API call function
  void call(Future function) async {
    debugPrint('requesting...');
    resultAreaController.text = 'requesting...';

    final result = await function;

    result.fold(
          (error) {
        final text = error is String ? error : error.toJson().toString();
        resultAreaController.text = text;
        debugPrint(text);
      },
          (response) {
        final text =
        response is String ? response : response.toJson().toString();
        resultAreaController.text = text;
        debugPrint(text);
      },
    );

    debugPrint('request done');
  }

  @override
  void initState() {
    ipfs.client.init(
      scheme: 'http',
      host: 'ipfs.infura.io',
      port: 5001,
      verbose: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IPFS RPC Playground",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: resultAreaController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Result Area',
              enabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(ipfs.client.baseUrl),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/chcid'),
                onPressed: () => call(ipfs.files.chcid()),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/cp'),
                onPressed: () => call(
                  ipfs.files.cp(
                    source: '/server.txt',
                    destination: '/New Directory/server.txt',
                  ),
                ),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/flush'),
                onPressed: () => call(ipfs.files.flush()),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/ls'),
                onPressed: () => call(ipfs.files.ls()),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/mkdir'),
                onPressed: () => call(
                  ipfs.files.mkdir(arg: '/New Directory'),
                ),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/mv'),
                onPressed: () => call(ipfs.files.mv(
                  source: '/server.txt',
                  destination: '/moved_server.txt',
                )),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/read'),
                onPressed: () => call(
                  ipfs.files.read(arg: '/server.txt'),
                ),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/rm'),
                onPressed: () => call(ipfs.files.rm(
                  arg: '/server.txt',
                  recursive: true,
                )),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/stat'),
                onPressed: () => call(
                  ipfs.files.stat(arg: '/server.txt'),
                ),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('files/write'),
                onPressed: () async {
                  final directory = await getApplicationDocumentsDirectory();

                  // temporarily create & write a local file for upload demo
                  final file =
                  await File('${directory.path}/local.txt').writeAsString(
                    'this is a sample file written locally to be uploaded to IPFS! Updated',
                  );

                  call(
                    ipfs.files.write(
                      arg: '/server.txt', // ipfs path to write to
                      fileName: basename(file.path),
                      filePath: file.path,
                      create: true, // create if it doesn't exist
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
