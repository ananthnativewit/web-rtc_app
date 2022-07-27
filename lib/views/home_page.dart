import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rtc_app/provider/provider_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AppProviderMixin<HomePage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    appViewModel.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.appViewModel.sendMessage('Hello');
      //   },
      //   child: Text('Send'),
      // ),
      appBar: AppBar(
        title: const Text("WebRTC App"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await context.appViewModel
                      .openUserMedia(_localRenderer, _remoteRenderer);
                  roomId =
                      await context.appViewModel.createRoom(_remoteRenderer);
                  textEditingController.text = roomId!;
                  setState(() {});
                },
                child: const Text("Create room"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.appViewModel.hangUp(_localRenderer);
                },
                child: const Text("Hangup"),
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _localRenderer.renderVideo
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: RTCVideoView(_localRenderer, mirror: true)),
                        Expanded(child: RTCVideoView(_remoteRenderer)),
                      ],
                    )
                  : const Center(
                      child: Text(
                          'Create a room and share the code with other and request them to join \n or enter the room Id and click join room'),
                    ),
            ),
          ),
          // Expanded(
          //   child: Container(
          //     color: Colors.red,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: appState.messages.length,
          //         itemBuilder: (context, index) {
          //           if (appState.messages[index].isSystemMessage) {
          //             return Text(appState.messages[index].message);
          //           } else {
          //             return Container(
          //               padding: const EdgeInsets.all(2.0),
          //               color: Colors.grey,
          //               child: Text(appState.messages[index].message),
          //             );
          //           }
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Enter the room Id'),
                    controller: textEditingController,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add roomId
                      await context.appViewModel
                          .openUserMedia(_localRenderer, _remoteRenderer);
                      await context.appViewModel.joinRoom(
                        textEditingController.text,
                        _remoteRenderer,
                      );
                    },
                    child: const Text("Join room"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
