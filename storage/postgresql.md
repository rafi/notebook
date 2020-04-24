# PostgreSQL

## Read-only Access

```sql
CREATE ROLE readonly WITH LOGIN ENCRYPTED PASSWORD 'strongpassword';

-- Grant access to existing tables
GRANT CONNECT ON DATABASE mydatabase TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;

-- Create a final user with password
CREATE USER stam WITH PASSWORD 'secret';
GRANT readonly TO stam;
```
