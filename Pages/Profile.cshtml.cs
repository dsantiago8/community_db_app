using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Npgsql;

namespace community_db.Pages
{
    public class ProfileModel : PageModel
    {
        private readonly IConfiguration _config;

        public ProfileModel(IConfiguration config)
        {
            _config = config;
        }

        [BindProperty]
        public string Name { get; set; } = string.Empty;

        [BindProperty]
        public string Email { get; set; } = string.Empty;

        public string? SuccessMessage { get; set; }
        public string? ErrorMessage { get; set; }

        public void OnGet()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
            {
                ErrorMessage = "You must be logged in to view your profile.";
                return;
            }

            using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT Name, Email FROM Users WHERE UserId = @id", conn);
            cmd.Parameters.AddWithValue("id", userId.Value);

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                Name = reader.GetString(0);
                Email = reader.GetString(1);
            }
        }

        public IActionResult OnPost()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
            {
                ErrorMessage = "You must be logged in to update your profile.";
                return Page();
            }

            if (string.IsNullOrEmpty(Name) || string.IsNullOrEmpty(Email))
            {
                ErrorMessage = "Name and Email cannot be empty.";
                return Page();
            }

            using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            conn.Open();

            var cmd = new NpgsqlCommand(
                "UPDATE Users SET Name = @name, Email = @Email WHERE UserId = @id", conn);
            cmd.Parameters.AddWithValue("name", Name);
            cmd.Parameters.AddWithValue("email", Email);
            cmd.Parameters.AddWithValue("id", userId.Value);
            cmd.ExecuteNonQuery();

            // Update session
            HttpContext.Session.SetString("UserName", Name);
            HttpContext.Session.SetString("UserEmail", Email);

            SuccessMessage = "Profile updated successfully.";
            return Page();
        }
        public IActionResult OnPostLogout()
        {
            HttpContext.Session.Clear();
            return RedirectToPage("/Login");
        }

    }
}
