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

            var cmd = new NpgsqlCommand(@"
                SELECT l.ListingId, l.Title, l.Description, l.DatePosted,
                    c.Name AS CategoryName,
                    loc.Name AS LocationName,
                    u.Email AS CreatorEmail
                FROM Listings l
                JOIN Categories c ON l.CategoryId = c.CategoryId
                JOIN Locations loc ON l.LocationId = loc.LocationId
                JOIN Users u ON l.CreatorId = u.UserId
                ORDER BY l.DatePosted DESC
            ", conn);
            var reader = cmd.ExecuteReader();

           while (reader.Read())
            {
                listings.Add(new Listing
                {
                    ListingId = reader.GetInt32(0),
                    Title = reader.GetString(1),
                    Description = reader.GetString(2),
                    DatePosted = reader.GetDateTime(3),
                    CategoryName = reader.GetString(4),
                    LocationName = reader.GetString(5),
                    CreatorEmail = reader.GetString(6)
                });
            }


            return listings;
        }

        public void AddListing(Listing listing)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Listings (Title, Description, CategoryId, LocationId, CreatorId)
                VALUES (@Title, @Description, @CategoryId, @LocationId, @CreatorId)
            ", conn);

            cmd.Parameters.AddWithValue("@Title", listing.Title);
            cmd.Parameters.AddWithValue("@Description", listing.Description);
            cmd.Parameters.AddWithValue("@CategoryId", listing.CategoryId);
            cmd.Parameters.AddWithValue("@LocationId", listing.LocationId);
            cmd.Parameters.AddWithValue("@CreatorId", listing.CreatorId);

            cmd.ExecuteNonQuery();
        }


        public List<Category> GetAllCategories()
        {
            var categories = new List<Category>();
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT * FROM Categories ORDER BY Name", conn);
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                categories.Add(new Category
                {
                    CategoryId = reader.GetInt32(0),
                    Name = reader.GetString(1)
                });
            }
            return categories;
        }

        public List<Location> GetAllLocations()
        {
            var locations = new List<Location>();
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT * FROM Locations ORDER BY Name", conn);
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                locations.Add(new Location
                {
                    LocationId = reader.GetInt32(0),
                    Name = reader.GetString(1)
                });
            }
            return locations;
        }


    }
}
