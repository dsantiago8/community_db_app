using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;
using Npgsql;

public class MyListingsModel : PageModel
{
    private readonly ListingService _listingService;
    private readonly IConfiguration _config;

    public MyListingsModel(ListingService listingService, IConfiguration config)
    {
        _listingService = listingService;
        _config = config;
    }

    public List<Listing> MyListings { get; set; } = new();
    public List<Category> Categories { get; set; } = new();
    public List<Location> Locations { get; set; } = new();

    [BindProperty]
    public Listing EditedListing { get; set; }

    public IActionResult OnPostEdit()
    {
    if (!ModelState.IsValid) return Page();

    _listingService.UpdateListing(EditedListing);
    return RedirectToPage("/MyListings"); // or RedirectToPage("/MyListings");
    }

    public IActionResult OnGet()
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        MyListings = _listingService.GetListingsByUserId(userId.Value);
        Categories = _listingService.GetAllCategories();
        Locations = _listingService.GetAllLocations();
        return Page();
    }
    public IActionResult OnPostDelete(int id)
    {
        using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
        conn.Open();

        var cmd = new NpgsqlCommand("DELETE FROM listings WHERE listingid = @id AND creatorid = @user", conn);
        cmd.Parameters.AddWithValue("id", id);
        cmd.Parameters.AddWithValue("user", User.Identity?.Name ?? "");

        int rowsAffected = cmd.ExecuteNonQuery();

        if (rowsAffected == 0)
        {
            TempData["Error"] = "You are not authorized to delete this listing or it doesn't exist.";
        }

        return RedirectToPage();
    }

}
