module colorize

import regex

struct AnsiColorCode {
	text       string
	background string
}

interface Colorizer {
	colors map[string]AnsiColorCode
	color(string) string
}

struct Colorize {
	colors map[string]AnsiColorCode
	reset  string
}

fn new() Colorizer {
	color_codes := {
		// Text colors
		'red':          AnsiColorCode{
			text: '\x1b[31m'
			background: '\x1b[41m'
		}
		'green':        AnsiColorCode{
			text: '\x1b[32m'
			background: '\x1b[42m'
		}
		'yellow':       AnsiColorCode{
			text: '\x1b[33m'
			background: '\x1b[43m'
		}
		'blue':         AnsiColorCode{
			text: '\x1b[34m'
			background: '\x1b[44m'
		}
		'purple':       AnsiColorCode{
			text: '\x1b[35m'
			background: '\x1b[45m'
		}
		'cyan':         AnsiColorCode{
			text: '\x1b[36m'
			background: '\x1b[46m'
		}
		'white':        AnsiColorCode{
			text: '\x1b[37m'
			background: '\x1b[47m'
		}
		'black':        AnsiColorCode{
			text: '\x1b[30m'
			background: '\x1b[40m'
		}
		'dark_gray':    AnsiColorCode{
			text: '\x1b[90m'
			background: '\x1b[100m'
		}
		'light_red':    AnsiColorCode{
			text: '\x1b[91m'
			background: '\x1b[101m'
		}
		'light_green':  AnsiColorCode{
			text: '\x1b[92m'
			background: '\x1b[102m'
		}
		'light_yellow': AnsiColorCode{
			text: '\x1b[93m'
			background: '\x1b[103m'
		}
		'light_blue':   AnsiColorCode{
			text: '\x1b[94m'
			background: '\x1b[104m'
		}
		'light_purple': AnsiColorCode{
			text: '\x1b[95m'
			background: '\x1b[105m'
		}
		'light_cyan':   AnsiColorCode{
			text: '\x1b[96m'
			background: '\x1b[106m'
		}
		'light_white':  AnsiColorCode{
			text: '\x1b[97m'
			background: '\x1b[107m'
		}
		// styles bold, dim, italic, underline, blink_slow, blink_fast, inverse, hidden
		'bold':         AnsiColorCode{
			text: '\x1b[1m'
		}
		'dim':          AnsiColorCode{
			text: '\x1b[2m'
		}
		'italic':       AnsiColorCode{
			text: '\x1b[3m'
		}
		'underline':    AnsiColorCode{
			text: '\x1b[4m'
		}
		'blink_slow':   AnsiColorCode{
			text: '\x1b[5m'
		}
		'blink_fast':   AnsiColorCode{
			text: '\x1b[6m'
		}
		'inverse':      AnsiColorCode{
			text: '\x1b[7m'
		}
		'hidden':       AnsiColorCode{
			text: '\x1b[8m'
		}
	}
	reset := '\x1b[0m'

	return Colorize{
		colors: color_codes
		reset: reset
	}
}

fn (c Colorize) color(s string) string {
	mut result := s

	pattern := r'<!?([a-zA-Z]+)>'
	mut re := regex.new()
	re.compile_opt(pattern) or { return result }

	matches := re.find_all_str(result)

	for m in matches {
		color_key := if m.starts_with('<!') {
			m[2..m.len - 1]
		} else {
			m[1..m.len - 1]
		}

		if color_key.len == 0 {
			continue
		}

		color_code := c.colors[color_key] or { continue }
		if m.starts_with('<!') {
			result = result.replace(m, color_code.background)
		} else {
			result = result.replace(m, color_code.text)
		}
	}

	// Remplacer tous les tags de réinitialisation
	result = result.replace('<stop>', c.reset)

	return result
}

// color apply the color to the string.
//
// - `<color>` to change the text color,
// - `<!color>` to change the background color,
// - `<stop>` to reset the color,
//
// Usage:
// ```
// colorize.color("Hello <red>World<stop>!")
// ```
//
pub fn color(s string) string {
	c := new()
	return c.color(s)
}

pub fn print(s string) {
	c := new()
	print(c.color(s))
}

pub fn println(s string) {
	c := new()
	println(c.color(s))
}
