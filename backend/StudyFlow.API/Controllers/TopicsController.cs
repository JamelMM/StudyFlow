using Microsoft.AspNetCore.Mvc;
using StudyFlow.Application.Topics;
using StudyFlow.Application.Topics.Dtos;

namespace StudyFlow.API.Controllers;

[ApiController]
[Route("api/topics")]
public class TopicsController(ITopicsService topicsService) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var topics = await topicsService.GetAllAsync();

        return Ok(topics);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([FromRoute] int id)
    {
        var topic = await topicsService.GetByIdAsync(id);

        if (topic is null)
            return NotFound();

        return Ok(topic);
    }

    [HttpGet("by-subject/{subjectId}")]
    public async Task<IActionResult> GetBySubjectId([FromRoute] int subjectId)
    {
        var topics = await topicsService.GetBySubjectIdAsync(subjectId);

        return Ok(topics);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateTopicDto dto)
    {
        var id = await topicsService.Create(dto);

        return CreatedAtAction(nameof(GetById), new { id }, null);
    }
}