using Microsoft.EntityFrameworkCore;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;
using StudyFlow.Infrastructure.Persistence;

namespace StudyFlow.Infrastructure.Repositories;

internal class StudyNotesRepository(StudyFlowDbContext dbContext) : IStudyNotesRepository
{
    public async Task<IEnumerable<StudyNote>> GetAllAsync()
    {
        return await dbContext.StudyNotes.ToListAsync();
    }

    public async Task<StudyNote?> GetByIdAsync(int id)
    {
        return await dbContext.StudyNotes
            .FirstOrDefaultAsync(studyNote => studyNote.Id == id);
    }

    public async Task<IEnumerable<StudyNote>> GetByTopicIdAsync(int topicId)
    {
        return await dbContext.StudyNotes
            .Where(studyNote => studyNote.TopicId == topicId)
            .ToListAsync();
    }

    public async Task<int> Create(StudyNote studyNote)
    {
        dbContext.StudyNotes.Add(studyNote);

        await dbContext.SaveChangesAsync();

        return studyNote.Id;
    }
}