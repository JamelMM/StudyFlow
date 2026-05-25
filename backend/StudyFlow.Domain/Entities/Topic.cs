using StudyFlow.Domain.Enums;

namespace StudyFlow.Domain.Entities;

public class Topic
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
    public DateTime CreatedAt { get; set; }

    public DateOnly? NextReviewDate { get; set; }
    public DateTime? LastReviewedAt { get; set; }
    public int? CurrentScore { get; set; }

    public int SubjectId { get; set; }

    public List<StudyNote> StudyNotes { get; set; } = []; 
    public List<Quiz> Quizzes { get; set; } = new();
    public List<ReviewSession> ReviewSessions { get; set; } = new List<ReviewSession>();
}