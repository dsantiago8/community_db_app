using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

namespace community_db.Pages
{
    public class InboxModel : PageModel
    {
        private readonly MessageService _messageService;

        public InboxModel(MessageService messageService)
        {
            _messageService = messageService;
        }

        public List<Message> Messages { get; set; } = new();

        [BindProperty]
        public string ReplyContent { get; set; } = string.Empty;

        public IActionResult OnPostReply(int id, int senderId, int listingId)
        {
            var receiverId = HttpContext.Session.GetInt32("UserId");
            if (receiverId == null) return RedirectToPage("/Login");

            _messageService.SendMessage(new Message
            {
                SenderId = receiverId.Value,
                ReceiverId = senderId,
                ListingId = listingId,
                Content = ReplyContent
            });

            TempData["ReplySuccess"] = "Message sent.";
            return RedirectToPage();
        }

        public IActionResult OnPostDelete(int id)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToPage("/Login");

            _messageService.DeleteMessage(id, userId.Value);
            TempData["DeleteSuccess"] = "Message deleted.";
            return RedirectToPage();
        }

        public IActionResult OnGet()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
                return RedirectToPage("/Login");

            Messages = _messageService.GetMessagesForUser(userId.Value);
            return Page();
        }
    }
}
