using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

public class ListingsModel : PageModel
{
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
    }

    public IActionResult OnPost()
    {
        if (!ModelState.IsValid) return Page();

        _listingService.AddListing(NewListing);
        return RedirectToPage();
    }
}
