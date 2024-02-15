/*
 * Copyright (c) 2023 Angelo Cassano
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_flavorizr_extended/src/parser/models/flavorizr.dart';
import 'package:flutter_flavorizr_extended/src/parser/parser.dart';
import 'package:flutter_flavorizr_extended/src/processors/processor.dart';

/// A common entry point to parse command line arguments and execute the process
///
/// Returns the exit code that should be set when the calling process exits. `0`
/// implies success.
void execute(List<String> args) {
  ArgParser argParser = ArgParser();
  argParser.addMultiOption('processors',
      abbr: 'p', allowed: Processor.defaultInstructionSet, splitCommas: true);
  argParser.addOption('runType', abbr: 'r'); // Added this line
  ArgResults results = argParser.parse(args);
  List<String> argProcessors = results['processors'];
  String? argRunType = results['runType']; // Added this line

  Parser parser = Parser(
    pubspecPath: 'pubspec.yaml',
    flavorizrPath: 'flavorizr.yaml',
  );

  Flavorizr? flavorizr;
  try {
    flavorizr = parser.parse();
  } catch (e) {
    stderr.writeln(e);
    exit(65);
  }
  if (argRunType == 'updateRun') {
    flavorizr.instructions = Processor.updateInstructionSet;
  }
  if (argRunType == 'initializationRun' && argProcessors.isNotEmpty) {
    flavorizr.instructions = argProcessors;
  }

  Processor processor = Processor(flavorizr);
  processor.execute();
}
