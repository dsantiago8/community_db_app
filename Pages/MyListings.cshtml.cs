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

        // Step 1: Get userid from email
        int? userId = null;
        using (var getUserCmd = new NpgsqlCommand("SELECT userid FROM users WHERE email = @Email", conn))
        {
            getUserCmd.Parameters.AddWithValue("Email", User.Identity?.Name ?? "");
            var result = getUserCmd.ExecuteScalar();
            userId = result != null ? (int?)result : null;
        }

        if (userId == null)
        {
            return Unauthorized(); // or redirect with error message
        }

        // Step 2: Delete the listing
        using var deleteCmd = new NpgsqlCommand("DELETE FROM listings WHERE listingid = @id AND creatorid = @userId", conn);
        deleteCmd.Parameters.AddWithValue("id", id);
        deleteCmd.Parameters.AddWithValue("userId", userId.Value);

        int rowsAffected = deleteCmd.ExecuteNonQuery();

        if (rowsAffected == 0)
        {
            return NotFound(); // listing doesn't exist or not owned by this user
        }

        return RedirectToPage("/MyListings");
    }


}
