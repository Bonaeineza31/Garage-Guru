$commitMessages = @(
    "Initialize project with basic folder structure and README",
    "Add initial package.json and install core dependencies",
    "Implement user authentication logic and registration endpoint",
    "Create vehicle model and add CRUD operations",
    "Set up database connection and environment configuration",
    "Add garage listing feature with search functionality",
    "Integrate booking system for garage appointments",
    "Design responsive UI for dashboard and navigation",
    "Add unit tests for authentication and booking modules",
    "Fix bug in vehicle update API and improve error handling",
    "Refactor codebase for better modularity and readability",
    "Implement email notifications for booking confirmations",
    "Add user profile editing and avatar upload support",
    "Optimize database queries for faster garage search",
    "Update documentation and add API usage examples"
)

foreach ($msg in $commitMessages) {
    git add .
    git commit -m "$msg"
}