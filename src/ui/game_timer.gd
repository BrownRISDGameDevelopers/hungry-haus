extends Label

class_name GameTimer

static var inst : GameTimer

@onready var timer: Timer = $Timer

const MINS = 60.0

func _ready() -> void:
	inst = self
	#timer.start(MINS * ROOM_TO_TIME_DICT[GlobalState.current_room])
	GlobalState.switched_room.connect(reset_time_for_room)

func start():
	restart()

func stop():
	timer.stop()
	hide()

const ROOM_TO_TIME_DICT : Dictionary[Room.Type, float] = {
	Room.Type.KITCHEN : 4.0,
	Room.Type.BEDROOM : 4.0,
	Room.Type.BATHROOM : 4.0,
}


func reset_time_for_room(room_type : Room.Type):
	var time = ROOM_TO_TIME_DICT[room_type]
	timer.start(time * MINS)

func restart():
	reset_time_for_room(GlobalState.current_room)
	show()

func _process(delta: float) -> void:
	var mins = floori(timer.time_left / MINS)
	var secs = ceili(fmod(timer.time_left, MINS))
	text = str(mins).pad_zeros(1) + ":" + str(secs).pad_zeros(2)

func _on_timer_timeout() -> void:
	hide()
	GlobalState.lose()
