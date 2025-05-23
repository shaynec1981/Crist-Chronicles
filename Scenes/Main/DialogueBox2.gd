extends Sprite # Acknowledged: Unusual base class for a UI element.

@onready var _name = $LabelName
@onready var _text = $LabelText
@onready var indicatorImg = $Indicator
@onready var animationPlayer = $AnimationPlayer

var textArray = []
var messageIndex = 0

func _ready():
	pass

func _displayText(name, text):
	indicatorImg.visible = true
	animationPlayer.play("indicator")
	textArray.clear() # Valid in Godot 4
	_name.text = name
	var charCount = text.length() # Valid
	var lastCharIndex
	if charCount > 230:
		var tempStringContainer = text
		var i = 0
		# Using float for division and then ceil is fine. int() cast is fine.
		var iterationsTotal = int(ceil(float(charCount) / 230.0)) 
		while i <= iterationsTotal: # Loop condition seems okay
			if i != iterationsTotal:
				lastCharIndex = tempStringContainer.findn(" ", 230) # Valid
				if lastCharIndex == -1: # If no space found after 230 chars
					# Try to find any space at all to avoid cutting mid-word if possible,
					# otherwise, cut at 230 or remaining length.
					var first_space = tempStringContainer.find(" ", 0)
					if first_space != -1 and first_space < 230 : # if a space exists before 230
						lastCharIndex = first_space
						# Check if there's a space closer to 230, to get a longer segment
						var next_space = tempStringContainer.findn(" ", 230) 
						if next_space != -1: lastCharIndex = next_space
						# if no space found up to 230, but string is longer, this is tricky.
						# The original logic would take up to the next space even if very far.
						# For now, if no space up to 230, take 230 or length.
						else: lastCharIndex = min(tempStringContainer.length(), 230)


					elif tempStringContainer.length() <= 230 : # if remaining string is short enough
						lastCharIndex = tempStringContainer.length()
					else: # String is long, no space found up to 230
						lastCharIndex = 230 # Default to hard cut if no better option
				
				textArray.append(tempStringContainer.substr(0, lastCharIndex)) # Valid
				tempStringContainer = tempStringContainer.substr(lastCharIndex + 1) # Reassign for erase behavior
			else:
				textArray.append(tempStringContainer)
			i += 1
		splitMessage()
	else: # Entire message fits in one box
		_text.text = text
		
func splitMessage():
	if messageIndex < textArray.size(): # Ensure messageIndex is valid
		_text.text = textArray[messageIndex]
		messageIndex += 1
	else: # No more messages to show from this split, or array was empty
		hide() # Assuming hide() is a method of Sprite or a custom method
		indicatorImg.visible = false
		animationPlayer.stop()
	
func processLongMessage():
	if messageIndex < textArray.size() && textArray.size() != 0: # Check if there are more parts
		splitMessage()
	else:
		messageIndex = 0
		textArray.clear() # Clear array when done
		hide() # Assuming hide() is a method of Sprite or a custom method
		indicatorImg.visible = false
		animationPlayer.stop()
