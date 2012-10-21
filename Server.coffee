sys = require "sys"
my_http = require "http"
path = require "path"
url = require "url"
fs = require "fs"

mongo = require 'mongodb'
Server = mongo.Server
Db = mongo.Db

server = new Server 'localhost', 27017, {auto_reconnect: true}
db = new Db 'local', server

my_http.createServer((request,response)->
	my_path = url.parse(request.url).pathname
	if my_path is "/save/"
		url_parts = url.parse request.url, true
		query = url_parts.query

		to_save = {}
		pre_query = 'color_query_'

		to_save[k.substr(pre_query.length)] = v for k, v of query when k.indexOf(pre_query) is 0
		keys = (k for k, v of to_save)

		if keys.length > 0
			db.collection 'colours', (err, collection)->
				response.writeHeader 200, {"Content-Type" : "text/plain"}
				if not err
					collection.insert to_save
					response.write '1'
				else
					response.write '0'
		else
			response.write '0'

		response.end()
	else
		filePath = '.' + request.url
		if filePath == './'
			filePath = './index.html'

		extname = path.extname(filePath)
		contentType = 'text/html'
		if extname is '.js'
			contentType = 'text/javascript'
		else if extname is '.css'
			contentType = 'text/css'

		path.exists filePath, (exists) ->

			if exists
				fs.readFile filePath, (error, content) ->
					if error
						response.writeHead 500
						response.end()
					else
						response.writeHead 200, { 'Content-Type': contentType }
						response.end content, 'utf-8'
			else
				response.writeHead 404
				response.end()
).listen 8080


