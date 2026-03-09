extends Parallax2D

#scroll parallax to the left
func start() -> void:
	autoscroll = Vector2(-160 ,0)

#stop scroll
func stop() -> void:
	autoscroll = Vector2(0 ,0)
