import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naam_jhap_website/models/chant_models.dart';
import 'package:naam_jhap_website/services/chant_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ChantStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = ChantStore();
    await store.load();
  });

  tearDown(() async {
    await store.flush();
    store.dispose();
  });

  test('starts on Gan Ganapataye Namah with one shared 11k target', () {
    expect(store.active.name, 'Gan Ganapataye Namah');
    expect(store.target, defaultMantraTarget);
    expect(store.sessionChants, 0);
    expect(store.active.malasCompleted, 0);

    store.setTarget(80000000);
    store.selectMantra('ram-naam');
    expect(store.target, 80000000);
  });

  test('each tap counts a chant and 108 chants complete a mala', () async {
    store.chant();
    expect(store.sessionChants, 1);
    expect(store.active.totalChants, 1);
    expect(store.sessionStartedAt, isNotNull);

    for (var i = 0; i < 107; i++) {
      store.chant();
    }
    expect(store.sessionChants, 108);
    expect(store.active.malasCompleted, 1);
    expect(store.active.totalChants, 108);

    await store.finishSession();
    expect(store.sessionChants, 0);
    expect(formatElapsed(store.elapsed), '00:00');
    expect(store.history, hasLength(1));
    expect(store.history.single.chants, 108);
    expect(store.active.totalChants, 108);
  });

  test('a finished session is still there after reload', () async {
    store.chant();
    store.chant();
    await store.finishSession();

    final reloaded = ChantStore();
    await reloaded.load();
    expect(reloaded.active.totalChants, 2);
    expect(reloaded.history, hasLength(1));
    expect(reloaded.sessionChants, 0);
    reloaded.dispose();
  });

  test(
    'switching mantras saves the open session on the previous name',
    () async {
      store.chant();
      store.chant();
      store.chant();
      store.selectMantra('ram-naam');
      await store.flush();

      expect(store.active.name, 'Ram Naam');
      expect(store.sessionChants, 0);
      expect(store.history.single.mantraName, 'Gan Ganapataye Namah');
      expect(store.history.single.chants, 3);
      expect(
        store.mantras
            .firstWhere((mantra) => mantra.id == 'gan-ganapataye')
            .totalChants,
        3,
      );
    },
  );
}
