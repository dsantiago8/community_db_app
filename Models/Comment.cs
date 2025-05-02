namespace community_db.Models
{
    public class Comment
    {
        public int CommentId { get; set; }
        public int ListingId { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }

        // Optional: for displaying the comment author
        public string UserName { get; set; } = string.Empty;
    }
}
