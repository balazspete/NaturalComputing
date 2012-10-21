

class App
	constructor: ->
		@content = {}
		_this = this
		$.ajax(
			url: "content.json"
			dataType: "json"
			success: (data) ->
				_this.content = data

			error: (a, b, c) ->
				$(body).append("an error has occurred :/")

		)

	setup: ->
		@render()

		$("body").on 'click', "#random", (e) ->
			window.App.render()

		$("body").on 'click', "#like", (e) ->
			window.App.submit_colours(true)

		$("body").on 'click', "#dislike", (e) ->
			window.App.submit_colours(false)

	render: ->
		random_color = ->
			'#'+Math.floor(Math.random()*16777215).toString(16)

		@content.colours = [
			{type: "background",		colour: random_color()}
			{type: "font",				colour: random_color()}
			{type: "header",			colour: random_color()}
			{type: "foreground",		colour: random_color()}
		]


		html0 = window.Ziggy.render 'main', @content
		$("#main")[0].innerHTML = html0
		html1 = window.Ziggy.render 'color-picker', @content
		$("#sidebar")[0].innerHTML = html1
		html2 = window.Ziggy.render 'dummy-content', @content
		$("#body")[0].innerHTML = html2

		_this = this
		for e in $('.color-picker')
			_this.change_colour $(e).attr('data-type'), $(e).attr('data-colour')
			$(e).ColorPicker({
				color: $(e).attr('data-colour')
				livePreview: true
				onShow: (colpkr) ->
					$(colpkr).fadeIn(500)
					return false
				onHide: (colpkr) ->
					$(colpkr).fadeOut(500)
					return false

				onSubmit: (hsb, hex, rgb, el) ->
					$(el).css('background', '#' + hex)
					_this.change_colour $(el).attr('data-type'), '#' + hex

				onChange: (hsb, hex, rgb, el) ->
					$(el).css('background', '#' + hex)
					_this.change_colour $(el).attr('data-type'), '#' + hex

			}).ColorPickerSetColor($(e).attr('data-colour'))



	change_colour: (type, colour) ->
		if type is 'background'
			$("#site").css('background', colour)
		else if type is 'header'
			$("#site #header").css('background', colour)
		else if type is 'foreground'
			$("#site p").css('background', colour)
		else
			$("#site").css('color', colour)




	submit_colours: (type) ->
		data = {
			color_query_like: type
			color_query_background: $("#site").css('background-color')
			color_query_foreground: $("#site p").css('background-color')
			color_query_font: $("#site").css('color')
			color_query_header: $("#site #header").css('background-color')
		}

		$.ajax(
			url : "/save/"
			method: "POST"
			data: data
			success: (d, textStatus, jqXHR) ->
				if d == '1'
					window.App.render()

			error: (jqXHR, textStatus, errorThrown) ->




		)

class Ziggy
	constructor: ->
		@templates = get_templates()

	render: (index, object) ->
		@templates[index](object)

	get_templates = ->
		temp = []
		$.each $('script[type="text/x-handlebars-template"]'), (__, item) ->
			temp[$(item).attr('data-template')] = Handlebars.compile $(item).html()
			Handlebars.registerPartial $(item).attr('data-template'), temp[$(item).attr('data-template')]
		@templates = temp

window.Ziggy = new Ziggy()

window.App = new App()

$("#activate").on 'click', (e) ->
	window.App.setup()
