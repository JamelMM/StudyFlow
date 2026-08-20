# Riverpod Migration - Subjects Flow
## Goal

**The Subject logic is being moved step by step out of the screen.**
#### Before the migration, `SubjectScreen` was responsible for:

- loading subjects
- managing the local loading state
- storing the local subject list
- refreshing the UI after create/edit/delete operations
- accessing the repository directly through `get_it`

#### After the migration, `SubjectScreen` should mainly:

- observe the current state
- render UI for loading, error, empty, and data states
- delegate user actions to the controller
- handle SnackBars, dialogs, modals, and navigation

---
## Before

**The screen had its own state variables:**

```dart

List<Subject> _subjects = [];

bool _isLoading = true;

//The screen loaded the data manually:

Future<void> _loadSubjects() async {

  final loadedSubjects = await _subjectsRepository.getSubjects();

  

  if (!mounted) {

    return;

  }

  

  setState(() {

    _subjects = loadedSubjects;

    _isLoading = false;

  });

}
```

**This meant that the screen was responsible not only for UI, but also for part of the data-loading logic.**

## After

Riverpod first provides the repository dependency:

```dart
final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {

  return ToStoreSubjectsRepository();

});
```


A controller then manages the Subject state and actions:

```dart
final subjectsControllerProvider =

    AsyncNotifierProvider<SubjectsController, List<Subject>>(

  SubjectsController.new,

);

class SubjectsController extends AsyncNotifier<List<Subject>> {

  @override
  Future<List<Subject>> build() async {

    final subjectsRepository = ref.watch(subjectsRepositoryProvider);  
    return subjectsRepository.getSubjects();
  }

  Future<void> addSubject(String name) async {

    final subjectsRepository = ref.read(subjectsRepositoryProvider);
    await subjectsRepository.addSubject(name);

    ref.invalidateSelf();
  }

  Future<void> removeSubject(String id) async {

    final subjectsRepository = ref.read(subjectsRepositoryProvider);
    await subjectsRepository.removeSubject(id);

    ref.invalidateSelf();
  }

  Future<void> updateSubject({

    required String id,
    required String name,

  }) async {

    final subjectsRepository = ref.read(subjectsRepositoryProvider);
    await subjectsRepository.updateSubject(id: id, name: name);

    ref.invalidateSelf();

  }

}

```

**The screen no longer loads the list manually. It observes the controller state:**

```dart
final subjectsAsync = ref.watch(subjectsControllerProvider);
```

**User actions are delegated to the controller:**

```dart
await ref.read(subjectsControllerProvider.notifier).addSubject(name);
await ref.read(subjectsControllerProvider.notifier).removeSubject(subject.id);
await ref.read(subjectsControllerProvider.notifier).updateSubject(
  
  id: subject.id,
  name: name,
);
```

## Benefits

- less logic inside the screen
- clearer separation between UI, state, and data access
- less manual setState
- no manual subject loading inside the screen
- loading/error/data states are represented more clearly
- better prepared for streams and future ToStore listeners
- easier to reuse the pattern for Topics, Study Notes, and Quiz data
- easier to test because actions are grouped inside the controller
- gradual replacement of get_it

## Architecture Idea

```Text
SubjectScreen

  -> observes subjectsControllerProvider
  -> renders loading/error/empty/data states
  -> calls controller actions
  -> stays responsible for UI, dialogs, SnackBars, and navigation

  

SubjectsController

  -> loads Subjects
  -> manages Subject state
  -> contains actions such as add/update/remove
  -> invalidates itself after changes

  

subjectsRepositoryProvider

  -> provides SubjectsRepository

  

SubjectsRepository

  -> defines the data access contract

  

ToStoreSubjectsRepository

  -> talks to ToStore
  -> creates, reads, updates, and deletes local data
```
## Learning Points

- Riverpod does not replace the Repository Pattern.
- Riverpod gradually replaces get_it as the access point for dependencies.
- The repository remains responsible for persistence.
- The controller manages UI-related state and actions.
- The screen only observes state and triggers actions.
- ref.watch(...) is used for state inside build.
- ref.read(...notifier) is used for actions.
- ref.invalidateSelf() reloads the controller after changes.
- mounted is still important when context is used after an await.

## Open Questions

- When should we use watch, and when should we use read?
- When is FutureProvider enough, and when do we need an AsyncNotifier?
- How can we avoid unnecessary rebuilds?
- How can we connect ToStore streams later?
- How can a controller perform optimistic updates?
- How can we prevent lists from jumping back to the top after updates?
- When should a screen be a ConsumerWidget, and when should it be a ConsumerStatefulWidget?

## Repeatable Pattern

1. Create a repository provider.
2. Create a controller with AsyncNotifier.
3. Load the initial data inside the controller's build() method.
4. Convert the screen to ConsumerWidget or ConsumerStatefulWidget.
5. Observe the controller state in the screen with ref.watch(...).
6. Render loading/error/empty/data states.
7. Create actions inside the controller.
8. Call controller actions from the screen with ref.read(...notifier).
9. Use ref.invalidateSelf() inside the controller after data changes.
10. Remove old local state variables, initState, manual loading, and direct repository access from the screen.

---
---
## Ziel

**Die Subject-Logik soll schrittweise aus dem Screen ausgelagert werden.**

#### Vor der Migration verwaltet `SubjectScreen` selbst:

- das Laden der Subjects
- den lokalen Ladezustand
- die lokale Subject-Liste
- das Aktualisieren der UI nach Create/Edit/Delete
- den direkten Zugriff auf das Repository über `get_it`

#### Nach der Migration soll `SubjectScreen` hauptsächlich:

