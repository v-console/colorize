module colorize

fn test_color() {
	green := color('<green>Green color')
	assert green == '\033[32mGreen color'

	red := color('<red>Red color')
	assert red == '\033[31mRed color'

	bold := color('<bold>Bold style')
	assert bold == '\033[1mBold style'

	underline := color('<underline>Underline style')
	assert underline == '\033[4mUnderline style'

	bgblue := color('<!blue>Background Blue color')
	assert bgblue == '\033[44mBackground Blue color'
}
