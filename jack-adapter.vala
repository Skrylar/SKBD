/* Copyright (C) 2016 Joshua A. Cearley

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see
  <http://www.gnu.org/licenses/>.
*/

class skbd.JackAdapter {
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

	// Queued as an idle event whenever the inbox has been changed
	public SourceFunc collect;

	// Stores events retrieved from process.
	public Event inbox[127];

	// Number of events in the inbox. Reset this to zero once you've
	// read them.
	public int inbox_size = 0;

	// Stores events to send outward.
	public Event outbox[127];

	// Number of events in the inbox. Will be reset to zero once
	// messages have been dispatched.
	public int outbox_size = 0;

	public void post_note_onoff (int note, bool on)
	requires ((note >= 0) && (note <= 127)) {
		// avoid overflow
		if (outbox_size >= 127) return;
		// set note
		outbox[outbox_size].note = (uint8)note;
		// what is the note doing?
		if (on) {
			outbox[outbox_size].type = EventType.NoteOn;
		} else {
			outbox[outbox_size].type = EventType.NoteOff;
		}
		// carry on
		outbox_size++;
	}

	private int jack_process (Jack.NFrames samples) {
		// XXX taboo in a real_time thread
		void* buffer = _port_in.get_buffer (samples);
		void* out_buffer = _port_out.get_buffer (samples);

		// clear output buffer
		Jack.Midi.clear_buffer (out_buffer);

		// prepare to receive events
		var events = Jack.Midi.get_event_count (buffer);
		Jack.Midi.Event evt = {};

		// transmit outbox messages
		for (int i = 0; i < outbox_size; i++) {
			Jack.Midi.Data* datum;
			switch (outbox[i].type) {
			case EventType.NoteOn:
				datum = Jack.Midi.event_reserve (out_buffer, 0, 3);
				datum[0] = MidiMessageType.NoteOn;
				datum[1] = outbox[i].note;
				datum[2] = 127;
				break;
			case EventType.NoteOff:
				datum = Jack.Midi.event_reserve (out_buffer, 0, 3);
				datum[0] = MidiMessageType.NoteOff;
				datum[1] = outbox[i].note;
				datum[2] = 0;
				break;
			}
		}
		outbox_size = 0;

		// deal with inbox stuff
		int ibox = inbox_size;
		for (int i = 0; i < events; i++) {
			// grab event
			Jack.Midi.event_get (&evt, buffer, i);

			// figure out if we care about this event
			switch (evt.buffer[0] & MIDI_COMMAND_MASK) {
			case MidiMessageType.NoteOn:
				if (inbox_size < 127) {
					Event e = {};
					e.type = EventType.NoteOn;
					e.note = evt.buffer[1];
					inbox[inbox_size++] = e;
				}
				break;
			case MidiMessageType.NoteOff:
				if (inbox_size < 127) {
					Event e = {};
					e.type = EventType.NoteOff;
					e.note = evt.buffer[1];
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

		// dispatch inbox messages if there are any
		if (collect != null && ibox == 0 && inbox_size > 0) {
			Idle.add (() => {
					return collect ();
				});
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