- den aktuellen Zustand beobachten
- UI für Loading, Error, Empty und Data anzeigen
- Benutzeraktionen an den Controller weitergeben
- SnackBars, Dialoge, Modals und Navigation auslösen

---

## Vorher

**Der Screen enthält eigene State-Variablen:**

```dart
List<Subject> _subjects = [];
bool _isLoading = true;
````

**Der Screen lädt die Daten selbst:**

```dart
Future<void> _loadSubjects() async {
  final loadedSubjects = await _subjectsRepository.getSubjects();

  if (!mounted) {
    return;
  }

  setState(() {
    _subjects = loadedSubjects;
    _isLoading = false;
  });
}
```

Dadurch kennt der Screen nicht nur die UI, sondern auch Teile der Datenlogik.

---

## Nachher

**Riverpod stellt zuerst das Repository bereit:**

```dart
final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {
  return ToStoreSubjectsRepository();
});
```

**Danach verwaltet ein Controller den Subject-State und die Aktionen:**

```dart
final subjectsControllerProvider =
    AsyncNotifierProvider<SubjectsController, List<Subject>>(
  SubjectsController.new,
);

class SubjectsController extends AsyncNotifier<List<Subject>> {
  @override
  Future<List<Subject>> build() async {
    final subjectsRepository = ref.watch(subjectsRepositoryProvider);

    return subjectsRepository.getSubjects();
  }

  Future<void> addSubject(String name) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.addSubject(name);

    ref.invalidateSelf();
  }

  Future<void> removeSubject(String id) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.removeSubject(id);

    ref.invalidateSelf();
  }

  Future<void> updateSubject({
    required String id,
    required String name,
  }) async {
    final subjectsRepository = ref.read(subjectsRepositoryProvider);

    await subjectsRepository.updateSubject(id: id, name: name);

    ref.invalidateSelf();
  }
}
```

**Der Screen lädt die Liste nicht mehr manuell. Er beobachtet den Controller-State:**

```dart
final subjectsAsync = ref.watch(subjectsControllerProvider);
```

**Benutzeraktionen werden an den Controller weitergegeben:**

```dart
await ref.read(subjectsControllerProvider.notifier).addSubject(name);
await ref.read(subjectsControllerProvider.notifier).removeSubject(subject.id);
await ref.read(subjectsControllerProvider.notifier).updateSubject(
  id: subject.id,
  name: name,
);
```

---

## Vorteil

- weniger Logik im Screen
- klarere Trennung zwischen UI, State und Datenzugriff
- weniger manuelles `setState`
- kein manuelles Laden der Subject-Liste im Screen
- Loading/Error/Data-State wird sauberer abgebildet
- besser vorbereitet für Streams und spätere ToStore-Listener
- leichter wiederverwendbar für Topics, Study Notes und Quiz-Daten
- besser testbar, weil Aktionen im Controller gebündelt sind
- schrittweise Ablösung von `get_it`

---

## Architektur-Idee

```Text
SubjectScreen
  -> beobachtet subjectsControllerProvider
  -> zeigt Loading/Error/Empty/Data an
  -> ruft Controller-Aktionen auf
  -> bleibt verantwortlich für UI, Dialoge, SnackBars und Navigation

SubjectsController
  -> lädt Subjects
  -> verwaltet den Subject-State
  -> enthält Aktionen wie add/update/remove
  -> invalidiert sich nach Änderungen selbst

subjectsRepositoryProvider
  -> stellt SubjectsRepository bereit

SubjectsRepository
  -> definiert den Vertrag für den Datenzugriff

ToStoreSubjectsRepository
  -> spricht mit ToStore
  -> speichert, lädt, aktualisiert und löscht lokale Daten
```

---

## Lernpunkt

- Riverpod ersetzt hier nicht das Repository Pattern.
- Riverpod ersetzt schrittweise `get_it` als Zugriffspunkt für Abhängigkeiten.
- Das Repository bleibt für die Persistenz zuständig.
- Der Controller verwaltet UI-nahen State und Aktionen.
- Der Screen beobachtet nur noch den Zustand und löst Aktionen aus.
- `ref.watch(...)` wird für Zustand im `build` verwendet.
- `ref.read(...notifier)` wird für Aktionen verwendet.
- `ref.invalidateSelf()` lädt den Controller nach Änderungen neu.
- `mounted` bleibt wichtig, wenn nach einem `await` noch `context` verwendet wird.

---

## Offene Fragen

- Wann benutzen wir `watch` und wann `read`?
- Wann reicht `FutureProvider` und wann brauchen wir einen `AsyncNotifier`?
- Wie vermeiden wir unnötige Rebuilds?
- Wie verbinden wir später ToStore Streams?
- Wie kann ein Controller optimistische Updates durchführen?
- Wie verhindern wir, dass Listen nach Updates an den Anfang springen?
- Wann sollte ein Screen `ConsumerWidget` und wann `ConsumerStatefulWidget` sein?

---

## Wiederholbares Muster

1. Repository Provider erstellen.
2. Controller mit `AsyncNotifier` erstellen.
3. Initiale Daten im `build()` des Controllers laden.
4. Screen in `ConsumerWidget` oder `ConsumerStatefulWidget` umwandeln.
5. Controller-State im Screen mit `ref.watch(...)` beobachten.
6. Loading/Error/Empty/Data-State anzeigen.
7. Aktionen im Controller erstellen.
8. Aktionen im Screen mit `ref.read(...notifier)` aufrufen.
9. Nach Änderungen im Controller `ref.invalidateSelf()` verwenden.
10. Alte lokale State-Variablen, `initState`, manuelles Laden und direkte Repository-Zugriffe aus dem Screen entfernen.