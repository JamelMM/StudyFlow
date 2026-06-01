using Microsoft.AspNetCore.Mvc;
using StudyFlow.Application.StudyNotes;
using StudyFlow.Application.StudyNotes.Dtos;

namespace StudyFlow.API.Controllers;

[ApiController]
[Route("api/study-notes")]
public class StudyNotesController(IStudyNotesService studyNotesService) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var studyNotes = await studyNotesService.GetAllAsync();

        return Ok(studyNotes);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([FromRoute] int id)
    {
        var studyNote = await studyNotesService.GetByIdAsync(id);

        if (studyNote is null)
            return NotFound();

        return Ok(studyNote);
    }

    [HttpGet("by-topic/{topicId}")]
    public async Task<IActionResult> GetByTopicId([FromRoute] int topicId)
    {
        var studyNotes = await studyNotesService.GetByTopicIdAsync(topicId);

        return Ok(studyNotes);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateStudyNoteDto dto)
    {
        if (string.IsNullOrWhiteSpace(dto.Name))
        {
            return BadRequest("Study note name is required.");
        }

        if (dto.Name.Length < 3 || dto.Name.Length > 100)
        {
            return BadRequest("Study note name must be between 3 and 100 characters.");
        }

        if (string.IsNullOrWhiteSpace(dto.MarkdownText))
        {
            return BadRequest("Study note content is required.");
        }


        var id = await studyNotesService.Create(dto);

        return CreatedAtAction(nameof(GetById), new { id }, null);
    }
}