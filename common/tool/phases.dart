import 'package:angel_serialize_generator/angel_serialize_generator.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';

final PhaseGroup PHASES = new PhaseGroup.singleAction(
    new GeneratorBuilder([new JsonModelGenerator()]),
    new InputSet('common', const ['lib/src/models/*.dart']));
