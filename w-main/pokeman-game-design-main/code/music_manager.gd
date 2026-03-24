extends AudioStreamPlayer

func play_music(music_path: String):
	# Don't restart the song if it's already playing
	if stream and stream.resource_path == music_path:
		return
		
	var new_track = load(music_path)
	if new_track:
		stream = new_track
		play()
