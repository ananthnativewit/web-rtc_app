import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rtc_app/core/view_model.dart';
import 'package:rtc_app/models/app_state.dart';
import 'package:rtc_app/provider/app_state_notifier.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import '../models/message.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class AppProvider extends StatelessWidget {
  const AppProvider({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<AppViewModel, AppState>(
      create: (_) => AppViewModel()..init(),
      child: child,
    );
  }
}

class AppViewModel extends AppStateNotifier<AppState>
    implements AppBaseViewModel {
  AppViewModel() : super(AppState());

  final Completer<void> _completer = Completer();

  @override
  Future<void> init() async {
    if (state.isInitializing || _completer.isCompleted) {
      return _completer.future;
    }
    await _init();
    await _completer.future;
  }

  Future<void> _init() async {
    try {
      setInitializing(true);
    } catch (e) {
      _completer.completeError(e);
    } finally {
      if (kDebugMode) {
        print('AppViewModel initialized');
      }
      setInitializing(false);
      _completer.complete();
    }
  }

  setInitializing(bool value) {
    state = state.rebuild((AppStateBuilder p0) => p0.isInitializing = value);
  }

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': "stun:openrelay.metered.ca:80",
      },
      {
        'urls': "turn:openrelay.metered.ca:80",
        'username': "openrelayproject",
        'credential': "openrelayproject",
      },
      {
        'urls': "turn:openrelay.metered.ca:443",
        'username': "openrelayproject",
        'credential': "openrelayproject",
      },
      {
        'urls': "turn:openrelay.metered.ca:443?transport=tcp",
        'username': "openrelayproject",
        'credential': "openrelayproject",
      },
    ],
  };

  RTCPeerConnection? rtcPeerConnection;
  RTCDataChannel? rtcDataChannel;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc();

    rtcPeerConnection = await createPeerConnection(configuration);

    await _createDataChannel();

    registerPeerConnectionListeners();

    _localStream?.getTracks().forEach((track) {
      rtcPeerConnection?.addTrack(track, _localStream!);
    });

    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    rtcPeerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      callerCandidatesCollection.add(candidate.toMap());
      state.messages.rebuild(
          (p0) => p0.add(Message.fromSystem("ICE candidate obtained")));
    };

    rtcPeerConnection?.onDataChannel = (channel) {
      state.messages.rebuild(
          (p0) => p0.add(Message.fromSystem("Received data channel")));
      _addDataChannel(channel);
    };

    RTCSessionDescription offer = await rtcPeerConnection!.createOffer();
    await rtcPeerConnection!.setLocalDescription(offer);
    state.messages
        .rebuild((p0) => p0.add(Message.fromSystem("Created offer")));

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;

    currentRoomText = 'Current room is $roomId - You are the caller!';

    rtcPeerConnection?.onTrack = (RTCTrackEvent event) {
      event.streams[0].getTracks().forEach((track) {
        _remoteStream?.addTrack(track);
      });
    };

    roomRef.snapshots().listen((snapshot) async {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (rtcPeerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        await rtcPeerConnection?.setRemoteDescription(answer);
      }
    });

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

          rtcPeerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });

    return roomId;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc(roomId);
    var roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      rtcPeerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      _localStream?.getTracks().forEach((track) {
        rtcPeerConnection?.addTrack(track, _localStream!);
      });

      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      rtcPeerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        calleeCandidatesCollection.add(candidate.toMap());
      };

      rtcPeerConnection?.onTrack = (RTCTrackEvent event) {
        event.streams[0].getTracks().forEach((track) {
          _remoteStream?.addTrack(track);
        });
      };

      var data = roomSnapshot.data() as Map<String, dynamic>;

      var offer = data['offer'];
      await rtcPeerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );

      var answer = await rtcPeerConnection!.createAnswer();

      await rtcPeerConnection!.setLocalDescription(answer);

      state.messages
          .rebuild((p0) => p0.add(Message.fromSystem("Answer Accepted")));

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);

      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          rtcPeerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    }
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localVideo.srcObject = stream;
    _localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (_remoteStream != null) {
      _remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (rtcPeerConnection != null) rtcPeerConnection!.close();

    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      for (var document in calleeCandidates.docs) {
        document.reference.delete();
      }

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      for (var document in callerCandidates.docs) {
        document.reference.delete();
      }

      await roomRef.delete();
    }

    _localStream!.dispose();
    _remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    rtcPeerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      _remoteStream = stream;
    };
  }

  Future<void> _createDataChannel() async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    RTCDataChannel? channel = await rtcPeerConnection?.createDataChannel(
        "textchat-chan", dataChannelDict);

    state.messages.rebuild((p0) => p0.add(Message.fromSystem("Created data channel")));

    _addDataChannel(channel!);
  }

  void _addDataChannel(RTCDataChannel channel) {
    rtcDataChannel = channel;
    rtcDataChannel?.onMessage = (data) {
      state.messages
          .rebuild((p0) => p0.add(Message.fromUser("OTHER", data.text)));
    };
    rtcDataChannel?.onDataChannelState = (s) {
      state.messages.rebuild(
          (p0) => p0.add(Message.fromSystem("Data channel state: $s")));
    };
  }

  Future<void> sendMessage(String message) async {
    await rtcDataChannel?.send(RTCDataChannelMessage(message));

    state.messages.rebuild((p0) => p0.add(Message.fromUser("ME", message)));

    print('mess:$message');
  }
}
