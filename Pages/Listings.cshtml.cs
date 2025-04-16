using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

public class ListingsModel : PageModel
{
    public List<Category> Categories { get; set; } = new();
    public List<Location> Locations { get; set; } = new();

    private readonly ListingService _listingService;

    public ListingsModel(ListingService listingService)
    {
        _listingService = listingService;
    }

    public List<Listing> Listings { get; set; } = new();


    [BindProperty]
    public Listing NewListing { get; set; }

    public void OnGet(string? userEmail, int? categoryId, int? locationId, string? title)
    {
        Categories = _listingService.GetAllCategories();
        Locations = _listingService.GetAllLocations();
        Listings = _listingService.SearchListings(userEmail, categoryId, locationId, title);
    }


    public IActionResult OnPost()
    {
        if (!ModelState.IsValid)
        {
            Categories = _listingService.GetAllCategories();
            Locations = _listingService.GetAllLocations();
            return Page();
        }

        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        NewListing.CreatorId = userId.Value; // Insert user from session

        _listingService.AddListing(NewListing);
        return RedirectToPage();
    }


}
