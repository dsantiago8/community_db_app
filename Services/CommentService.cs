using community_db.Models;
using Npgsql;

namespace community_db.Services
{
    public class CommentService
    {
        private readonly string _connectionString;

        public CommentService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection")!;
        }

        public List<Comment> GetCommentsForListing(int listingId)
        {
            var comments = new List<Comment>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                SELECT c.Content, c.CreatedAt, u.Name
                FROM Comments c
                JOIN Users u ON u.UserId = c.UserId
                WHERE c.ListingId = @listingId
                ORDER BY c.CreatedAt ASC", conn);
            cmd.Parameters.AddWithValue("listingId", listingId);

            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comments.Add(new Comment
                {
                    Content = reader.GetString(0),
                    CreatedAt = reader.GetDateTime(1),
                    UserName = reader.GetString(2)
                });
            }

            return comments;
        }

        public void AddComment(int listingId, int userId, string content)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Comments (ListingId, UserId, Content)
                VALUES (@listingId, @userId, @content)", conn);

            cmd.Parameters.AddWithValue("listingId", listingId);
            cmd.Parameters.AddWithValue("userId", userId);
            cmd.Parameters.AddWithValue("content", content);

            cmd.ExecuteNonQuery();
        }
    }
}
