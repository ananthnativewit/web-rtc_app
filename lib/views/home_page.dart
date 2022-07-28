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
  TextEditingController chatTextEditingController =
      TextEditingController(text: '');

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
      appBar: AppBar(
        title: const Text("WebRTC App"),
        actions: [
          TextButton(
            onPressed: () async {
              await context.appViewModel
                  .openUserMedia(_localRenderer, _remoteRenderer);
              roomId = await context.appViewModel.createRoom();
              textEditingController.text = roomId!;
              setState(() {});
            },
            child: const Text(
              'Create Room',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          IconButton(
            onPressed: () {
              context.appViewModel.hangUp(_localRenderer);
            },
            icon: const Icon(Icons.call_end),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter the Room ID',
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: IconButton(
                        onPressed: () async {
                          // Add roomId
                          await context.appViewModel
                              .openUserMedia(_localRenderer, _remoteRenderer);
                          await context.appViewModel.joinRoom(
                            textEditingController.text,
                          );
                        },
                        icon: const Icon(
                          Icons.phonelink_ring_outlined,
                          color: Colors.black87,
                        ),
                      ),
                    )),
                controller: textEditingController,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _localRenderer.renderVideo
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child:
                                  RTCVideoView(_localRenderer, mirror: true)),
                          Expanded(child: RTCVideoView(_remoteRenderer)),
                        ],
                      )
                    : Center(
                        child: Column(
                          children: const <Widget>[
                            Text(
                                'Create a room and invite other with the code'),
                            Text('Or'),
                            Text('Enter the room Id and click join room'),
                          ],
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appState.messages.length,
                  itemBuilder: (context, index) {
                    if (appState.messages[index].isSystemMessage) {
                      return Text(appState.messages[index].message);
                    } else {
                      return Container(
                        padding: const EdgeInsets.all(2.0),
                        color: Colors.grey,
                        child: Text(
                            '${appState.messages[index].message} - ${appState.messages[index].sender}'),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Type here',
                        filled: true,
                        fillColor: Colors.grey[200],
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: ElevatedButton(
                          onPressed: () async {
                            // Add roomId
                            await context.appViewModel
                                .sendMessage(chatTextEditingController.text);
                          },
                          child: const Text("Send"),
                        ),
                      ),
                      controller: chatTextEditingController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
