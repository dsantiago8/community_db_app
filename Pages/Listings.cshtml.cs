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

    public void OnGet()
    {
        Listings = _listingService.GetAllListings();
        Categories = _listingService.GetAllCategories();
        Locations = _listingService.GetAllLocations();
    }


    public IActionResult OnPost()
    {
        if (!ModelState.IsValid)
        {
            Categories = _listingService.GetAllCategories();
            Locations = _listingService.GetAllLocations();
            return Page();
        }

        // Grab current user from session
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Signup"); // or show error

        NewListing.CreatorId = userId.Value;
        _listingService.AddListing(NewListing);
        return RedirectToPage();
    }

}
