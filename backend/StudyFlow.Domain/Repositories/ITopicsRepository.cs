

using StudyFlow.Domain.Entities;


namespace StudyFlow.Domain.Repositories;

public interface ITopicsRepository
{
    Task<IEnumerable<Topic>> GetAllAsync();
    Task<Topic?> GetByIdAsync(int id);
    Task<int> Create(Topic topic);
    Task<IEnumerable<Topic>> GetBySubjectIdAsync(int subjectId);
}
