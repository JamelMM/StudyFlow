namespace StudyFlow.Domain.Entities;

public class Question
{
    public int Id { get; set; }
    public string MarkdownQuestion { get; set; } = default!;
    public string MarkdownAnswer { get; set; } = default!;

    public int QuizId { get; set; }
}
