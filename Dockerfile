FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR	/src

COPY BlazorAzureTest/BlazorAzureTest.csproj BlazorAzureTest/
RUN dotnet restore BlazorAzureTest/BlazorAzureTest.csproj

COPY . .
WORKDIR /src/BlazorAzureTest
RUN dotnet build BlazorAzureTest.csproj -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish BlazorAzureTest.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8443
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorAzureTest.dll"]