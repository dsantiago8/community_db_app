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

    public void OnGet(string? userEmail, int? categoryId, int? locationId, string? title, DateTime? eventDate)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        Categories = _listingService.GetAllCategories();
        Locations = _listingService.GetAllLocations();
        Listings = _listingService.SearchListings(userEmail, categoryId, locationId, title, eventDate, userId);

        foreach (var listing in Listings)
        {
            listing.Signups = _listingService.GetSignupsForListing(listing.ListingId);
        }
    }

    [ValidateAntiForgeryToken]
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

    [ValidateAntiForgeryToken]
    public IActionResult OnPostJoin(int id)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        _listingService.JoinListing(id, userId.Value);
        return RedirectToPage(); // refresh page
    }

    [ValidateAntiForgeryToken]
    public IActionResult OnPostLeave(int id)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        _listingService.UnjoinListing(id, userId.Value);
        return RedirectToPage(); // refresh
    }
    public IActionResult OnPostEdit(int ListingId, string Title, string Description, DateTime? EventDate)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        var listing = _listingService.GetListingById(ListingId);
        if (listing == null || listing.CreatorId != userId) return RedirectToPage();

        listing.Title = Title;
        listing.Description = Description;
        listing.EventDate = EventDate;

        _listingService.UpdateListing(listing);
        return RedirectToPage(); // Refresh the page
    }
    public IActionResult OnPostSave(int id)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        _listingService.SaveListing(userId.Value, id);
        return RedirectToPage(); // Refresh
    }

    public IActionResult OnPostUnsave(int id)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return RedirectToPage("/Login");

        _listingService.UnsaveListing(userId.Value, id);
        return RedirectToPage(); // Refresh
    }

}
