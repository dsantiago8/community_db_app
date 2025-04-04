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

    // Navigation (optional for EF Core or manual joins)
    public Category? Category { get; set; }
    public Location? Location { get; set; }
    public User? Creator { get; set; }
}

}
