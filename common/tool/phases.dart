import 'package:angel_serialize/builder.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/builder.dart';

final PhaseGroup PHASES = new PhaseGroup.singleAction(
    new GeneratorBuilder([new JsonModelGenerator()]),
    new InputSet('common', const ['lib/src/models/*.dart']));
