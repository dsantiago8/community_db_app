using community_db.Services; // If you created a ListingService
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Load environment variables (like Railway env vars)
builder.Configuration.AddEnvironmentVariables();

//  Add ADO.NET service (if using something like ListingService)
builder.Services.AddTransient<ListingService>();

// Add Razor Pages
builder.Services.AddRazorPages();


builder.Services.AddSession();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseSession();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
