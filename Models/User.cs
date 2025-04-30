public class User
{
    public int UserId { get; set; }
    public string Name { get; set; } = null!;
    public string Email { get; set; } = null!;
    public bool IsOrganization { get; set; } = false;
    public DateTime CreatedAt { get; set; }
    public string PasswordHash { get; set; } = string.Empty;

    //create a message symtem between users
}
