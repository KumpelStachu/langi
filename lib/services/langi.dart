import 'package:cloud_functions/cloud_functions.dart';
import 'package:langi/models/langi.dart';
import 'package:langi/models/question_level.dart';

class LangiService {
  static final _generate =
      FirebaseFunctions.instance.httpsCallable('generateLangi');

  static Future<Langi> generate({
    required String topic,
    required QuestionLevel level,
  }) async {
    final res = await _generate.call({
      'level': level.name,
      'topic': topic,
      'length': 'any',
    });

    return Langi.fromJson(res.data);
  }
}
