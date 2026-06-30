import 'package:frontend/models/subject.dart';
import 'package:frontend/models/topic.dart';
import 'package:frontend/models/study_note.dart';

const exampleSubjects = [
  Subject(id: 1, name: 'Project Management'),
  Subject(id: 2, name: 'WGP'),
  Subject(id: 3, name: 'Anwendungsentwicklung'),
  Subject(id: 4, name: 'WISO'),
];

const exampleTopics = [
  Topic(id: 1, subjectId: 1, name: 'Projektplanung'),
  Topic(id: 2, subjectId: 1, name: 'Agile Methoden'),
  Topic(id: 3, subjectId: 1, name: 'Scrum'),
  Topic(id: 4, subjectId: 1, name: 'Risikomanagement'),
  Topic(id: 5, subjectId: 2, name: 'Wirtschaftsprozesse'),
  Topic(id: 6, subjectId: 2, name: 'Geschaeftsprozesse'),
  Topic(id: 7, subjectId: 2, name: 'Beschaffung'),
  Topic(id: 8, subjectId: 2, name: 'Vertrieb'),
  Topic(id: 9, subjectId: 2, name: 'Rechnungswesen'),
  Topic(id: 10, subjectId: 3, name: 'Dart Grundlagen'),
  Topic(id: 11, subjectId: 3, name: 'Flutter Widgets'),
  Topic(id: 12, subjectId: 3, name: 'State Management'),
  Topic(id: 13, subjectId: 3, name: 'REST APIs'),
  Topic(id: 14, subjectId: 3, name: 'Datenmodelle'),
  Topic(id: 15, subjectId: 4, name: 'Arbeitsrecht'),
  Topic(id: 16, subjectId: 4, name: 'Wirtschaftsordnung'),
  Topic(id: 17, subjectId: 4, name: 'Vertragsrecht'),
  Topic(id: 18, subjectId: 4, name: 'Sozialversicherung'),
  Topic(id: 19, subjectId: 4, name: 'Datenschutz'),
];

const exampleStudyNotes = [
  StudyNote(
    id: 1,
    topicId: 1,
    title: 'Grundlagen der Projektplanung',
    content:
        'Projektplanung beschreibt die strukturierte Vorbereitung eines Projekts. Dabei werden Ziele, Aufgaben, Zeitplan, Ressourcen und Risiken festgelegt.',
  ),
  StudyNote(
    id: 2,
    topicId: 1,
    title: 'Warum Projektplanung wichtig ist',
    content:
        'Eine gute Projektplanung hilft dabei, Aufgaben klar zu verteilen, Probleme frueh zu erkennen und den Fortschritt besser zu kontrollieren.',
  ),
  StudyNote(
    id: 3,
    topicId: 2,
    title: 'Agile Methoden',
    content:
        'Agile Methoden setzen auf kurze Entwicklungszyklen, regelmaessiges Feedback und flexible Anpassungen waehrend des Projekts.',
  ),
  StudyNote(
    id: 4,
    topicId: 5,
    title: 'Wirtschaftsprozesse',
    content:
        'Wirtschaftsprozesse beschreiben wiederkehrende Ablaeufe in einem Unternehmen, zum Beispiel Beschaffung, Produktion, Vertrieb und Rechnungswesen.',
  ),
  StudyNote(
    id: 5,
    topicId: 6,
    title: 'Geschaeftsprozesse verstehen',
    content:
        'Ein Geschaeftsprozess besteht aus mehreren zusammenhaengenden Schritten, die ein bestimmtes betriebliches Ziel erreichen sollen.',
  ),
  StudyNote(
    id: 6,
    topicId: 10,
    title: 'Dart Grundlagen',
    content:
        'Dart ist eine Programmiersprache mit statischer Typisierung. Sie wird haeufig zusammen mit Flutter verwendet, um Apps zu entwickeln.',
  ),
  StudyNote(
    id: 7,
    topicId: 11,
    title: 'Flutter Widgets',
    content:
        'Widgets sind die Grundbausteine einer Flutter-App. Jede sichtbare Struktur, wie Text, Button, Row oder Column, ist ein Widget.',
  ),
  StudyNote(
    id: 8,
    topicId: 12,
    title: 'State Management',
    content:
        'State Management beschreibt, wie veraenderliche Daten in einer App gespeichert, aktualisiert und an die Benutzeroberflaeche weitergegeben werden.',
  ),
  StudyNote(
    id: 9,
    topicId: 13,
    title: 'REST APIs in Flutter',
    content:
        'Eine REST API erlaubt es einer App, Daten ueber HTTP von einem Backend zu lesen, zu erstellen, zu aktualisieren oder zu loeschen.',
  ),
  StudyNote(
    id: 10,
    topicId: 15,
    title: 'Arbeitsrecht',
    content:
        'Das Arbeitsrecht regelt die Rechte und Pflichten von Arbeitnehmern und Arbeitgebern, zum Beispiel Arbeitszeiten, Kuendigung und Urlaub.',
  ),
  StudyNote(
    id: 11,
    topicId: 18,
    title: 'Sozialversicherung',
    content:
        'Die Sozialversicherung schuetzt Menschen gegen wichtige Lebensrisiken. Dazu gehoeren Krankenversicherung, Rentenversicherung, Pflegeversicherung, Unfallversicherung und Arbeitslosenversicherung.',
  ),
];
