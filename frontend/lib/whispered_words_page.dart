import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

class WhisperedWordsPage extends StatefulWidget {
  const WhisperedWordsPage({super.key});

  @override
  State<WhisperedWordsPage> createState() => _WhisperedWordsPageState();
}

class _WhisperedWordsPageState extends State<WhisperedWordsPage> {
  String? _uploadedFileName;

  Future<void> _pickAudioFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac', 'wma'],
    );
    if (file != null) {
      setState(() {
        _uploadedFileName = file.name;
      });
      // TODO: Send the file to Azure Speech service for transcription.
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
          ],
        ),
      ),
    );
  }
}
