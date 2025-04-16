namespace community_db.Models
{
    public class Listing
    {
        public int ListingId { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public int CategoryId { get; set; }
        public int LocationId { get; set; }
        public int CreatorId { get; set; }
        public DateTime DatePosted { get; set; }

        // Optional navigation propertiesSS
        public Category? Category { get; set; }
        public Location? Location { get; set; }
        public User? Creator { get; set; }

        public List<ListingSignup>? Signups { get; set; }


        // Display fields from JOINs
        public string? CategoryName { get; set; }  // for displaying from JOIN
        public string? LocationName { get; set; }  // for displaying from JOIN
        public string? CreatorEmail { get; set; }  // for displaying from JOIN


    }
}
