## 🚀 Features

- User registration and login
- Create, edit, and delete listings
- Save/bookmark favorite listings
- Private messaging system
- View count tracking
- Category and location filters

---

## 🛠️ Tech Stack

- **Frontend**: ASP.NET Core Razor Pages
- **Backend**: C# with ADO.NET for database interaction
- **Database**: PostgreSQL (hosted on [Railway](https://railway.app/))
- **Deployment**: Railway + GitHub

---

## 🧩 Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/yourusername/community_db_app.git
cd community_db_app
```
### 2. Add your connection string (create or update appsettings.json)
```bash
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=your_db;Username=your_user;Password=your_pass"
  }
}
```
### 3. Import the schema and seed the data
->Make sure that PostgreSQL is running
```bash
psql "your-connection-url" -f export.sql
```
### 4. Run the app
Visit your localhost
```bash
dotnet run
```
