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

        public List<Listing> SearchListings(string? userEmail, int? categoryId, int? locationId,string? title, DateTime? eventDate)
        {
            var listings = new List<Listing>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var query = @"
                SELECT l.ListingId, l.Title, l.Description, l.DatePosted, l.EventDate,
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
                AND (@EventDate IS NULL OR l.EventDate::date = @EventDate::date)
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

            cmd.Parameters.Add(new NpgsqlParameter("@EventDate", eventDate.HasValue ? eventDate.Value : DBNull.Value)
            {
                NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Date
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
                    EventDate = reader.IsDBNull(4) ? null : reader.GetDateTime(4),
                    CategoryName = reader.GetString(5),
                    LocationName = reader.GetString(6),
                    CreatorEmail = reader.GetString(7)
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

        public List<Listing> GetListingsByUserId(int userId)
        {
            var listings = new List<Listing>();
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                SELECT l.ListingId, l.Title, l.Description, l.DatePosted, l.EventDate,
                    l.CategoryId, l.LocationId,
                    c.Name AS CategoryName,
                    loc.Name AS LocationName,
                    u.Email AS CreatorEmail
                FROM Listings l
                JOIN Categories c ON l.CategoryId = c.CategoryId
                JOIN Locations loc ON l.LocationId = loc.LocationId
                JOIN Users u ON l.CreatorId = u.UserId
                WHERE l.CreatorId = @UserId
                ORDER BY l.DatePosted DESC
            ", conn);

            cmd.Parameters.AddWithValue("@UserId", userId);

            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                listings.Add(new Listing
                {
                    ListingId = reader.GetInt32(0),
                    Title = reader.GetString(1),
                    Description = reader.GetString(2),
                    DatePosted = reader.GetDateTime(3),
                    EventDate = reader.IsDBNull(4) ? null : reader.GetDateTime(4),
                    CategoryId = reader.GetInt32(5), 
                    LocationId = reader.GetInt32(6), 
                    CategoryName = reader.GetString(7),
                    LocationName = reader.GetString(8),
                    CreatorEmail = reader.GetString(9)
                });
            }

            return listings;
        }

        public Listing GetListingById(int listingId)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                SELECT ListingId, Title, Description, CategoryId, LocationId, CreatorId, DatePosted, EventDate
                FROM Listings
                WHERE ListingId = @ListingId
            ", conn);
            cmd.Parameters.AddWithValue("@ListingId", listingId);

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                return new Listing
                {
                    ListingId = reader.GetInt32(0),
                    Title = reader.GetString(1),
                    Description = reader.GetString(2),
                    CategoryId = reader.GetInt32(3),
                    LocationId = reader.GetInt32(4),
                    CreatorId = reader.GetInt32(5),
                    DatePosted = reader.GetDateTime(6),
                    EventDate = reader.IsDBNull(7) ? null : reader.GetDateTime(7)
                };
            }

            return null;
        }

        public void UpdateListing(Listing listing)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                UPDATE Listings
                SET Title = @Title,
                    Description = @Description,
                    CategoryId = @CategoryId,
                    LocationId = @LocationId,
                    EventDate = @EventDate
                WHERE ListingId = @ListingId", conn);

            cmd.Parameters.AddWithValue("@Title", listing.Title);
            cmd.Parameters.AddWithValue("@Description", listing.Description);
            cmd.Parameters.AddWithValue("@CategoryId", listing.CategoryId);
            cmd.Parameters.AddWithValue("@LocationId", listing.LocationId);
            cmd.Parameters.AddWithValue("@ListingId", listing.ListingId);
            cmd.Parameters.AddWithValue("@EventDate", listing.EventDate ?? (object)DBNull.Value);

            cmd.ExecuteNonQuery();
        }

    }
}
