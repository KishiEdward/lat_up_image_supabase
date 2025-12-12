import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final supabase = Supabase.instance.client;

  String? _publicImageUrl;
  bool _isUploading = false;

  Future<void> _pickAndUploadToPublicBucket() async {
    final picker = ImagePicker();

    // memilih gambar
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }
    setState(() {
      _isUploading = true;
    });

    try {
      // membuat nama file unik
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final filePath = 'uploads/$fileName';

      if (kIsWeb) {
        // untuk web
        final bytes = await picked.readAsBytes();
        await supabase.storage
            .from('bucket_images')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpg'),
            );
      } else {
        // untuk mobile
        final file = File(picked.path);
        await supabase.storage.from('bucket_images').upload(filePath, file);
      }

      // ambil URL publik
      final publicUrl = supabase.storage
          .from('bucket_images')
          .getPublicUrl(filePath);
      setState(() {
        _publicImageUrl = publicUrl;
      });
    } catch (e) {
      debugPrint('Error upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Image Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // menampilkan progress indicator jika sedang upload
            if (_isUploading) const LinearProgressIndicator(),

            const SizedBox(height: 16),

            // button untuk pilih image
            ElevatedButton(
              onPressed: _isUploading ? null : _pickAndUploadToPublicBucket,
              child: const Text('Pilih & Upload Gambar'),
            ),

            const SizedBox(height: 24),

            // menampilkan Image yang kita upload
            // kika _publicImageUrl tidak null, maka tampilkan list widget di bawah ini
            if (_publicImageUrl != null) ...[
              const Text('Gambar dari Public URL:'),
              const SizedBox(height: 8),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Image.network(_publicImageUrl!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
