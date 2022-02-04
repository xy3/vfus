import time

struct Url {
	id         int       [primary; sql: serial]
	created_at time.Time
	updated_at time.Time
	url        string
	hash       string
	hostname   string
}
