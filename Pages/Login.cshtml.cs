using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Npgsql;
using BCrypt.Net;

namespace community_db.Pages
{
    public class LoginModel : PageModel
    {
        private readonly IConfiguration _config;
        public string? ErrorMessage { get; set; }
        [BindProperty]
        public string Email { get; set; } = "";
        [BindProperty]
        public string Password { get; set; } = "";

        public LoginModel(IConfiguration config)
        {
            _config = config;
        }

        public IActionResult OnPost()
        {
            if (string.IsNullOrWhiteSpace(Email) || string.IsNullOrWhiteSpace(Password))
            {
                ErrorMessage = "Email and Password are required.";
                return Page();
            }

            using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT UserId, PasswordHash FROM Users WHERE Email = @Email", conn);
            cmd.Parameters.AddWithValue("Email", Email);

            using var reader = cmd.ExecuteReader();
            if (!reader.Read())
            {
                ErrorMessage = "No user found with that email.";
                return Page();
            }

            int userId = reader.GetInt32(0);
            string storedHash = reader.GetString(1);

            // Now verify the password
            bool isPasswordValid = BCrypt.Net.BCrypt.Verify(Password, storedHash);

            if (!isPasswordValid)
            {
                ErrorMessage = "Incorrect password.";
                return Page();
            }

            // Password verified - create session
            HttpContext.Session.SetInt32("UserId", userId);
            return RedirectToPage("/Listings");
        }
    }
}
