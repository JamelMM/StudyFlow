namespace StudyFlow.Application.Subjects.Dtos;

public interface ISubjectsService
{
    Task<IEnumerable<SubjectDto>> GetAllAsync();
    Task<SubjectDto?> GetByIdAsync(int id);
    Task<int> Create(CreateSubjectDto dto);
}
