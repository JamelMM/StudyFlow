using StudyFlow.Domain.Entities;

namespace StudyFlow.Domain.Repositories;

public interface IStudyNotesRepository
{
    Task<IEnumerable<StudyNote>> GetAllAsync();
    Task<StudyNote?> GetByIdAsync(int id);
    Task<IEnumerable<StudyNote>> GetByTopicIdAsync(int topicId);
    Task<int> Create(StudyNote studyNote);
}
