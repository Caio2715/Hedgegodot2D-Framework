extends Control

signal can_change
signal error

var thread = null
var new_scene
var res
var can_change = false
var scene_to_preload
#onready var progress = $progress

const SIMULATED_DELAY_SEC_NORMAL = 1.0
var SIMULATED_DELAY_SEC = 1.0

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path, "PackedScene")
	assert(ril)
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps
#	progress.call_deferred("set_max", total)
	#print(ril.get_resource())
	res = null
	
	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread
#		progress.call_deferred("set_value", ril.get_stage())
		# Simulate a delay
		#print(ril.get_stage())
		OS.delay_msec(SIMULATED_DELAY_SEC * 100.0)
		# Poll (does a load step)
		var err = ril.poll()
		# if OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource
			res = ril.get_resource()
			can_change = true
			emit_signal('can_change')
			break
		elif err != OK:
			# Not OK, there was an error
			print("There was an error loading")
			emit_signal('error')
			break
func _thread_done(resource):
	assert(resource)
	
	# Always wait for threads to finish, this is required on Windows
	thread.wait_to_finish()
	
	#Hide the progress bar
#	progress.hide()
	
	# Instantiate new scene
	new_scene = resource.instance()
	# Free current scene
	new_scene.connect("tree_entered", get_tree(), "set_current_scene", [new_scene], CONNECT_ONESHOT)
	get_tree().get_current_scene().free()
	get_tree().get_root().add_child(new_scene)
	#print('SCENE PRELOADED!') 
	# Set as current scene
	#print(get_tree().get_current_scene().name)
	SIMULATED_DELAY_SEC = SIMULATED_DELAY_SEC_NORMAL
#	progress.visible = false
	clear_stuff()
func clear_stuff():
#	thread = null
	new_scene = null
	res = null
	can_change = false
	scene_to_preload = ""
func preload_scene(path):
	scene_to_preload = path
	can_change = false
	print(str('PRELOADING SCENE: ' + path + '...'))
	thread = Thread.new()
	thread.start( self, "_thread_load", path)
	raise() # show on top
#	progress.visible = true

func change_scene_to_preloaded():
	call_deferred("_thread_done", res)
