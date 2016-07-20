public class midithing.Midithing : Gtk.Application {
	const string _jack_name = "Midithing";
	const string _port_in_name = "midi-in";
	const string _port_out_name = "midi-out";

	private Gtk.Switch _jack_switch;
	private JackAdapter _jack_adapter;

	public Midithing () {
		Object(application_id: "skrylar.Midithing",
			   flags: ApplicationFlags.FLAGS_NONE);
		_jack_adapter = new JackAdapter ();
	}

	protected override void activate () {
		Gtk.ApplicationWindow appwin = new Gtk.ApplicationWindow (this);
		Gtk.HeaderBar header = new Gtk.HeaderBar ();
		header.title = "Midithing";
		header.show_close_button = true;
		appwin.set_titlebar (header);

		_jack_switch = new Gtk.Switch ();
		_jack_switch.state_set.connect ((state) => {
				if (state) {
					if (!_jack_adapter.start (_jack_name, _port_in_name, _port_out_name)) {
						warning ("Jack startup failed.");
						// TODO throw a visible notification here
						_jack_switch.state = false;
						return true;
					}
				} else {
					_jack_adapter.stop ();
				}
				_jack_switch.state = state;
				return true;
		});
		header.pack_end (_jack_switch);

		Keyboard kbd = new Keyboard ();
		appwin.add (kbd);

		appwin.set_default_size (280, 100);
		appwin.show_all ();
	}

	public static int main (string[] args) {
		Midithing app = new Midithing ();
		return app.run (args);
	}
}