using StudyFlow.Application.StudyNotes.Dtos;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Repositories;

namespace StudyFlow.Application.StudyNotes;

internal class StudyNotesService(IStudyNotesRepository studyNotesRepository) : IStudyNotesService
{
    public async Task<IEnumerable<StudyNoteDto>> GetAllAsync()
    {
        var studyNotes = await studyNotesRepository.GetAllAsync();

        return studyNotes.Select(studyNote => new StudyNoteDto
        {
            Id = studyNote.Id,
            Name = studyNote.Name,
            MarkdownText = studyNote.MarkdownText,
            CreatedAt = studyNote.CreatedAt,
            UpdatedAt = studyNote.UpdatedAt,
            TopicId = studyNote.TopicId
        });
    }

    public async Task<StudyNoteDto?> GetByIdAsync(int id)
    {
        var studyNote = await studyNotesRepository.GetByIdAsync(id);

        if (studyNote is null)
            return null;

        return new StudyNoteDto
        {
            Id = studyNote.Id,
            Name = studyNote.Name,
            MarkdownText = studyNote.MarkdownText,
            CreatedAt = studyNote.CreatedAt,
            UpdatedAt = studyNote.UpdatedAt,
            TopicId = studyNote.TopicId
        };
    }

    public async Task<IEnumerable<StudyNoteDto>> GetByTopicIdAsync(int topicId)
    {
        var studyNotes = await studyNotesRepository.GetByTopicIdAsync(topicId);

        return studyNotes.Select(studyNote => new StudyNoteDto
        {
            Id = studyNote.Id,
            Name = studyNote.Name,
            MarkdownText = studyNote.MarkdownText,
            CreatedAt = studyNote.CreatedAt,
            UpdatedAt = studyNote.UpdatedAt,
            TopicId = studyNote.TopicId
        });
    }

    public async Task<int> Create(CreateStudyNoteDto dto)
    {
        var studyNote = new StudyNote
        {
            Name = dto.Name,
            MarkdownText = dto.MarkdownText,
            TopicId = dto.TopicId,
            CreatedAt = DateTime.UtcNow
        };

        var id = await studyNotesRepository.Create(studyNote);

        return id;
    }
}