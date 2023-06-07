import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';


class PdfPreviewScreen extends StatefulWidget {
  final String path;
  const PdfPreviewScreen({Key? key, required this.path, }) : super(key: key);

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'PDF Document',
        ),
        actions: [
          IconButton(
              onPressed: () async{
                Share.shareFiles([widget.path], text: 'Sharing PDF');
              },
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 27,
              )
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child:   PDFView(
          filePath: widget.path,
          enableSwipe: false,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation:
          false, // if set to true the link is handled in flutter
          onRender: (_pages) {
          },
          onError: (error) {
            setState(() {
              // errorMessage = error.toString();
            });
            print(error.toString());
          },
          onPageError: (page, error) {
            setState(() {
              // errorMessage = '$page: ${error.toString()}';
            });
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            // _controller.complete(pdfViewController);
          },
          onLinkHandler: (String? uri) {
            print('goto uri: $uri');
          },
          onPageChanged: (int? page, int? total) {
            print('page change: $page/$total');
            setState(() {
              // currentPage = page;
            });
          },
        ),
      ),
    );
  }
}
