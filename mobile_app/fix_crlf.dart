import 'dart:io';

void main() {
  // Fix android/gradlew
  fixFile('android/gradlew');
  print('Fixed android/gradlew');
}

void fixFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    print('File not found: $path');
    return;
  }
  
  final content = file.readAsBytesSync();
  final newContent = <int>[];
  
  for (int i = 0; i < content.length; i++) {
    // 13 is CR, 10 is LF
    if (content[i] == 13 && i + 1 < content.length && content[i+1] == 10) {
      continue; // Skip CR if followed by LF
    }
    newContent.add(content[i]);
  }
  
  file.writeAsBytesSync(newContent);
}
