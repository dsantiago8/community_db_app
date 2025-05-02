using community_db.Models;
using Npgsql;

namespace community_db.Services
{
    public class MessageService
    {
        private readonly string _connectionString;

        public MessageService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection")!;
        }

        public void SendMessage(Message msg)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Messages (SenderId, ReceiverId, ListingId, Content)
                VALUES (@senderId, @receiverId, @listingId, @content)
            ", conn);

            cmd.Parameters.AddWithValue("senderId", msg.SenderId);
            cmd.Parameters.AddWithValue("receiverId", msg.ReceiverId);
            cmd.Parameters.AddWithValue("listingId", msg.ListingId);
            cmd.Parameters.AddWithValue("content", msg.Content);
            cmd.ExecuteNonQuery();
        }
        public List<Message> GetMessagesForUser(int userId)
        {
            var messages = new List<Message>();

            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                SELECT m.MessageId, m.SenderId, u.Email AS SenderEmail,
                    m.ListingId, l.Title AS ListingTitle,
                    m.Content, m.SentAt
                FROM Messages m
                JOIN Users u ON m.SenderId = u.UserId
                JOIN Listings l ON m.ListingId = l.ListingId
                WHERE m.ReceiverId = @userId
                ORDER BY m.SentAt DESC", conn);

            cmd.Parameters.AddWithValue("userId", userId);

            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                messages.Add(new Message
                {
                    MessageId = reader.GetInt32(0),
                    SenderId = reader.GetInt32(1),
                    SenderEmail = reader.GetString(2),
                    ListingId = reader.GetInt32(3),
                    ListingTitle = reader.GetString(4),
                    Content = reader.GetString(5),
                    SentAt = reader.GetDateTime(6)
                });
            }

            return messages;
        }
        public void DeleteMessage(int messageId, int userId)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                DELETE FROM Messages
                WHERE MessageId = @id AND ReceiverId = @userId", conn);

            cmd.Parameters.AddWithValue("id", messageId);
            cmd.Parameters.AddWithValue("userId", userId);
            cmd.ExecuteNonQuery();
        }

        
    }
}
