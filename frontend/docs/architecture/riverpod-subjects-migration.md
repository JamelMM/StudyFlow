## Ziel

**Die Subject-Logik soll schrittweise aus dem Screen ausgelagert werden.**
#### Vor der Migration verwaltet `SubjectScreen` selbst:

-  das Laden der Subjects
- den lokalen Ladezustand
- die lokale Subject-Liste
- das Aktualisieren der UI nach Create/Edit/Delete
- den direkten Zugriff auf das Repository über get_it

#### Nach der Migration soll `SubjectScreen` hauptsächlich:

- den aktuellen Zustand beobachten
- UI für Loading, Error, Empty und Data anzeigen
- Benutzeraktionen an Provider/Notifier weitergeben

---
## Vorher

**Der Screen enthält eigene State-Variablen:**

```dart

List<Subject> _subjects = [];

bool _isLoading = true;

//Der Screen lädt die Daten selbst:

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

**Danach lädt ein Provider die Subjects:**

```dart
final subjectsProvider = FutureProvider<List<Subject>>((ref) async {

  final subjectsRepository = ref.watch(subjectsRepositoryProvider);

  return subjectsRepository.getSubjects();
});
```

**Der Screen muss die Liste nicht mehr manuell laden. Er beobachtet nur noch den Provider.**

---
## Vorteil

- weniger Logik im Screen
- klarere Trennung zwischen UI und Datenzugriff
- weniger manuelles setState
- Loading/Error/Data-State wird sauberer abgebildet
- besser vorbereitet für Streams und spätere ToStore-Listener
- leichter wiederverwendbar für Topics, Study Notes und Quiz-Daten

---
## Architektur-Idee
```text

SubjectScreen

  -> beobachtet subjectsProvider
  -> ruft Aktionen auf

subjectsProvider

  -> lädt Daten async

subjectsRepositoryProvider

  -> stellt SubjectsRepository bereit  

ToStoreSubjectsRepository

  -> spricht mit ToStore

```
 
---
## Lernpunkt

- Riverpod ersetzt hier nicht das Repository Pattern.

- Riverpod organisiert den Zugriff auf Zustand und Abhängigkeiten.

- Das Repository bleibt für die Persistenz zuständig.

- Der Provider verbindet UI und Repository sauber miteinander.

---
## Offene Fragen

- Wann benutzen wir `watch` und wann `read`?
- Wann reicht `FutureProvider` und wann brauchen wir einen Notifier?
- Wie aktualisieren wir die Liste nach Create/Edit/Delete?
- Wie vermeiden wir unnötige Rebuilds?
- Wie verbinden wir später ToStore Streams?

---
## Wiederholbares Muster

1. Repository Provider erstellen.
2. Daten Provider erstellen.
3. Screen in ConsumerWidget/ConsumerStatefulWidget umwandeln.
4. Provider im Screen beobachten.
5. Loading/Error/Data-State anzeigen.
6. Aktionen aus dem Screen auslagern.