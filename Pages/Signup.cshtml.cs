using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Npgsql;

namespace community_db.Pages
{
    public class SignupModel : PageModel
    {
        private readonly IConfiguration _config;
        public SignupModel(IConfiguration config) => _config = config;

        public IActionResult OnPost()
        {
            var name = Request.Form["Name"];
            var email = Request.Form["Email"];

            using var conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection"));
            conn.Open();

            var cmd = new NpgsqlCommand("INSERT INTO Users (Name, Email) VALUES (@name, @email) RETURNING UserId", conn);
            cmd.Parameters.AddWithValue("name", name.ToString());
            cmd.Parameters.AddWithValue("email", email.ToString());
            var userId = (int)cmd.ExecuteScalar();

            HttpContext.Session.SetInt32("UserId", userId);
            return RedirectToPage("/Listings");
        }
    }
}
