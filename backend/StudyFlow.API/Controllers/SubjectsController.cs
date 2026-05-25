using Microsoft.AspNetCore.Mvc;
using StudyFlow.Application.Subjects.Dtos;

namespace StudyFlow.API.Controllers;

[ApiController]
[Route("api/subjects")]
public class SubjectsController(ISubjectsService subjectsService) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        IEnumerable<SubjectDto> subjects = await subjectsService.GetAllAsync();

        return Ok(subjects);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([FromRoute] int id)
    {
        SubjectDto? subject = await subjectsService.GetByIdAsync(id);

        if (subject is null)
        {
            return NotFound();
        }
            

        return Ok(subject);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateSubjectDto dto)
    {
        var id = await subjectsService.Create(dto);

        return CreatedAtAction(nameof(GetById), new { id }, null);
    }
}
