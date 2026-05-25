using Microsoft.Extensions.DependencyInjection;
using StudyFlow.Application.StudyNotes;
using StudyFlow.Application.Subjects;
using StudyFlow.Application.Subjects.Dtos;
using StudyFlow.Application.Topics;

namespace StudyFlow.Application.Extensions;

public static class ServiceCollectionExtensions
{
    public static void AddApplication(this IServiceCollection services)
    {
        services.AddScoped<ISubjectsService, SubjectsService>();
        services.AddScoped<ITopicsService, TopicsService>();
        services.AddScoped<IStudyNotesService, StudyNotesService>();
    }
}
