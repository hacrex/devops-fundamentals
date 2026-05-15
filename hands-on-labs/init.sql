-- Initialize database schema
CREATE TABLE IF NOT EXISTS visits (
    id SERIAL PRIMARY KEY,
    visited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT
);

-- Insert sample data
INSERT INTO visits (visited_at) VALUES 
    (NOW() - INTERVAL '1 day'),
    (NOW() - INTERVAL '2 days'),
    (NOW() - INTERVAL '3 days');

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_visits_visited_at ON visits(visited_at);

GRANT ALL PRIVILEGES ON TABLE visits TO postgres;
GRANT USAGE, SELECT ON SEQUENCE visits_id_seq TO postgres;
