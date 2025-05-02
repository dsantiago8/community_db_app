namespace community_db.Models
{
    public class Message
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public int ReceiverId { get; set; }
        public int ListingId { get; set; }
        public string Content { get; set; } = string.Empty;
        public DateTime SentAt { get; set; }
        public string? ListingTitle { get; set; }


        // Optional helper display fields
        public string? SenderEmail { get; set; }
        public string? ReceiverEmail { get; set; }
    }
}
