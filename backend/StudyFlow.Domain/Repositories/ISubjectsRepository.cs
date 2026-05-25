using StudyFlow.Domain.Entities;

namespace StudyFlow.Domain.Repositories;

public interface ISubjectsRepository
{
    Task<IEnumerable<Subject>> GetAllAsync();
    Task<Subject?> GetByIdAsync(int id);
    Task<int> Create(Subject subject);
 
}
