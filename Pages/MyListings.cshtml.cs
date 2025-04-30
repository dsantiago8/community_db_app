using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

public class MyListingsModel : PageModel
{
    private readonly ListingService _listingService;

    public MyListingsModel(ListingService listingService)
    {
        _listingService = listingService;
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
}
