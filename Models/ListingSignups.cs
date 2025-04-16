namespace community_db.Models
{
    public class ListingSignup
    {
        public int SignupId { get; set; }
        public int ListingId { get; set; }
        public int UserId { get; set; }
        public DateTime SignupDate { get; set; }

        // Optionally link to Listing or User
        public string? UserEmail { get; set; } // for display
    }
}
