using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StudyFlow.Domain.Repositories;
using StudyFlow.Infrastructure.Persistence;
using StudyFlow.Infrastructure.Repositories;

namespace StudyFlow.Infrastructure.Extensions;

public static class ServiceCollectionExtensions
{

    //Extension-Methode zur Verbindung mit der Datenbank

    public static void AddInfrastructure(this IServiceCollection services, IConfiguration configuration)    
    {
        string? connectionString = configuration.GetConnectionString("StudyFlowDb")       
            ?? throw new InvalidOperationException("Connection string 'StudyFlowDb' not found.");

        services.AddDbContext<StudyFlowDbContext>(options =>
            options.UseNpgsql(connectionString));

        services.AddScoped<ISubjectsRepository, SubjectsRepository>();
        services.AddScoped<ITopicsRepository, TopicsRepository>();
        services.AddScoped<IStudyNotesRepository, StudyNotesRepository>();
    }

}

