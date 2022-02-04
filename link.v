// import vweb
import time

struct Link {
		id int [primary; sql: serial]
	created_at time.Time
	updated_at time.Time
	user_id int
	url_id  int
	code    string
	hash    string
}


// ['/links'; get]
// fn (mut app App) links_get(user_id int, page int, page_size int) vweb.Result {
// 	result := sql app.db {
// 		select from Link where user_id == user_id order by id limit page_size offset page_size * page
// 	}
// 	return app.json(result)
// }

// ['/users/:user_id/links'; post]
// fn (mut app App) links_add(user_id int) vweb.Result {

// }

// ['/users/:user_id/links/:linkid'; get]
// fn (mut app App) link_get(user_id int, link_id int) vweb.Result {

// }

// ['/users/:user_id/links/:linkid'; patch]
// fn (mut app App) link_update(user_id int, link_id int) vweb.Result {

// }

// ['/users/:user_id/links/:linkid'; delete]
// fn (mut app App) link_delete(user_id int, link_id int) vweb.Result {

// }