using Microsoft.EntityFrameworkCore;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;
using StudyFlow.Infrastructure.Persistence;

namespace StudyFlow.Infrastructure.Repositories;

internal class SubjectsRepository(StudyFlowDbContext dbContext) : ISubjectsRepository
{
    public async Task<IEnumerable<Subject>> GetAllAsync()
    {
        return await dbContext.Subjects.ToListAsync();
    }

    public async Task<Subject?> GetByIdAsync(int id)
    {
        return await dbContext.Subjects
            .FirstOrDefaultAsync(subject => subject.Id == id);
    }

    public async Task<int> Create(Subject subject)
    {
        dbContext.Subjects.Add(subject);
        await dbContext.SaveChangesAsync();

        return subject.Id;
    }
}
