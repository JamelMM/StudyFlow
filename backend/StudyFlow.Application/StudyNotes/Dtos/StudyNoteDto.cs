namespace StudyFlow.Application.StudyNotes.Dtos;

public class StudyNoteDto
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
    public string MarkdownText { get; set; } = default!;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public int TopicId { get; set; }
}
