FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["community_db.csproj", "./"]
RUN dotnet restore "./community_db.csproj"
COPY . .
RUN dotnet build "community_db.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "community_db.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "community_db.dll"]
