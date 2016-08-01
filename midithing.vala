public class midithing.Midithing : Gtk.Application {
	const string _jack_name = "Midithing";
	const string _port_in_name = "midi-in";
	const string _port_out_name = "midi-out";

	private Gtk.ApplicationWindow _appwin;

	// deal with getting jack events
	private Gtk.Switch _jack_switch;
	private JackAdapter _jack_adapter;

	// let the user know when sadness has ocurred
	private weak Gtk.InfoBar _infobar;
	private weak Gtk.Revealer _infobar_revealer;
	private weak Gtk.Label _infobar_label;

	private weak Keyboard _keyboard;

	public Midithing () {
		Object(application_id: "skrylar.Midithing",
			   flags: ApplicationFlags.FLAGS_NONE);
		_jack_adapter = new JackAdapter ();
		_jack_adapter.collect = on_idle;
	}

	private void problem (string error) {
		// make changes
		_infobar.set_message_type (Gtk.MessageType.ERROR);
		_infobar_label.label = error;
		_infobar_revealer.reveal_child = true;
	}

	protected bool on_toggle_jack (bool state) {
		if (state) {
			if (!_jack_adapter.start (_jack_name, _port_in_name, _port_out_name)) {
				// warning for smart people
				warning ("Jack connection failed.");
				// reset the GUI to desired state
				_jack_switch.state = false;
				_jack_switch.active = false;
				// friendly UX warning
				problem ("Could not connect to Jack. Is it running?");
				// we're done
				return true;
			}
		} else {
			_jack_adapter.stop ();
		}
		_jack_switch.state = state;
		return true;
	}

	protected bool on_key_down (Gdk.EventKey event) {
		switch (event.keyval) {
		case (uint16)Gdk.Key.Escape:
			_infobar_revealer.reveal_child = false;
			break;
		}
		return false;
	}

	protected bool on_key_up (Gdk.EventKey event) {
		return false;
	}

	protected void create_gui () {
		_appwin = new Gtk.ApplicationWindow (this);
		Gtk.HeaderBar header = new Gtk.HeaderBar ();
		header.title = "Midithing";
		header.show_close_button = true;
		_appwin.set_titlebar (header);

		_jack_switch = new Gtk.Switch ();
		_jack_switch.state_set.connect (on_toggle_jack);
		header.pack_end (_jack_switch);

		/* main content box */ {
			var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

			var infobar_revealer = new Gtk.Revealer ();
			_infobar_revealer = infobar_revealer;
			_infobar_revealer.reveal_child = false;
			box.pack_start (_infobar_revealer, false);

			var infobar = new Gtk.InfoBar ();
			_infobar = infobar;
			_infobar.show_close_button = true;
			_infobar.response.connect ((id) => {
					_infobar_revealer.reveal_child = false;
			});
			_infobar_revealer.add (_infobar);

			var infobar_label = new Gtk.Label (null);
			_infobar_label = infobar_label;
			Gtk.Container content = _infobar.get_content_area ();
			content.add (_infobar_label);

			Keyboard kbd = new Keyboard ();
			_keyboard = kbd;
			box.pack_end (kbd);

			_appwin.add (box);
		} /* main content box */

		// connect window keyboard to handlers
		_appwin.key_press_event.connect (on_key_up);
		_appwin.key_release_event.connect (on_key_down);

		_appwin.set_default_size (280, 100);
		_appwin.show_all ();
	}

	public bool on_idle () {
		// update keyboard control
		for (int eid = 0; eid < _jack_adapter.inbox_size; eid++) {
			switch (_jack_adapter.inbox[eid].type) {
			case EventType.NoteOn:
				_keyboard.set_note (_jack_adapter.inbox[eid].note, true);
				break;
			case EventType.NoteOff:
				_keyboard.set_note (_jack_adapter.inbox[eid].note, false);
				break;
			default:
				// nothing to do
				break;
			}
		}
		// clear inbox
		_jack_adapter.inbox_size = 0;
		// redraw
		_keyboard.queue_draw ();
		return GLib.Source.REMOVE;
	}

	protected override void activate () {
		// user needs this
		create_gui ();
	}

	public static int main (string[] args) {
		Midithing app = new Midithing ();
		return app.run (args);
	}
}