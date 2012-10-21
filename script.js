// Generated by CoffeeScript 1.3.3
(function() {
  var App, Ziggy;

  App = (function() {

    function App() {
      var _this;
      this.content = {};
      _this = this;
      $.ajax({
        url: "content.json",
        dataType: "json",
        success: function(data) {
          return _this.content = data;
        },
        error: function(a, b, c) {
          return $(body).append("an error has occurred :/");
        }
      });
    }

    App.prototype.setup = function() {
      this.render();
      $("body").on('click', "#random", function(e) {
        return window.App.render();
      });
      $("body").on('click', "#like", function(e) {
        return window.App.submit_colours(true);
      });
      return $("body").on('click', "#dislike", function(e) {
        return window.App.submit_colours(false);
      });
    };

    App.prototype.render = function() {
      var e, html0, html1, html2, random_color, _i, _len, _ref, _results, _this;
      random_color = function() {
        return '#' + Math.floor(Math.random() * 16777215).toString(16);
      };
      this.content.colours = [
        {
          type: "background",
          colour: random_color()
        }, {
          type: "font",
          colour: random_color()
        }, {
          type: "header",
          colour: random_color()
        }, {
          type: "foreground",
          colour: random_color()
        }
      ];
      html0 = window.Ziggy.render('main', this.content);
      $("#main")[0].innerHTML = html0;
      html1 = window.Ziggy.render('color-picker', this.content);
      $("#sidebar")[0].innerHTML = html1;
      html2 = window.Ziggy.render('dummy-content', this.content);
      $("#body")[0].innerHTML = html2;
      _this = this;
      _ref = $('.color-picker');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _this.change_colour($(e).attr('data-type'), $(e).attr('data-colour'));
        _results.push($(e).ColorPicker({
          color: $(e).attr('data-colour'),
          livePreview: true,
          onShow: function(colpkr) {
            $(colpkr).fadeIn(500);
            return false;
          },
          onHide: function(colpkr) {
            $(colpkr).fadeOut(500);
            return false;
          },
          onSubmit: function(hsb, hex, rgb, el) {
            $(el).css('background', '#' + hex);
            return _this.change_colour($(el).attr('data-type'), '#' + hex);
          },
          onChange: function(hsb, hex, rgb, el) {
            $(el).css('background', '#' + hex);
            return _this.change_colour($(el).attr('data-type'), '#' + hex);
          }
        }).ColorPickerSetColor($(e).attr('data-colour')));
      }
      return _results;
    };

    App.prototype.change_colour = function(type, colour) {
      if (type === 'background') {
        return $("#site").css('background', colour);
      } else if (type === 'header') {
        return $("#site #header").css('background', colour);
      } else if (type === 'foreground') {
        return $("#site p").css('background', colour);
      } else {
        return $("#site").css('color', colour);
      }
    };

    App.prototype.submit_colours = function(type) {
      var data;
      data = {
        color_query_like: type,
        color_query_background: $("#site").css('background-color'),
        color_query_foreground: $("#site p").css('background-color'),
        color_query_font: $("#site").css('color'),
        color_query_header: $("#site #header").css('background-color')
      };
      return $.ajax({
        url: "/save/",
        method: "POST",
        data: data,
        success: function(d, textStatus, jqXHR) {
          if (d === '1') {
            return window.App.render();
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {}
      });
    };

    return App;

  })();

  Ziggy = (function() {
    var get_templates;

    function Ziggy() {
      this.templates = get_templates();
    }

    Ziggy.prototype.render = function(index, object) {
      return this.templates[index](object);
    };

    get_templates = function() {
      var temp;
      temp = [];
      $.each($('script[type="text/x-handlebars-template"]'), function(__, item) {
        temp[$(item).attr('data-template')] = Handlebars.compile($(item).html());
        return Handlebars.registerPartial($(item).attr('data-template'), temp[$(item).attr('data-template')]);
      });
      return this.templates = temp;
    };

    return Ziggy;

  })();

  window.Ziggy = new Ziggy();

  window.App = new App();

  $("#activate").on('click', function(e) {
    return window.App.setup();
  });

}).call(this);
