module main

import vweb
import net.http
import sqlite
import net.urllib

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
	current_user_id int
}

['/:code'; get]
fn (mut app App) code_get(code string) vweb.Result {
	return app.redirect('https://google.com')
}

pub fn (mut app App) before_request() {
	url := urllib.parse(app.req.url) or { panic(err) }
	if url.path.starts_with('/auth') {
		return
	}

	bearer_token := app.header.get(http.CommonHeader.authorization) or { '' }
	token := bearer_token.replace('Bearer ', '').trim(' ')

	user_id := app.get_cookie(token) or {
		app.set_status(401, "unauthenticated")
		app.send_response_to_client('text', 'not authenticated')
		return
	}
	app.current_user_id = user_id.int()

	// result := sql app.db {
	// 	select from User where id == user_id.int()
	// }
	// if result.id != user_id.int() {
	// 	app.set_status(401)
	// 	app.send_response_to_client('text', 'not authenticated')
	// 	return
	// }
}

fn main() {
	mut app := App{
		db: sqlite.connect(':memory:') or { panic(err) }
	}
	sql app.db {
		create table Link
		create table User
	}
	vweb.run_at(app, "127.0.0.1", 9091)
}
