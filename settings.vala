namespace skbd {
	[GtkTemplate (ui = "/skbd/settings.ui")]
	public class SettingsWindow : Gtk.Window {
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
	}
} /* skbd */