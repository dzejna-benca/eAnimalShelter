using EasyNetQ;
using eAnimalShelter.Model.Messages;

Console.WriteLine("Notification Subscriber started...");

var bus = RabbitHutch.CreateBus(
    "host=localhost;username=admin;password=admin");

bus.PubSub.Subscribe<NotificationCreatedEvent>(
    "notification-processing",
    async message =>
    {
        try
        {
            Console.WriteLine(
                $"Notification received: {message.Title}");

            // Simulacija pozadinske obrade
            await Task.Delay(1000);

            Console.WriteLine(
                $"Notification processed successfully.");

            Console.WriteLine(
                $"Title: {message.Title}");

            Console.WriteLine(
                $"Message: {message.Message}");
        }
        catch (Exception ex)
        {
            Console.WriteLine(
                $"ERROR: {ex.Message}");
        }
    });

Console.WriteLine("Waiting for notifications...");
Console.ReadKey();