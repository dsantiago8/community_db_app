using community_db.Models;
using Npgsql;

namespace community_db.Services
{
    public class ListingService
    {
        private readonly string _connectionString;

        public ListingService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection");
        }

        public List<Listing> GetAllListings()
        {
            var listings = new List<Listing>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT * FROM Listings ORDER BY DatePosted DESC", conn);
            var reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                listings.Add(new Listing
                {
                    Id = reader.GetInt32(0),
                    Title = reader.GetString(1),
                    Description = reader.GetString(2),
                    Category = reader.GetString(3),
                    Location = reader.GetString(4),
                    DatePosted = reader.GetDateTime(5)
                });
            }

            return listings;
        }

        public void AddListing(Listing listing)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Listings (Title, Description, Category, Location)
                VALUES (@Title, @Description, @Category, @Location)
            ", conn);

            cmd.Parameters.AddWithValue("@Title", listing.Title);
            cmd.Parameters.AddWithValue("@Description", listing.Description);
            cmd.Parameters.AddWithValue("@Category", listing.Category);
            cmd.Parameters.AddWithValue("@Location", listing.Location);

            cmd.ExecuteNonQuery();
        }
    }
}
