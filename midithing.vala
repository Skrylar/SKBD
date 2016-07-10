public class midithing.Midithing : Gtk.Application {
	public Midithing () {
		Object(application_id: "skrylar.Midithing",
			   flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate () {
		Gtk.ApplicationWindow appwin = new Gtk.ApplicationWindow (this);
		Gtk.HeaderBar header = new Gtk.HeaderBar ();
		header.title = "Midi Thing";
		header.show_close_button = true;
		appwin.set_titlebar (header);

		Gtk.Switch jack_switch = new Gtk.Switch ();
		jack_switch.sensitive = false;
		header.pack_end (jack_switch);

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