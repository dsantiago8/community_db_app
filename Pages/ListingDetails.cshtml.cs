using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

namespace community_db.Pages
{
    public class ListingDetailsModel : PageModel
    {
        private readonly ListingService _listingService;
        private readonly CommentService _commentService;
        private readonly MessageService _messageService;


        public ListingDetailsModel(ListingService listingService, CommentService commentService, MessageService messageService)
        {
            _listingService = listingService;
            _commentService = commentService;
            _messageService = messageService;

        }

        public Listing? CurrentListing { get; set; }
        public List<Comment> Comments { get; set; } = new();

        [BindProperty]
        public string NewComment { get; set; } = string.Empty;

        [BindProperty]
        public string MessageContent { get; set; } = string.Empty;

        public IActionResult OnPostSendMessage(int id)
        {
            var senderId = HttpContext.Session.GetInt32("UserId");
            if (senderId == null) return RedirectToPage("/Login");

            var listing = _listingService.GetListingById(id);
            if (listing == null || listing.CreatorId == senderId) return RedirectToPage(new { id });

            var receiverId = listing.CreatorId;

            _messageService.SendMessage(new Message
            {
                SenderId = senderId.Value,
                ReceiverId = receiverId,
                ListingId = id,
                Content = MessageContent
            });

            TempData["SuccessMessage"] = "Message sent!";
            return RedirectToPage(new { id });
        }

        public IActionResult OnGet(int id)
        {
            CurrentListing = _listingService.GetListingById(id);
            if (CurrentListing == null)
                return NotFound();

            Comments = _commentService.GetCommentsForListing(id);
            _listingService.IncrementViewCount(id);

            return Page();
        }

        public IActionResult OnPostAddComment(int id)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
                return RedirectToPage("/Login");

            if (!string.IsNullOrWhiteSpace(NewComment))
            {
                _commentService.AddComment(id, userId.Value, NewComment);
            }

            return RedirectToPage(new { id });
        }
    }
}
