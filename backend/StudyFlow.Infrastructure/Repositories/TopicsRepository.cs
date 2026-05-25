using Microsoft.EntityFrameworkCore;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;
using StudyFlow.Infrastructure.Persistence;

namespace StudyFlow.Infrastructure.Repositories;

internal class TopicsRepository(StudyFlowDbContext dbContext) : ITopicsRepository
{
    public async Task<IEnumerable<Topic>> GetAllAsync()
    {
        return await dbContext.Topics.ToListAsync();
    }

    public async Task<Topic?> GetByIdAsync(int id)
    {
        return await dbContext.Topics
            .FirstOrDefaultAsync(topic => topic.Id == id);
    }

    public async Task<IEnumerable<Topic>> GetBySubjectIdAsync(int subjectId)
    {
        return await dbContext.Topics
            .Where(topic => topic.SubjectId == subjectId)
            .ToListAsync();
    }

    public async Task<int> Create(Topic topic)
    {
        dbContext.Topics.Add(topic);

        await dbContext.SaveChangesAsync();

        return topic.Id;
    }
}