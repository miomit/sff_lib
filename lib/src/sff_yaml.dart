import 'dart:io' show Directory;

import 'package:sff_lib/src/storage.dart';
import 'package:yaml/yaml.dart' show loadYaml;

class SffYaml {
  Map<String, List<Storage>> event = {};
  Map<String, List> run = {};

  SffYaml.parse(String input) {
    for (var yaml in (loadYaml(input) as Map).entries) {
      if (yaml.key == "run") {
        if (yaml.value case Map runMap) {
          if (runMap["copy"] != null) {
            run["copy"] = runMap["copy"];
          }
          if (runMap["sync"] != null) {
            run["sync"] = runMap["sync"];
          }
        }
      } else if (yaml.key == "event") {
        if (yaml.value case Map eventMap) {
          for (var e in eventMap.entries) {
            if (e.value case Map storesMap) {
              for (var store in storesMap.entries) {
                if (store.value case Map storeMap) {
                  final path = storeMap["path"] as String;
                  final permStr = storeMap["perm"] as String;

                  late Permission perm;

                  if (permStr == "read") {
                    perm = Permission.read;
                  } else if (permStr == "write") {
                    perm = Permission.write;
                  } else if (permStr == "all") {
                    perm = Permission.all;
                  }

                  var storage = Storage(
                    Directory(path),
                    perm,
                    store.key,
                  );

                  if (event[e.key] == null) {
                    event[e.key] = [storage];
                  } else {
                    event[e.key]!.add(storage);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  String toString() {
    String yamlRes = "";

    if (run.isNotEmpty) {
      yamlRes += "run:\n";
      for (var r in run.entries) {
        yamlRes += "\t${r.key}: ${r.value}\n";
      }
    }
    if (event.isNotEmpty) {
      yamlRes += "event:\n";
      for (var e in event.entries) {
        yamlRes += "\t${e.key}:\n";
        for (var store in e.value) {
          yamlRes += "\t\t${store.name}:\n";
          yamlRes += "\t\t\tpath: ${store.getPath()}\n";
          yamlRes += "\t\t\tperm: ${store.getPerm().name}\n";
        }
      }
    }

    return yamlRes;
  }
}
