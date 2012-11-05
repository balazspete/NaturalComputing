require 'json'


class Colour
	attr_reader :red, :green, :blue
	def initialize c
		parse c
	end
	def binary
		"0#{i_to_b(@red.to_i, 256)}0#{i_to_b(@green.to_i, 256)}0#{i_to_b(@blue.to_i, 256)}"
	end
	def to_s
		"#{@red}:#{@green}:#{@blue}"
	end
	private
	def parse c
		@red = @green = @blue = 0
		if c != nil
			if c[0, 1] == '#'
				k = c[1,c.length].scan(/.{1,2}/)
				@red = k[0].to_i 16
				@green = k[1].to_i 16
				@blue = k[2].to_i 16
			elsif c[0, 3] == 'rgb'
				@red, @green, @blue = c.scan(/[0-9]*/).reject {|e| e.length == 0}
			end
		end
	end
	def i_to_b x, y
		z = x % (y/2)
		if y==2
			return ''
		end
		if x.to_f/(y/2) > 1
			return "1#{i_to_b(z, y/2)}"
		else
			return "0#{i_to_b(z, y/2)}"
		end
	end
end
class Entry
	attr_reader :background, :foreground, :header, :font, :like
	def initialize background, foreground, header, font, like
		@background = Colour.new background
		@foreground = Colour.new foreground
		@header = Colour.new header
		@font = Colour.new font
		@like = like == "true" ? true : false
	end
	def binary
		"#{@background.binary}#{@foreground.binary}#{@header.binary}#{@font.binary}#{@like ? '1' : '0'}"
	end
	def to_s
		"#{@background}:#{@foreground}:#{@header}:#{@font}:#{@like ? '1' : '0'}"
	end
end
class Parser
	def initialize in_file, out_file
		@entries = []
		read_file in_file
		write_file out_file
	end
	private
	def read_file in_file
		file = File.new(in_file, "r")
		while (line = file.gets)
			if line != nil and line.length > 0
			    e = JSON.parse line
			    @entries.push Entry.new e["background"], e["foreground"], e["header"], e["font"], e["like"]
			end
		end
		file.close
	end
	def write_file out_file
		File.open(out_file, 'w') do |file|
			@entries.each do |entry|
				file.write "#{entry.binary}\n"
			end
		end
	end
end

Parser.new 'colours2.json', 'output2'