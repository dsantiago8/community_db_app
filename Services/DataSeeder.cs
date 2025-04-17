using Npgsql;
using Bogus;
using community_db.Models;

namespace community_db.Services
{
    public class DataSeeder
    {
        private readonly string _connectionString;

        public DataSeeder(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection");
        }

        public void SeedListings(int count = 100)
        {
            var faker = new Faker("en");

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            for (int i = 0; i < count; i++)
            {
                var title = faker.Commerce.ProductName();
                var description = faker.Lorem.Paragraph();
                var categoryId = faker.Random.Int(1, 3);    // adjust based on actual categories
                var locationId = faker.Random.Int(1, 3);    // adjust based on actual locations
                var creatorId = faker.Random.Int(1, 2);     // adjust based on actual user ids

                var cmd = new NpgsqlCommand(@"
                    INSERT INTO Listings (Title, Description, CategoryId, LocationId, CreatorId)
                    VALUES (@Title, @Description, @CategoryId, @LocationId, @CreatorId)
                ", conn);

                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                cmd.Parameters.AddWithValue("@LocationId", locationId);
                cmd.Parameters.AddWithValue("@CreatorId", creatorId);

                cmd.ExecuteNonQuery();
            }

            Console.WriteLine($"{count} fake listings inserted.");
        }
    }
}
