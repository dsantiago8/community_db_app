using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Npgsql;
using System.Data;

namespace community_db.Pages
{
    public class LoginModel : PageModel
    {
        private readonly IConfiguration _config;
        private readonly string _connectionString;

        public LoginModel(IConfiguration config)
        {
            _config = config;
            _connectionString = _config.GetConnectionString("DefaultConnection");
        }

        [BindProperty]
        public string Email { get; set; }

        public string ErrorMessage { get; set; }

        public IActionResult OnPost()
        {
            if (string.IsNullOrWhiteSpace(Email))
            {
                ErrorMessage = "Email is required.";
                return Page();
            }

            bool userExists = false;

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT COUNT(*) FROM users WHERE email = @Email", conn);
            cmd.Parameters.AddWithValue("Email", Email);

            var count = (long)cmd.ExecuteScalar();
            userExists = count > 0;

            if (!userExists)
            {
                ErrorMessage = "No account found with that email.";
                return Page();
            }

            // Login successful, set session
            HttpContext.Session.SetString("UserEmail", Email);
            return RedirectToPage("/Listings");
        }
    }
}
