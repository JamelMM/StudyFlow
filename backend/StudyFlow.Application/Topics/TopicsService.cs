using StudyFlow.Application.Topics.Dtos;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;

namespace StudyFlow.Application.Topics;

internal class TopicsService(ITopicsRepository topicsRepository) : ITopicsService
{
    public async Task<IEnumerable<TopicDto>> GetAllAsync()
    {
        var topics = await topicsRepository.GetAllAsync();

        return topics.Select(topic => new TopicDto
        {
            Id = topic.Id,
            Name = topic.Name,
            SubjectId = topic.SubjectId,
            CreatedAt = topic.CreatedAt,
            NextReviewDate = topic.NextReviewDate,
            LastReviewedAt = topic.LastReviewedAt,
            CurrentScore = topic.CurrentScore
        });
    }

    public async Task<TopicDto?> GetByIdAsync(int id)
    {
        var topic = await topicsRepository.GetByIdAsync(id);

        if (topic is null)
            return null;

        return new TopicDto
        {
            Id = topic.Id,
            Name = topic.Name,
            SubjectId = topic.SubjectId,
            CreatedAt = topic.CreatedAt,
            NextReviewDate = topic.NextReviewDate,
            LastReviewedAt = topic.LastReviewedAt,
            CurrentScore = topic.CurrentScore
        };
    }

    public async Task<IEnumerable<TopicDto>> GetBySubjectIdAsync(int subjectId)
    {
        var topics = await topicsRepository.GetBySubjectIdAsync(subjectId);

        return topics.Select(topic => new TopicDto
        {
            Id = topic.Id,
            Name = topic.Name,
            SubjectId = topic.SubjectId,
            CreatedAt = topic.CreatedAt,
            NextReviewDate = topic.NextReviewDate,
            LastReviewedAt = topic.LastReviewedAt,
            CurrentScore = topic.CurrentScore
        });
    }

    public async Task<int> Create(CreateTopicDto dto)
    {
        var topic = new Topic
        {
            Name = dto.Name,
            SubjectId = dto.SubjectId,
            CreatedAt = DateTime.UtcNow
        };

        var id = await topicsRepository.Create(topic);

        return id;
    }
}