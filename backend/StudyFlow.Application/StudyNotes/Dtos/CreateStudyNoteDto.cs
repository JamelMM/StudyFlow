namespace StudyFlow.Application.StudyNotes.Dtos;

public class CreateStudyNoteDto
{
    public string Name { get; set; } = default!;
    public string MarkdownText { get; set; } = default!;
    public int TopicId { get; set; }
}