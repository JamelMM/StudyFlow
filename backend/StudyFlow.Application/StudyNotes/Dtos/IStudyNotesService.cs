using StudyFlow.Application.StudyNotes.Dtos;

namespace StudyFlow.Application.StudyNotes;

public interface IStudyNotesService
{
    Task<IEnumerable<StudyNoteDto>> GetAllAsync();
    Task<StudyNoteDto?> GetByIdAsync(int id);
    Task<IEnumerable<StudyNoteDto>> GetByTopicIdAsync(int topicId);
    Task<int> Create(CreateStudyNoteDto dto);
}