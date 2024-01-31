import 'dart:io';
import 'package:async/async.dart' show StreamGroup;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart' show AccumulatorSink;

/// comparing two files for identity by content
Future<bool> compareFilesEquality(File file1, File file2) async {

  if (file1.statSync().size != file2.statSync().size) {
    return false;
  }

  // An auxiliary function for comparing 
  // two lists for identity
  listEqual(List<int> l1, List<int> l2) {
    if (l1.length != l2.length) {
      return false;
    }

    for (int i = 0; i < l1.length; i++){
      if (l1[i] != l2[i]){
        return false;
      }
    }

    return true;
  }

  var a = false;
  List<int> buff = const[];

  await for(final val in StreamGroup.merge([file1.openRead(), file2.openRead()])) {
    if (a = !a) {
      buff = val;
      continue;
    }

    if (!listEqual(buff, val)) {
      return false;
    }
  }

  return true;
}

/// Stream the channel that transmits the original file and its duplicate
Stream<(File, File)> findDuplicates(Directory dir, [bool Function(String)? filter]) async* {
  Map<Digest, File> files = {}; 

  await for (final entitie in dir.list( recursive: true)) {
    if (entitie.statSync().type == FileSystemEntityType.file) {
      if (filter != null && !filter(entitie.path)) continue;
      final file = File(entitie.path);
      var hash = await generateHashFile(file);

      if (files[hash] != null) {
        yield (files[hash]!, file);
      } else {
        files[hash] = file;
      }      
    }
  }
}

/// Method that generates a hash code from the contents of a file
Future<Digest> generateHashFile(File file, [Hash hashMethod = sha1]) async {
    var output = AccumulatorSink<Digest>();
    var input = hashMethod.startChunkedConversion(output);

    await for(final val in file.openRead()) {
      input.add(val);
    }

    input.close();
    return output.events.single;
}