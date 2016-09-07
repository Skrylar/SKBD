namespace skbd {
	[GtkTemplate (ui = "/skbd/settings.ui")]
	public class SettingsWindow : Gtk.Window {
		private CaptureKeyWindow _capture_window;

		// all the notes you could ever want
		[GtkChild]
		private Gtk.Button note00;
		[GtkChild]
		private Gtk.Button note01;
		[GtkChild]
		private Gtk.Button note02;
		[GtkChild]
		private Gtk.Button note03;
		[GtkChild]
		private Gtk.Button note04;
		[GtkChild]
		private Gtk.Button note05;
		[GtkChild]
		private Gtk.Button note06;
		[GtkChild]
		private Gtk.Button note07;
		[GtkChild]
		private Gtk.Button note08;
		[GtkChild]
		private Gtk.Button note09;
		[GtkChild]
		private Gtk.Button note10;
		[GtkChild]
		private Gtk.Button note11;
		[GtkChild]
		private Gtk.Button note12;
		[GtkChild]
		private Gtk.Button note13;
		[GtkChild]
		private Gtk.Button note14;
		[GtkChild]
		private Gtk.Button note15;
		[GtkChild]
		private Gtk.Button note16;
		[GtkChild]
		private Gtk.Button note17;
		[GtkChild]
		private Gtk.Button note18;
		[GtkChild]
		private Gtk.Button note19;
		[GtkChild]
		private Gtk.Button note20;
		[GtkChild]
		private Gtk.Button note21;
		[GtkChild]
		private Gtk.Button note22;
		[GtkChild]
		private Gtk.Button note23;

		private int _note_being_changed;

		private void start_note_change (int id) {
			_note_being_changed = id;
			// TODO show config window
		}

		private void finish_note_change (int id) {
			// TODO disconnect stuff
		}

		[GtkCallback]
		protected void on_apply_changes () {
			// write changes to config
			// TODO
			// force update to running process
			// TODO
			// dispose of window
			this.destroy ();
		}

		[GtkCallback]
		protected void on_cancel_changes () {
			// do not propagate changes, just dispose of this window
			this.destroy ();
		}

		private void connect_events () {
			note00.clicked.connect (() => {
					start_note_change (0);
				});
			note01.clicked.connect (() => {
					start_note_change (1);
				});
			note02.clicked.connect (() => {
					start_note_change (2);
				});
			note03.clicked.connect (() => {
					start_note_change (3);
				});
			note04.clicked.connect (() => {
					start_note_change (4);
				});
			note05.clicked.connect (() => {
					start_note_change (5);
				});
			note06.clicked.connect (() => {
					start_note_change (6);
				});
			note07.clicked.connect (() => {
					start_note_change (7);
				});
			note08.clicked.connect (() => {
					start_note_change (8);
				});
			note09.clicked.connect (() => {
					start_note_change (9);
				});
			note10.clicked.connect (() => {
					start_note_change (10);
				});
			note11.clicked.connect (() => {
					start_note_change (11);
				});
			note12.clicked.connect (() => {
					start_note_change (12);
				});
			note13.clicked.connect (() => {
					start_note_change (13);
				});
			note14.clicked.connect (() => {
					start_note_change (14);
				});
			note15.clicked.connect (() => {
					start_note_change (15);
				});
			note16.clicked.connect (() => {
					start_note_change (16);
				});
			note17.clicked.connect (() => {
					start_note_change (17);
				});
			note18.clicked.connect (() => {
					start_note_change (18);
				});
			note19.clicked.connect (() => {
					start_note_change (19);
				});
			note20.clicked.connect (() => {
					start_note_change (20);
				});
			note21.clicked.connect (() => {
					start_note_change (21);
				});
			note22.clicked.connect (() => {
					start_note_change (22);
				});
			note23.clicked.connect (() => {
					start_note_change (23);
				});
		}
	}
} /* SKBD */
