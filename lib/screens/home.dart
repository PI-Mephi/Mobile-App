import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencv_dart/opencv.dart';
import 'package:opencv_dart/opencv_dart.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

RecognizedImage recognizedImage = RecognizedImage();

class _HomeScreenState extends State<HomeScreen> {

  Timer? _timer;
  Timer? _recognizeTimer;

  String? qrCode;

  @override
  void initState() {
    super.initState();
    // sendData();
    connectServer();
    _recognizeTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      recognizeImage();
    });
  }

  int current = 0;

  RawDatagramSocket? _udpSocket;
  InternetAddress _espAddress = InternetAddress('192.168.4.1');
  int _espPort = 8888;


  void connectServer() async {
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    } catch (e) {
      print("Ошибка инициализации UDP: $e");
    }
  }

  String lastRecognized = "";

  void recognizeImage() async {
    List<int>? chunks = recognizedImage.chunks;
    if (chunks == null || chunks.isEmpty) return;
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/image.jpeg');
    await file.writeAsBytes(chunks);
    Mat src = imread(file.path);
    Mat gray = src;
    cvtColor(gray, COLOR_BGRA2GRAY);
    ArucoDictionary dictionary = ArucoDictionary.predefined(PredefinedDictionaryType.DICT_4X4_1000);
    ArucoDetectorParameters parameters = ArucoDetectorParameters.empty();
    ArucoDetector arucoDetector = ArucoDetector.create(dictionary, parameters);
    final result = await arucoDetector.detectMarkersAsync(gray);
    print(result.$2);
    VecI32 recognized = result.$2;
    setState(() {
      if (recognized.data.length > 0) {
        lastRecognized = recognized.data.first.toString();
      }
    });
  }

  void sendData(int number) async {
    try {
      var data = Uint8List.fromList([number]);
      _udpSocket!.send(data, _espAddress, _espPort);
    } catch (e) {
      // print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: MediaQuery.of(context).orientation == Orientation.portrait ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.5,
              width: width,
              child: Center(
                  child: Mjpeg(
                    stream: "http://192.168.4.2:81/stream",
                    isLive: true,
                    width: width,
                    height: height * 0.5,
                    fit: BoxFit.cover,
                    preprocessor: MjpegPreprocessor(),
                  )
              ),
            ),
            Container(
              height: height * 0.2,
              child: Center(
                child: Text(lastRecognized, style: GoogleFonts.roboto(fontSize: width * 0.04, fontWeight: FontWeight.w500),),
              ),
            ),
            GestureDetector(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_up, size: width * 0.15, color: Colors.white,),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: BeveledRectangleBorder(),
                ),
              ),
              onTapDown: (_) {
                sendData(4);
              },
              onTapCancel: () {
                sendData(0);
              },
              onTapUp: (_) {
                sendData(0);
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_left, size: width * 0.15, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: BeveledRectangleBorder(),
                    ),
                  ),
                  onTapDown: (_) {
                    sendData(3);
                  },
                  onTapCancel: () {
                    sendData(0);
                  },
                  onTapUp: (_) {
                    sendData(0);
                  },
                ),
                SizedBox(
                  width: width * 0.2,
                ),
                GestureDetector(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_right, size: width * 0.15, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: BeveledRectangleBorder(),
                    ),
                  ),
                  onTapDown: (_) {
                    sendData(2);
                  },
                  onTapCancel: () {
                    sendData(0);
                  },
                  onTapUp: (_) {
                    sendData(0);
                  },
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            GestureDetector(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_down, size: width * 0.15, color: Colors.white,),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: BeveledRectangleBorder(),
                ),
              ),
              onTapDown: (_) {
                sendData(1);
              },
              onTapCancel: () {
                sendData(0);
              },
              onTapUp: (_) {
                sendData(0);
              },
            ),
          ],
        ) : Column(
          children: [
            Row(
              children: [
                Container(
                  width: width * 0.15,
                  color: Colors.grey.withOpacity(0.2),
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_drop_up, size: width * 0.1, color: Colors.white,),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: BeveledRectangleBorder(),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_drop_down, size: width * 0.1, color: Colors.white,),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: BeveledRectangleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.7,
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.7,
                        height: height * 0.8,
                        color: Colors.black,
                        child: Center(
                            child: Mjpeg(
                              stream: "http://192.168.4.3:81/stream",
                              isLive: true,
                              width: width * 0.7,
                              height: height * 0.8,
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      Container(
                        child: Text(lastRecognized),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 0.15,
                  color: Colors.grey.withOpacity(0.2),
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_drop_up, size: width * 0.1, color: Colors.white,),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: BeveledRectangleBorder(),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_drop_down, size: width * 0.1, color: Colors.white,),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: BeveledRectangleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}


class _MjpegStateNotifier extends ChangeNotifier {
  bool _mounted = true;
  bool _visible = true;

  _MjpegStateNotifier() : super();

  bool get mounted => _mounted;

  bool get visible => _visible;

  set visible(value) {
    _visible = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    notifyListeners();
    super.dispose();
  }
}

/// A preprocessor for each JPEG frame from an MJPEG stream.
class MjpegPreprocessor {
  List<int>? process(List<int> frame) => frame;
}

/// An Mjpeg.
class Mjpeg extends HookWidget {
  final String stream;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool isLive;
  final Duration timeout;
  final WidgetBuilder? loading;
  final Client? httpClient;
  final Widget Function(BuildContext contet, dynamic error, dynamic stack)?
  error;
  final Map<String, String> headers;
  final MjpegPreprocessor? preprocessor;

  const Mjpeg({
    this.httpClient,
    this.isLive = false,
    this.width,
    this.timeout = const Duration(seconds: 5),
    this.height,
    this.fit,
    required this.stream,
    this.error,
    this.loading,
    this.headers = const {},
    this.preprocessor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = useState<MemoryImage?>(null);
    final state = useMemoized(() => _MjpegStateNotifier());
    final visible = useListenable(state);
    final errorState = useState<List<dynamic>?>(null);
    final isMounted = useIsMounted();
    final manager = useMemoized(
            () => _StreamManager(
          stream,
          isLive && visible.visible,
          headers,
          timeout,
          httpClient ?? Client(),
          preprocessor ?? MjpegPreprocessor(),
          isMounted,
        ),
        [
          stream,
          isLive,
          visible.visible,
          timeout,
          httpClient,
          preprocessor,
          isMounted
        ]);
    final key = useMemoized(() => UniqueKey(), [manager]);

    useEffect(() {
      errorState.value = null;
      manager.updateStream(context, image, errorState);
      return manager.dispose;
    }, [manager]);

    if (errorState.value != null) {
      return SizedBox(
        width: width,
        height: height,
        child: error == null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${errorState.value}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
            : error!(context, errorState.value!.first, errorState.value!.last),
      );
    }

    if (image.value == null) {
      return SizedBox(
          width: width,
          height: height,
          child: loading == null
              ? Center(child: CircularProgressIndicator())
              : loading!(context));
    }
    return VisibilityDetector(
      key: key,
      child: Image(
        image: image.value!,
        width: width,
        height: height,
        gaplessPlayback: true,
        fit: fit,
      ),
      onVisibilityChanged: (VisibilityInfo info) {
        if (visible.mounted) {
          visible.visible = info.visibleFraction != 0;
        }
      },
    );
  }
}

class _StreamManager {
  static const _trigger = 0xFF;
  static const _soi = 0xD8;
  static const _eoi = 0xD9;

  final String stream;
  final bool isLive;
  final Duration _timeout;
  final Map<String, String> headers;
  final Client _httpClient;
  final MjpegPreprocessor _preprocessor;
  final bool Function() _mounted;
  // ignore: cancel_subscriptions
  StreamSubscription? _subscription;

  _StreamManager(this.stream, this.isLive, this.headers, this._timeout,
      this._httpClient, this._preprocessor, this._mounted);

  Future<void> dispose() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
    _httpClient.close();
  }

  void _sendImage(BuildContext context, ValueNotifier<MemoryImage?> image,
      ValueNotifier<dynamic> errorState, List<int> chunks) async {
    // pass image through preprocessor sending to [Image] for rendering
    final List<int>? imageData = _preprocessor.process(chunks);
    if (imageData == null) return;
    final imageMemory = MemoryImage(Uint8List.fromList(imageData));
    if (_mounted()) {
      errorState.value = null;
      image.value = imageMemory;
      recognizedImage.chunks = chunks;
    }
  }

  void updateStream(BuildContext context, ValueNotifier<MemoryImage?> image,
      ValueNotifier<List<dynamic>?> errorState) async {
    try {
      final request = Request("GET", Uri.parse(stream));
      request.headers.addAll(headers);
      final response = await _httpClient.send(request).timeout(
          _timeout); //timeout is to prevent process to hang forever in some case
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var _carry = <int>[];
        _subscription = response.stream.listen((chunk) async {
          if (_carry.isNotEmpty && _carry.last == _trigger) {
            if (chunk.first == _eoi) {
              _carry.add(chunk.first);
              _sendImage(context, image, errorState, _carry);
              _carry = [];
              if (!isLive) {
                dispose();
              }
            }
          }

          for (var i = 0; i < chunk.length - 1; i++) {
            final d = chunk[i];
            final d1 = chunk[i + 1];

            if (d == _trigger && d1 == _soi) {
              _carry = [];
              _carry.add(d);
            } else if (d == _trigger && d1 == _eoi && _carry.isNotEmpty) {
              _carry.add(d);
              _carry.add(d1);
              _sendImage(context, image, errorState, _carry);
              _carry = [];
              if (!isLive) {
                dispose();
              }
            } else if (_carry.isNotEmpty) {
              _carry.add(d);
              if (i == chunk.length - 2) {
                _carry.add(d1);
              }
            }
          }
        }, onError: (error, stack) {
          try {
            if (_mounted()) {
              errorState.value = [error, stack];
              image.value = null;
            }
          } catch (ex) {}
          dispose();
        }, cancelOnError: true);
      } else {
        if (_mounted()) {
          errorState.value = [
            HttpException('Stream returned ${response.statusCode} status'),
            StackTrace.current
          ];
          image.value = null;
        }
        dispose();
      }
    } catch (error, stack) {
      // we ignore those errors in case play/pause is triggers
      if (!error
          .toString()
          .contains('Connection closed before full header was received')) {
        if (_mounted()) {
          errorState.value = [error, stack];
          image.value = null;
        }
      }
    }
  }
}


class RecognizedImage {
  List<int>? chunks;
}