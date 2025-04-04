using community_db.Services; // If you created a ListingService
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Load environment variables (like Railway env vars)
builder.Configuration.AddEnvironmentVariables();

//  Add ADO.NET service (if using something like ListingService)
builder.Services.AddTransient<ListingService>();
builder.Services.AddScoped<UserService>();

// Add Razor Pages
builder.Services.AddRazorPages();

// Session + HttpContextAccessor (needed for navbar user display)
builder.Services.AddHttpContextAccessor();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(1);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});


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
