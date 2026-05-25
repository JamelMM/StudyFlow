namespace StudyFlow.Domain.Entities;

public class Subject
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;

    public List<Topic> Topics { get; set; } = [];
}
