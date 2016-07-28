
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

	// Stores events retrieved from process.
	public Event inbox[127];

	// Number of events in the inbox. Reset this to zero once you've
	// read them.
	public int inbox_size;

	private int jack_process (Jack.NFrames samples) {
		// XXX taboo in a real_time thread
		void* buffer = _port_in.get_buffer (samples);
		void* out_buffer = _port_out.get_buffer (samples);

		// clear output buffer
		Jack.Midi.clear_buffer (out_buffer);

		// prepare to receive events
		var events = Jack.Midi.get_event_count (buffer);
		Jack.Midi.Event evt = {};

		for (int i = 0; i < events; i++) {
			// grab event
			Jack.Midi.event_get (&evt, buffer, i);

			// figure out if we care about this event
			stdout.printf("channel: %d ", evt.buffer[0] & MIDI_CHANNEL_MASK);
			switch (evt.buffer[0] & MIDI_COMMAND_MASK) {
			case MidiMessageType.NoteOn:
				if (inbox_size < 127) {
					Event e = {};
					e.type = EventType.NoteOn;
					e.note = evt.buffer[2];
					inbox[inbox_size++] = e;
				}
				break;
			case MidiMessageType.NoteOff:
				if (inbox_size < 127) {
					Event e = {};
					e.type = EventType.NoteOn;
					e.note = evt.buffer[2];
					inbox[inbox_size++] = e;
				}
				break;
			default:
				break;
			}

			// pass the event forward

			// XXX if we choose to implement any kind of filtering
			// functionality, we will have to revisit this. that being
			// said there are other programs which already do that, so
			// we might not be too concerned about it.
			Jack.Midi.Data* datum = Jack.Midi.event_reserve (out_buffer, evt.time, evt.size);
			Posix.memmove (datum, evt.buffer, evt.size);
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
