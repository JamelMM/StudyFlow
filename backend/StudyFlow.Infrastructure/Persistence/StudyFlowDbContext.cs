using Microsoft.EntityFrameworkCore;
using StudyFlow.Domain.Entities;
using StudyFlow.Domain.Enums;

namespace StudyFlow.Infrastructure.Persistence;

public class StudyFlowDbContext(DbContextOptions<StudyFlowDbContext> options) : DbContext(options)
{
    public DbSet<Subject> Subjects { get; set; }
    public DbSet<Topic> Topics { get; set; }
    public DbSet<StudyNote> StudyNotes { get; set; }
    public DbSet<Quiz> Quizzes { get; set; }
    public DbSet<Question> Questions { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Subject>()   //Modeliert die Beziehung Subject-Topic. Ein Subject hat mehrere Topics, Topic nur ein Subject
            .HasMany(subject => subject.Topics)
            .WithOne()
            .HasForeignKey(topic => topic.SubjectId);

        modelBuilder.Entity<Topic>()   //Modeliert die Beziehung Topic-StudyNotes. Ein Topic hat mehrere Studynotes, ein StudyNote nur ein Topic
            .HasMany(topic => topic.StudyNotes)
            .WithOne()
            .HasForeignKey(studyNotes => studyNotes.TopicId);

        modelBuilder.Entity<Topic>()   //Modeliert die Beziehung Topic-Quiz. Ein Topic kann mehrere quizzes haben, ein Quiz nur ein Topic
            .HasMany(topic => topic.Quizzes)
            .WithOne()
            .HasForeignKey(quiz => quiz.TopicId);

        modelBuilder.Entity<Topic>()  //Modeliert die Beziehung Topic-ReviewSession. Ein Topic kann mehrere RewiewSessions haben, ein ReviewSession nur ein Topic 
            .HasMany(topic => topic.ReviewSessions)
            .WithOne()
            .HasForeignKey(reviewSession => reviewSession.TopicId);

        modelBuilder.Entity<Quiz>()   //Modeliert die Beziehung Quiz-Question. Ein Quiz kann mehrere question haben, ein Question kann nur zu einen Quiz gehören
            .HasMany(quiz => quiz.Questions)
            .WithOne()
            .HasForeignKey(question => question.QuizId);

    }


}
