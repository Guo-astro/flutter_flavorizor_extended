import 'package:flutter_flavorizr_extended/src/parser/models/flavorizr.dart';
import 'package:flutter_flavorizr_extended/src/processors/android/icons/android_generate_iclauncher_xml_processor.dart';
import 'package:flutter_flavorizr_extended/src/processors/commons/new_file_string_processor.dart';
import 'package:flutter_flavorizr_extended/src/processors/commons/queue_processor.dart';
import 'package:flutter_flavorizr_extended/src/utils/constants.dart';
import 'package:sprintf/sprintf.dart';

class AndroidAdaptiveIconXmlProcessor extends QueueProcessor {
  AndroidAdaptiveIconXmlProcessor(
    String? flavorName, {
    required Flavorizr config,
  }) : super(
          [
            NewFileStringProcessor(
              sprintf(K.androidAdaptiveIconXmlPath, [flavorName]),
              AndroidGenerateIclauncherXmlProcessor(config: config),
              config: config,
            ),
          ],
          config: config,
        );

  @override
  String toString() => 'AndroidAdaptiveIconXmlProcessor';
}
