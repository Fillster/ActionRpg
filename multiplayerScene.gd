extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func player_connected(id):
	print("player connected " + str(id))

func player_disconnected(id):
	print("player disconnected " + str(id))

#EMITTED ON CLIENT
func connected_to_server():
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

#@rpc("any_peer","call_local")
#EMITTED ON CLIENT
func connection_failed(id):
	print("connection failed", id)

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)


@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://World.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()


func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	pass
	
func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass

func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.
