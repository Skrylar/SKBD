
class JackAdapter {
	private static Jack.Port? _port_in;
	private static Jack.Port? _port_out;
	private static Jack.Client? _client;

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

	private int jack_process (Jack.NFrames samples) {
		// XXX taboo in a real_time thread
		void* buffer = _port_in.get_buffer (samples);
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

	public bool start(string client_name, string port_in_name, string port_out_name) {
		// start the server
		Jack.Status status;
		_client = Jack.Client.open (client_name, Jack.Options.NoStartServer, out status);
		if (Jack.Status.Failure in status) {
			return false;
		}

		// call the ships to port
		_port_in = _client.port_register (port_in_name, Jack.DefaultMidiType, Jack.PortFlags.IsInput, 0);
		_port_out = _client.port_register (port_out_name, Jack.DefaultMidiType, Jack.PortFlags.IsOutput, 0);
		_client.set_process_callback (jack_process);
		_client.active = true;
		return true;
	}

	public void stop() {
		if (_client != null) {
			_client.active = false;
			_client = null;
			_port_in = null;
			_port_out = null;
		}
	}

	public bool running {
		get {
			return (_client != null);
		}
	}
}
