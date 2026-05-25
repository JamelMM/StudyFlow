using StudyFlow.Application.Topics.Dtos;

namespace StudyFlow.Application.Topics;

public interface ITopicsService
{
    Task<IEnumerable<TopicDto>> GetAllAsync();
    Task<TopicDto?> GetByIdAsync(int id);
    Task<IEnumerable<TopicDto>> GetBySubjectIdAsync(int subjectId);
    Task<int> Create(CreateTopicDto dto);
}
