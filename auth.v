import time
import vweb
import crypto.bcrypt
import crypto.md5
import passwordvalidator
import json

struct EmailPass {
	email    string
	password string
}

fn (ep &EmailPass) validate() ? {
	mut error_msgs := []string{}
	if ep.email.len == 0 {
		error_msgs << 'no email provided'
	}
	if ep.password.len == 0 {
		error_msgs << 'no password provided'
	}
	if !ep.email.contains('@') || !ep.email.contains('.') {
		error_msgs << 'invalid email'
	}
	if error_msgs.len > 0 {
		return error(error_msgs.join(', '))
	}
}

['/auth/signin'; post]
fn (mut app App) auth_signin() vweb.Result {
		ep := json.decode(EmailPass, app.req.data) or {
		app.set_status(400, 'no request body present')
		return app.json({
			'message': 'no request body present'
		})
	}
		ep.validate() or {
		app.set_status(400, 'validation failed')
		return app.json({
			'message': err.msg
		})
	}


	users := sql app.db {
		select from User where email == email
	}
	user := users[0] or { return app.not_found() }

	bcrypt.compare_hash_and_password(ep.password.bytes(), user.password.bytes()) or {
		return app.server_error(500)
	}

	tnow := time.now()
	token := md5.hexhash(ep.email + tnow.str())
	app.set_cookie_with_expire_date(token, user.email, tnow.add(time.hour))

	return app.json({
		'token': token
	})
}

['/auth/signup'; post]
fn (mut app App) auth_signup() vweb.Result {
	ep := json.decode(EmailPass, app.req.data) or {
		app.set_status(400, 'no request body present')
		return app.json({
			'message': 'no request body present'
		})
	}
	ep.validate() or {
		app.set_status(400, 'validation failed')
		return app.json({
			'message': err.msg
		})
	}

	passwordvalidator.validate(ep.password, 70) or {
		app.set_status(400, 'weak password')
		return app.json({
			'message': err.msg
		})
	}

	encrypted_password := bcrypt.generate_from_password(ep.password.bytes(), bcrypt.default_cost) or {
		return app.server_error(500)
	}
	new_user := User{
		created_at: time.now()
		email: ep.email
		password: encrypted_password
	}
	sql app.db {
		insert new_user into User
	}
	return app.json({
		'message': 'success'
	})
}
