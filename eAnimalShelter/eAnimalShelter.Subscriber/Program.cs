using EasyNetQ;
using eAnimalShelter.Model.Messages;
using Microsoft.EntityFrameworkCore;
using eAnimalShelter.Services.Database;

Console.WriteLine("Notification Subscriber started...");

var rabbitHost =
    Environment.GetEnvironmentVariable("RABBITMQ_HOST");

var rabbitUser =
    Environment.GetEnvironmentVariable("RABBITMQ_USER");

var rabbitPassword =
    Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD");

var connectionString =
    $"host={rabbitHost};username={rabbitUser};password={rabbitPassword}";

var bus =
    RabbitHutch.CreateBus(connectionString);

var options =
    new DbContextOptionsBuilder<eAnimalShelterDbContext>()
    .UseSqlServer(
        $"Server={Environment.GetEnvironmentVariable("DB_HOST")},{Environment.GetEnvironmentVariable("DB_PORT")};" +
        $"Database={Environment.GetEnvironmentVariable("DB_NAME")};" +
        $"User Id={Environment.GetEnvironmentVariable("DB_USER")};" +
        $"Password={Environment.GetEnvironmentVariable("DB_PASSWORD")};" +
        "TrustServerCertificate=true")
    .Options;

bus.PubSub.Subscribe<NotificationCreatedEvent>(
    "notification-processing",
    async message =>
    {
        try
        {
            Console.WriteLine(
                $"Notification received: {message.Title}");

            using var db =
                new eAnimalShelterDbContext(options);

            db.NotificationDeliveryLogs.Add(
                new NotificationDeliveryLog
                {
                    NotificationId = message.NotificationId,
                    UserId = message.UserId,
                    Title = message.Title,
                    Message = message.Message,
                    DeliveredAt = DateTime.UtcNow,
                    Success = true
                });

            await db.SaveChangesAsync();

            Console.WriteLine(
                $"Notification {message.NotificationId} delivered.");

            Console.WriteLine(
                $"Notification processed successfully.");

        }
        catch (Exception ex)
        {
            Console.WriteLine(
                $"ERROR: {ex.Message}");
        }
    });

Console.WriteLine("Waiting for notifications...");

await Task.Delay(Timeout.Infinite);