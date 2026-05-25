namespace StudyFlow.Domain.Entities;

public class Quiz
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
    public DateTime CreatedAt { get; set; }

    public int TopicId { get; set; }

    public List<Question> Questions { get; set; } = [];
}
