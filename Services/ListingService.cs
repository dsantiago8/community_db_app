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

        public List<Listing> SearchListings(string? userEmail, int? categoryId, int? locationId,string? title)
        {
            var listings = new List<Listing>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var query = @"
                SELECT l.ListingId, l.Title, l.Description, l.DatePosted,
                    c.Name AS CategoryName,
                    loc.Name AS LocationName,
                    u.Email AS CreatorEmail
                FROM Listings l
                JOIN Categories c ON l.CategoryId = c.CategoryId
                JOIN Locations loc ON l.LocationId = loc.LocationId
                JOIN Users u ON l.CreatorId = u.UserId
                WHERE (u.Email ILIKE @UserEmail OR @UserEmail IS NULL)
                AND (@CategoryId IS NULL OR l.CategoryId = @CategoryId)
                AND (@LocationId IS NULL OR l.LocationId = @LocationId)
                AND (@Title IS NULL OR l.Title ILIKE @Title)
                ORDER BY l.DatePosted DESC";

            var cmd = new NpgsqlCommand(query, conn);
            cmd.Parameters.Add(new NpgsqlParameter("@UserEmail", string.IsNullOrWhiteSpace(userEmail) ? DBNull.Value : $"%{userEmail}%")
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Text
            });
            cmd.Parameters.Add(new NpgsqlParameter("@CategoryId", categoryId.HasValue ? categoryId.Value : DBNull.Value)
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Integer
            });

            cmd.Parameters.Add(new NpgsqlParameter("@LocationId", locationId.HasValue ? locationId.Value : DBNull.Value)
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Integer
            });

            cmd.Parameters.Add(new NpgsqlParameter("@Title", string.IsNullOrWhiteSpace(title) ? DBNull.Value : $"%{title}%")
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Text
            });



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
                INSERT INTO Listings (Title, Description, CategoryId, LocationId, CreatorId, EventDate)
                VALUES (@Title, @Description, @CategoryId, @LocationId, @CreatorId, @EventDate)
            ", conn);

            cmd.Parameters.AddWithValue("@Title", listing.Title);
            cmd.Parameters.AddWithValue("@Description", listing.Description);
            cmd.Parameters.AddWithValue("@CategoryId", listing.CategoryId);
            cmd.Parameters.AddWithValue("@LocationId", listing.LocationId);
            cmd.Parameters.AddWithValue("@CreatorId", listing.CreatorId);
            
            cmd.Parameters.Add(new NpgsqlParameter("@EventDate", listing.EventDate ?? (object)DBNull.Value)
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Timestamp
            });


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

        public void JoinListing(int listingId, int userId)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO ListingSignups (ListingId, UserId)
                VALUES (@ListingId, @UserId)
                ON CONFLICT DO NOTHING;
            ", conn);

            cmd.Parameters.AddWithValue("@ListingId", listingId);
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.ExecuteNonQuery();
        }

        public void UnjoinListing(int listingId, int userId)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                DELETE FROM ListingSignups
                WHERE ListingId = @ListingId AND UserId = @UserId
            ", conn);

            cmd.Parameters.AddWithValue("@ListingId", listingId);
            cmd.Parameters.AddWithValue("@UserId", userId);

            cmd.ExecuteNonQuery();
        }



        public List<ListingSignup> GetSignupsForListing(int listingId)
        {
            var signups = new List<ListingSignup>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                SELECT s.SignupId, s.UserId, u.Email, s.SignupDate
                FROM ListingSignups s
                JOIN Users u ON s.UserId = u.UserId
                WHERE s.ListingId = @ListingId
            ", conn);

            cmd.Parameters.AddWithValue("@ListingId", listingId);

            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                signups.Add(new ListingSignup
                {
                    SignupId = reader.GetInt32(0),
                    UserId = reader.GetInt32(1),
                    UserEmail = reader.GetString(2),
                    SignupDate = reader.GetDateTime(3)
                });
            }

            return signups;
        }


    }
}
