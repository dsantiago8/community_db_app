using community_db.Models;
using Npgsql;
using BCrypt.Net;

namespace community_db.Services
{
    public class UserService
    {
        private readonly string _connectionString;

        public UserService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection");
        }

        public User? GetUserByEmail(string email)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT * FROM Users WHERE Email = @Email", conn);
            cmd.Parameters.AddWithValue("@Email", email);

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                return new User
                {
                    UserId = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    Email = reader.GetString(2),
                    IsOrganization = reader.GetBoolean(3),
                    CreatedAt = reader.GetDateTime(4)
                };
            }

            return null;
        }

        public void CreateUser(string email, string name, string password)
        {
            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);
            
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand(@"
                INSERT INTO Users (Email, Name, PasswordHash)
                VALUES (@Email, @Name, @PasswordHash)
            ", conn);

            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);

            cmd.ExecuteNonQuery();
        }


        public User? ValidateUser(string email, string password)
        {
            using var conn = new NpgsqlConnection(_connectionString);
            conn.Open();

            var cmd = new NpgsqlCommand("SELECT UserId, Name, Email, PasswordHash FROM Users WHERE Email = @Email", conn);
            cmd.Parameters.AddWithValue("@Email", email);

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                var storedHash = reader.GetString(3);
                if (BCrypt.Net.BCrypt.Verify(password, storedHash))
                {
                    return new User
                    {
                        UserId = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Email = reader.GetString(2),
                        PasswordHash = storedHash
                    };
                }
            }
            return null;
        }

    }
}
