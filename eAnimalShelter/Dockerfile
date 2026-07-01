FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app

EXPOSE 5036

ENV ASPNETCORE_URLS=http://+:5036
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore "eAnimalShelter.WebAPI/eAnimalShelter.WebAPI.csproj"

RUN dotnet publish "eAnimalShelter.WebAPI/eAnimalShelter.WebAPI.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

FROM base AS final
WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "eAnimalShelter.WebAPI.dll"]