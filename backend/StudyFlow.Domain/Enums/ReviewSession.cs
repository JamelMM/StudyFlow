namespace StudyFlow.Domain.Enums;

public class ReviewSession
{
    public int Id { get; set; }

    public int TopicId { get; set; }

    public DateTime ReviewedAt { get; set; }
    public ReviewRating Rating { get; set; }
    public int? Score { get; set; }
    public DateOnly NextReviewDate { get; set; }
}
