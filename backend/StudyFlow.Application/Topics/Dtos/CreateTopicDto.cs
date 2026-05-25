namespace StudyFlow.Application.Topics.Dtos;

public class CreateTopicDto
{
    public string Name { get; set; } = default!;
    public int SubjectId { get; set; }
}