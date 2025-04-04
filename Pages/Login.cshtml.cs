using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using community_db.Models;
using community_db.Services;

namespace community_db.Pages
{
    public class LoginModel : PageModel
    {
        private readonly UserService _userService;

        public LoginModel(UserService userService)
        {
            _userService = userService;
        }

        [BindProperty]
        public string Email { get; set; } = string.Empty;

        public string? ErrorMessage { get; set; }

        public void OnGet()
        {
            // No-op on GET for now
        }

        public IActionResult OnPost()
        {
            if (string.IsNullOrEmpty(Email))
            {
                ErrorMessage = "Email is required.";
                return Page();
            }

            // Define the 'user' variable inside this method
            var user = _userService.GetUserByEmail(Email);
            if (user == null)
            {
                ErrorMessage = "No user found with that email.";
                return Page();
            }

            // store user data in session
            HttpContext.Session.SetInt32("UserId", user.UserId);
            HttpContext.Session.SetString("UserEmail", user.Email);
            HttpContext.Session.SetString("UserName", user.Name ?? "");

            return RedirectToPage("/Listings");
        }
    }
}