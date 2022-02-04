// import vweb
import time

struct User {
	id         int       [primary; sql: serial]
	created_at time.Time
	updated_at time.Time
	email      string
	password   string
	name       string
	links      int
	is_banned  bool
}

// ['/users/:user_id'; get]
// fn (mut app App) user_get(user_id int) vweb.Result {
// }

// ['/users/:user_id'; patch]
// fn (mut app App) user_update(user_id int) vweb.Result {
// }

// ['/users/:user_id'; delete]
// fn (mut app App) user_delete(user_id int) vweb.Result {
// }

// // Admin

// ['/admin/users'; get]
// fn (mut app App) users_get() vweb.Result {
// }

// ['/admin/users'; post]
// fn (mut app App) users_add() vweb.Result {
// }
