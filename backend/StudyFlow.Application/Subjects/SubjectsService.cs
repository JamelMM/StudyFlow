using StudyFlow.Application.Subjects.Dtos;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;

namespace StudyFlow.Application.Subjects;

public class SubjectsService(ISubjectsRepository subjectsRepository) : ISubjectsService
{
    public async Task<IEnumerable<SubjectDto>> GetAllAsync()
    {
        IEnumerable<Subject> subjects = await subjectsRepository.GetAllAsync();

        return subjects.Select(subject => new SubjectDto
        {
            Id = subject.Id,
            Name = subject.Name
        });
    }

    public async Task<SubjectDto?> GetByIdAsync(int id)
    {
        var subject = await subjectsRepository.GetByIdAsync(id);

        if (subject is null)
        {
            return null;
        }

        return new SubjectDto
        {
            Id = subject.Id,
            Name = subject.Name
        };
    }

    public async Task<int> Create(CreateSubjectDto dto)
    {
        var subject = new Subject
        {
            Name = dto.Name
        };

        var id = await subjectsRepository.Create(subject);

        return id;
    }
}
 