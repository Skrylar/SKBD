class Jimbo : GLib.Object {
	private static Jack.Port _mein_ass;

	const uint8 MIDI_CHANNEL_MASK = 0x0F;
	const uint8 MIDI_COMMAND_MASK = 0xF0;

	enum MidiMessageType {
		NoteOff = (8 << 4),
		NoteOn = (9 << 4),
		Aftertouch = (10 << 4),
		ControlChange = (11 << 4),
		ProgramChange = (12 << 4),
		ChannelAftertouch = (13 << 4),
		PitchBend = (14 << 4),
	}

	public static int jack_process (Jack.NFrames samples) {
		// XXX taboo in a real_time thread
		void* buffer = _mein_ass.get_buffer (samples);
		var events = Jack.Midi.get_event_count (buffer);
		Jack.Midi.Event evt = {};
		for (int i = 0; i < events; i++) {
			Jack.Midi.event_get (&evt, buffer, i);
			stdout.printf("channel: %d ", evt.buffer[0] & MIDI_CHANNEL_MASK);
			switch (evt.buffer[0] & MIDI_COMMAND_MASK) {
			case MidiMessageType.NoteOn:
				stdout.printf("note on: %d velocity: %d\n", evt.buffer[1], evt.buffer[2]);
				break;
			case MidiMessageType.NoteOff:
				stdout.printf("note off: %d\n", evt.buffer[1]);
				break;
			default:
				stdout.printf("midi event\n");
				break;
			}
		}
		return 0;
	}

    public static int main(string[] args) {
		MainLoop loop = new MainLoop ();

		Jack.Status status;
		var client = Jack.Client.open ("Spoigle", Jack.Options.NoStartServer, out status);
		if (Jack.Status.Failure in status) {
			// XXX name not unique is not an error
			stderr.printf("A failure has transpired.\n");
			return 1;
		}


		_mein_ass = client.port_register ("MeinAss", Jack.DefaultMidiType, Jack.PortFlags.IsInput, 0);
		client.set_process_callback (jack_process);

		client.active = true;

		loop.run ();
        return 0;
    }
}