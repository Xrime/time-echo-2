extends Node

@onready var question_label: Label = $QuestionLabel
@onready var answer_input: LineEdit = $AnswerInput
@onready var http: HTTPRequest = $HTTPRequest

const API_KEY: String = "sk-hc-v1-10d1cb0d029a438b8d764d4e04bb1396b7830f8a621840308e9b7da34c36af34"

var current_question: String = ""
var mode: String = "ask" 


func _ready() -> void:
	http.request_completed.connect(_on_request_completed)
	answer_input.text_submitted.connect(_on_answer_submitted)
	ask_ai_question()


func ask_ai_question() -> void:
	mode = "ask"
	answer_input.text = ""
	question_label.text = "Thinking..."

	var body: Dictionary = {
		"model": "qwen/qwen3-32b",
		"messages": [
			{
				"role": "system",
				"content": "You are a game master. Ask ONE short question a player can answer in a word or short sentence."
			}
		]
	}

	_send_request(body)

# --------------------------------------------------
# 2️⃣ PLAYER SUBMITS ANSWER
# --------------------------------------------------
func _on_answer_submitted(text: String) -> void:
	if text.strip_edges() == "":
		return

	mode = "check"

	var body: Dictionary = {
		"model": "qwen/qwen3-32b",
		"messages": [
			{
				"role": "system",
				"content": "Reply ONLY with 'correct' or 'wrong'."
			},
			{
				"role": "user",
				"content": "Question: %s\nPlayer answer: %s" % [current_question, text]
			}
		]
	}

	_send_request(body)

func _send_request(body: Dictionary) -> void:
	var headers: PackedStringArray = PackedStringArray([
		"Authorization: Bearer " + API_KEY,
		"Content-Type: application/json"
	])

	http.request(
		"https://ai.hackclub.com/proxy/v1/chat/completions",
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)


func _on_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	if response_code != 200:
		question_label.text = "AI Error"
		return

	var json_text: String = body.get_string_from_utf8()
	var data: Dictionary = JSON.parse_string(json_text)

	if not data.has("choices"):
		question_label.text = "Bad AI response"
		return

	var reply: String = data["choices"][0]["message"]["content"].strip_edges()

	if mode == "ask":
		current_question = reply
		question_label.text = reply

	elif mode == "check":
		if reply.to_lower() == "wrong":
			question_label.text = "Wrong ❌"
			Global.deduct_steps(1)
		else:
			question_label.text = "Correct ✅"

		await get_tree().create_timer(1.0).timeout

		if Global.steps == 0:
			print("TIME ECHO TRIGGER")
			Global.reset_steps(5)

		ask_ai_question()
