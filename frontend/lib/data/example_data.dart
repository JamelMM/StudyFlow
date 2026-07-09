import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/models/study_note.dart';

const exampleSubjects = [
  Subject(id: 'subject-1', name: 'Project Management'),
  Subject(id: 'subject-2', name: 'WGP'),
  Subject(id: 'subject-3', name: 'Anwendungsentwicklung'),
  Subject(id: 'subject-4', name: 'WISO'),
];

final exampleTopics = [
  Topic(
    id: 'topic-1',
    subjectId: 'subject-1',
    name: 'Projektplanung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-2',
    subjectId: 'subject-1',
    name: 'Agile Methoden',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-3',
    subjectId: 'subject-1',
    name: 'Scrum',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-4',
    subjectId: 'subject-1',
    name: 'Risikomanagement',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-5',
    subjectId: 'subject-2',
    name: 'Wirtschaftsprozesse',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-6',
    subjectId: 'subject-2',
    name: 'Geschaeftsprozesse',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-7',
    subjectId: 'subject-2',
    name: 'Beschaffung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-8',
    subjectId: 'subject-2',
    name: 'Vertrieb',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-9',
    subjectId: 'subject-2',
    name: 'Rechnungswesen',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-10',
    subjectId: 'subject-3',
    name: 'Dart Grundlagen',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-11',
    subjectId: 'subject-3',
    name: 'Flutter Widgets',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-12',
    subjectId: 'subject-3',
    name: 'State Management',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-13',
    subjectId: 'subject-3',
    name: 'REST APIs',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-14',
    subjectId: 'subject-3',
    name: 'Datenmodelle',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-15',
    subjectId: 'subject-4',
    name: 'Arbeitsrecht',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-16',
    subjectId: 'subject-4',
    name: 'Wirtschaftsordnung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-17',
    subjectId: 'subject-4',
    name: 'Vertragsrecht',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-18',
    subjectId: 'subject-4',
    name: 'Sozialversicherung',
    createdAt: DateTime(2026, 7, 8),
  ),
  Topic(
    id: 'topic-19',
    subjectId: 'subject-4',
    name: 'Datenschutz',
    createdAt: DateTime(2026, 7, 8),
  ),
];

final exampleStudyNotes = [
  StudyNote(
    id: 'note-1',
    topicId: 'topic-1',
    name: 'Grundlagen der Projektplanung',
    markdownText:
        'Projektplanung beschreibt die strukturierte Vorbereitung eines Projekts. Dabei werden Ziele, Aufgaben, Zeitplan, Ressourcen und Risiken festgelegt.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-2',
    topicId: 'topic-1',
    name: 'Warum Projektplanung wichtig ist',
    markdownText:
        'Eine gute Projektplanung hilft dabei, Aufgaben klar zu verteilen, Probleme frueh zu erkennen und den Fortschritt besser zu kontrollieren.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-3',
    topicId: 'topic-2',
    name: 'Agile Methoden',
    markdownText:
        'Agile Methoden setzen auf kurze Entwicklungszyklen, regelmaessiges Feedback und flexible Anpassungen waehrend des Projekts.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-4',
    topicId: 'topic-5',
    name: 'Wirtschaftsprozesse',
    markdownText:
        'Wirtschaftsprozesse beschreiben wiederkehrende Ablaeufe in einem Unternehmen, zum Beispiel Beschaffung, Produktion, Vertrieb und Rechnungswesen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-5',
    topicId: 'topic-6',
    name: 'Geschaeftsprozesse verstehen',
    markdownText:
        'Ein Geschaeftsprozess besteht aus mehreren zusammenhaengenden Schritten, die ein bestimmtes betriebliches Ziel erreichen sollen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-6',
    topicId: 'topic-10',
    name: 'Dart Grundlagen',
    markdownText:
        'Dart ist eine Programmiersprache mit statischer Typisierung. Sie wird haeufig zusammen mit Flutter verwendet, um Apps zu entwickeln.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-7',
    topicId: 'topic-11',
    name: 'Flutter Widgets',
    markdownText:
        'Widgets sind die Grundbausteine einer Flutter-App. Jede sichtbare Struktur, wie Text, Button, Row oder Column, ist ein Widget.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-8',
    topicId: 'topic-12',
    name: 'State Management',
    markdownText:
        'State Management beschreibt, wie veraenderliche Daten in einer App gespeichert, aktualisiert und an die Benutzeroberflaeche weitergegeben werden.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-9',
    topicId: 'topic-13',
    name: 'REST APIs in Flutter',
    markdownText:
        'Eine REST API erlaubt es einer App, Daten ueber HTTP von einem Backend zu lesen, zu erstellen, zu aktualisieren oder zu loeschen.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-10',
    topicId: 'topic-15',
    name: 'Arbeitsrecht',
    markdownText:
        'Das Arbeitsrecht regelt die Rechte und Pflichten von Arbeitnehmern und Arbeitgebern, zum Beispiel Arbeitszeiten, Kuendigung und Urlaub.',
    createdAt: DateTime(2026, 7, 8),
  ),
  StudyNote(
    id: 'note-11',
    topicId: 'topic-18',
    name: 'Sozialversicherung',
    markdownText:
        'Die Sozialversicherung schuetzt Menschen gegen wichtige Lebensrisiken. Dazu gehoeren Krankenversicherung, Rentenversicherung, Pflegeversicherung, Unfallversicherung und Arbeitslosenversicherung.',
    createdAt: DateTime(2026, 7, 8),
  ),
];
