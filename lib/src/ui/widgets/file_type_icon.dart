import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// Renders a distinctive icon and color for files and directories based on type and extension.
class FileTypeIcon extends StatelessWidget {
  final String fileName;
  final bool isDir;
  final double size;

  const FileTypeIcon({
    super.key,
    required this.fileName,
    required this.isDir,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (isDir) {
      return Icon(
        Icons.folder_rounded,
        size: size,
        color: Colors.amber.shade600,
      );
    }

    final ext = p.extension(fileName).toLowerCase().replaceAll('.', '');

    switch (ext) {
      // Images
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'svg':
      case 'bmp':
        return Icon(Icons.image_outlined, size: size, color: Colors.teal);

      // Videos
      case 'mp4':
      case 'mkv':
      case 'mov':
      case 'avi':
      case 'webm':
        return Icon(Icons.movie_outlined, size: size, color: Colors.purple.shade300);

      // Audio
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
      case 'ogg':
      case 'm4a':
        return Icon(Icons.audiotrack_outlined, size: size, color: Colors.pink.shade300);

      // PDF
      case 'pdf':
        return Icon(Icons.picture_as_pdf_outlined, size: size, color: Colors.red.shade400);

      // Documents
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
      case 'odt':
      case 'md':
        return Icon(Icons.article_outlined, size: size, color: Colors.blue.shade400);

      // Spreadsheets & Data
      case 'xls':
      case 'xlsx':
      case 'csv':
      case 'tsv':
        return Icon(Icons.table_chart_outlined, size: size, color: Colors.green.shade500);

      // Presentations
      case 'ppt':
      case 'pptx':
      case 'key':
        return Icon(Icons.slideshow_outlined, size: size, color: Colors.orange.shade400);

      // Archives
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
      case 'bz2':
        return Icon(Icons.folder_zip_outlined, size: size, color: Colors.deepOrange.shade300);

      // Code & Developer
      case 'dart':
      case 'go':
      case 'py':
      case 'js':
      case 'ts':
      case 'json':
      case 'yaml':
      case 'yml':
      case 'html':
      case 'css':
      case 'c':
      case 'cpp':
      case 'h':
      case 'sh':
        return Icon(Icons.code_outlined, size: size, color: Colors.cyan.shade400);

      default:
        return Icon(
          Icons.insert_drive_file_outlined,
          size: size,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }
}
