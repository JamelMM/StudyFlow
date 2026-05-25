namespace StudyFlow.Application.Topics.Dtos;

public class TopicDto
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
    public int SubjectId { get; set; }

    public DateTime CreatedAt { get; set; }
    public DateOnly? NextReviewDate { get; set; }
    public DateTime? LastReviewedAt { get; set; }
    public int? CurrentScore { get; set; }
}