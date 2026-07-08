import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/models/study_note.dart';

const exampleSubjects = [
  Subject(id: 1, name: 'Project Management'),
  Subject(id: 2, name: 'WGP'),
  Subject(id: 3, name: 'Anwendungsentwicklung'),
  Subject(id: 4, name: 'WISO'),
];

final exampleTopics = [
  Topic(
    id: 1,
    subjectId: 1,
    name: 'Projektplanung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 2,
    subjectId: 1,
    name: 'Agile Methoden',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(id: 3, subjectId: 1, name: 'Scrum', createdAt: DateTime(2026, 7, 8)),
  Topic(
    id: 4,
    subjectId: 1,
    name: 'Risikomanagement',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 5,
    subjectId: 2,
    name: 'Wirtschaftsprozesse',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 6,
    subjectId: 2,
    name: 'Geschaeftsprozesse',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 7,
    subjectId: 2,
    name: 'Beschaffung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(id: 8, subjectId: 2, name: 'Vertrieb', createdAt: DateTime(2026, 7, 8)),
  Topic(
    id: 9,
    subjectId: 2,
    name: 'Rechnungswesen',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 10,
    subjectId: 3,
    name: 'Dart Grundlagen',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 11,
    subjectId: 3,
    name: 'Flutter Widgets',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 12,
    subjectId: 3,
    name: 'State Management',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 13,
    subjectId: 3,
    name: 'REST APIs',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 14,
    subjectId: 3,
    name: 'Datenmodelle',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 15,
    subjectId: 4,
    name: 'Arbeitsrecht',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 16,
    subjectId: 4,
    name: 'Wirtschaftsordnung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 17,
    subjectId: 4,
    name: 'Vertragsrecht',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 18,
    subjectId: 4,
    name: 'Sozialversicherung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 19,
    subjectId: 4,
    name: 'Datenschutz',
    createdAt: DateTime(2026, 7, 8),
  ),
];

final exampleStudyNotes = [
  StudyNote(
    id: 1,
    topicId: 1,
    name: 'Grundlagen der Projektplanung',
    markdownText:
        'Projektplanung beschreibt die strukturierte Vorbereitung eines Projekts. Dabei werden Ziele, Aufgaben, Zeitplan, Ressourcen und Risiken festgelegt.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 2,
    topicId: 1,
    name: 'Warum Projektplanung wichtig ist',
    markdownText:
        'Eine gute Projektplanung hilft dabei, Aufgaben klar zu verteilen, Probleme frueh zu erkennen und den Fortschritt besser zu kontrollieren.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 3,
    topicId: 2,
    name: 'Agile Methoden',
    markdownText:
        'Agile Methoden setzen auf kurze Entwicklungszyklen, regelmaessiges Feedback und flexible Anpassungen waehrend des Projekts.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 4,
    topicId: 5,
    name: 'Wirtschaftsprozesse',
    markdownText:
        'Wirtschaftsprozesse beschreiben wiederkehrende Ablaeufe in einem Unternehmen, zum Beispiel Beschaffung, Produktion, Vertrieb und Rechnungswesen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 5,
    topicId: 6,
    name: 'Geschaeftsprozesse verstehen',
    markdownText:
        'Ein Geschaeftsprozess besteht aus mehreren zusammenhaengenden Schritten, die ein bestimmtes betriebliches Ziel erreichen sollen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 6,
    topicId: 10,
    name: 'Dart Grundlagen',
    markdownText:
        'Dart ist eine Programmiersprache mit statischer Typisierung. Sie wird haeufig zusammen mit Flutter verwendet, um Apps zu entwickeln.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 7,
    topicId: 11,
    name: 'Flutter Widgets',
    markdownText:
        'Widgets sind die Grundbausteine einer Flutter-App. Jede sichtbare Struktur, wie Text, Button, Row oder Column, ist ein Widget.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 8,
    topicId: 12,
    name: 'State Management',
    markdownText:
        'State Management beschreibt, wie veraenderliche Daten in einer App gespeichert, aktualisiert und an die Benutzeroberflaeche weitergegeben werden.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 9,
    topicId: 13,
    name: 'REST APIs in Flutter',
    markdownText:
        'Eine REST API erlaubt es einer App, Daten ueber HTTP von einem Backend zu lesen, zu erstellen, zu aktualisieren oder zu loeschen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 10,
    topicId: 15,
    name: 'Arbeitsrecht',
    markdownText:
        'Das Arbeitsrecht regelt die Rechte und Pflichten von Arbeitnehmern und Arbeitgebern, zum Beispiel Arbeitszeiten, Kuendigung und Urlaub.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 11,
    topicId: 18,
    name: 'Sozialversicherung',
    markdownText:
        'Die Sozialversicherung schuetzt Menschen gegen wichtige Lebensrisiken. Dazu gehoeren Krankenversicherung, Rentenversicherung, Pflegeversicherung, Unfallversicherung und Arbeitslosenversicherung.',
    createdAt: DateTime(2026, 7, 8),
  ),
];
