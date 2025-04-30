using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Npgsql;
using BCrypt.Net;

namespace community_db.Pages
{
    public class SignupModel : PageModel
    {
        private readonly IConfiguration _config;

        public SignupModel(IConfiguration config)
        {
            _config = config;
        }

        [BindProperty]
        public string Name { get; set; } = string.Empty;

        [BindProperty]
        public string Email { get; set; } = string.Empty;

        [BindProperty]
        public string Password { get; set; } = string.Empty;

        public string? ErrorMessage { get; set; }

        public void OnGet()
        {
            // No-op on GET
        }

        public IActionResult OnPost()
        {
            if (string.IsNullOrEmpty(Name) || string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(Password))
            {
                ErrorMessage = "Name, Email, and Password are required.";
                return Page();
            }

            var passwordHash = BCrypt.Net.BCrypt.HashPassword(Password);

            using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Users (Name, Email, PasswordHash) 
                VALUES (@name, @email, @passwordHash) 
                RETURNING UserId
            ", conn);

            cmd.Parameters.AddWithValue("name", Name);
            cmd.Parameters.AddWithValue("email", Email);
            cmd.Parameters.AddWithValue("passwordHash", passwordHash);

            var userId = (int)cmd.ExecuteScalar();

            HttpContext.Session.SetInt32("UserId", userId);
            HttpContext.Session.SetString("UserEmail", Email);
            HttpContext.Session.SetString("UserName", Name);

            return RedirectToPage("/Listings");
        }
    }
}
