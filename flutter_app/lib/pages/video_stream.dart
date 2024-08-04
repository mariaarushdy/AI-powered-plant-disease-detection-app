import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({super.key});

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  final TextEditingController _urlController = TextEditingController(
    text: 'http://192.168.1.242:8080/stream_viewer?topic=/webcam/image_raw',
  );
  bool _isConnected = false;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if needed
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('HTTP error: $error'),
              ),
            );
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Web resource error: ${error.description}'),
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void connect() {
    if (_urlController.text.isNotEmpty) {
      _webViewController.loadRequest(Uri.parse(_urlController.text));
      setState(() {
        _isConnected = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid URL'),
        ),
      );
    }
  }

  void disconnect() {
    setState(() {
      _isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(245, 218, 216, 203),
        title: const Text("Live Video"),
      ),
      backgroundColor:const Color.fromARGB(245, 226, 223, 210),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Web URL',
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: connect,
                    style: ElevatedButton.styleFrom(fixedSize: const Size(120.0, 10.0),backgroundColor: const Color.fromARGB(255, 88, 170, 106), // Set background color
                ),
                    child: const Text("Connect",
                    style: TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                           fontWeight: FontWeight.normal,),
                           ),
                  ),
                  ElevatedButton(
                    onPressed: disconnect,
                    style: ElevatedButton.styleFrom(fixedSize: const Size(120.0, 10.0),backgroundColor: const Color.fromARGB(255, 88, 170, 106)),
                    child: const Text("Disconnect",
                    style: TextStyle(
                           color: Colors.white,
                           fontSize: 14,
                           fontWeight: FontWeight.normal,), // Set text color to white
                    
                  ),
                    ),
                ],
              ),
              const SizedBox(height: 50.0),
              _isConnected
                  ? Expanded(
                      child: WebViewWidget(controller: _webViewController),
                    )
                  : const Text("Initiate Connection"),
            ],
          ),
        ),
      ),
    );
  }
}