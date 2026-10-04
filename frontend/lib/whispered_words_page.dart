import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'theme.dart';

class WhisperedWordsPage extends StatefulWidget {
  const WhisperedWordsPage({super.key});

  @override
  State<WhisperedWordsPage> createState() => _WhisperedWordsPageState();
}

class _WhisperedWordsPageState extends State<WhisperedWordsPage> {
  String? _uploadedFileName;
  bool _isUploading = false;
  String? _errorMessage;
  Map<String, dynamic>? _result;

  static const String _apiBaseUrl = 'http://localhost:8000';

  Future<void> _pickAudioFile() async {
    final file = await FilePicker.pickFile(type: FileType.any);
    if (file == null) return;

    setState(() {
      _uploadedFileName = file.name;
      _isUploading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiBaseUrl/analyze'),
      );
      if (kIsWeb || file.path == null) {
        final bytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode != 200) {
        setState(() {
          _errorMessage =
              'Server error ${response.statusCode}: ${response.body}';
        });
        return;
      }

      print('Analyze response JSON: ${response.body}');

      setState(() {
        _result = jsonDecode(response.body) as Map<String, dynamic>;
      });
    } on http.ClientException catch (e) {
      setState(() {
        _errorMessage =
            'Could not connect to the server at $_apiBaseUrl. Is the backend running? ($e)';
      });
    } catch (e) {
      final message = e.toString();
      setState(() {
        _errorMessage = message.contains('SocketException') ||
                message.contains('Connection refused')
            ? 'Could not connect to the server at $_apiBaseUrl. Is the backend running? ($message)'
            : message;
      });
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GroveBackground(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Whispered Words',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Upload an audio file to transcribe.'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickAudioFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Audio'),
            ),
            const SizedBox(height: 16),
            if (_uploadedFileName != null)
              Text(
                'Selected: $_uploadedFileName',
                style: const TextStyle(color: GroveColors.forestGreen),
              ),
            if (_isUploading) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Transcribing and analyzing...'),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 24),
              Text(
                'Transcript:\n${_result!['transcript']}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${(_result!['jargon'] as List).length} jargon terms, '
                '${(_result!['quiz'] as List).length} quiz questions',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
