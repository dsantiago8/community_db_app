public class Organization
{
    public int OrgId { get; set; }  // FK to User
    public string? Description { get; set; }
    public string? Website { get; set; }
}
