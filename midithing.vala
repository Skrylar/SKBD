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

public class skbd.SKBD : Gtk.Application {
	const string _jack_name = "SKBD";
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

	public SKBD () {
		Object(application_id: "skrylar.SKBD",
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

	protected bool handle_midi_key (uint16 key, bool down) {
		int note;
		switch (key) {
		// lower octave
		case (uint16)Gdk.Key.z:
			note = (_keyboard.root_octave*12)+0;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.s:
			note = (_keyboard.root_octave*12)+1;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.x:
			note = (_keyboard.root_octave*12)+2;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.d:
			note = (_keyboard.root_octave*12)+3;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.c:
			note = (_keyboard.root_octave*12)+4;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.v:
			note = (_keyboard.root_octave*12)+5;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.g:
			note = (_keyboard.root_octave*12)+6;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.b:
			note = (_keyboard.root_octave*12)+7;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.h:
			note = (_keyboard.root_octave*12)+8;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.n:
			note = (_keyboard.root_octave*12)+9;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.j:
			note = (_keyboard.root_octave*12)+10;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.m:
			note = (_keyboard.root_octave*12)+11;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		// higher octave
		case (uint16)Gdk.Key.q:
			note = (_keyboard.root_octave*12)+12;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.@2:
			note = (_keyboard.root_octave*12)+13;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.w:
			note = (_keyboard.root_octave*12)+14;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.@3:
			note = (_keyboard.root_octave*12)+15;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.e:
			note = (_keyboard.root_octave*12)+16;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.r:
			note = (_keyboard.root_octave*12)+17;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.@5:
			note = (_keyboard.root_octave*12)+18;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.t:
			note = (_keyboard.root_octave*12)+19;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.@6:
			note = (_keyboard.root_octave*12)+20;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.y:
			note = (_keyboard.root_octave*12)+21;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.@7:
			note = (_keyboard.root_octave*12)+22;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		case (uint16)Gdk.Key.u:
			note = (_keyboard.root_octave*12)+23;
			_keyboard.set_note (note, !down);
			_jack_adapter.post_note_onoff (note, !down);
			return true;
		default: return false;
		}
	}

	protected bool on_key_down (Gdk.EventKey event) {
		switch (event.keyval) {
		case (uint16)Gdk.Key.Escape:
			_infobar_revealer.reveal_child = false;
			return true;
		}
		if (handle_midi_key ((uint16)event.keyval, true)) {
			_keyboard.queue_draw ();
			return true;
		}
		return false;
	}

	protected bool on_key_up (Gdk.EventKey event) {
		if (handle_midi_key ((uint16)event.keyval, false)) {
			_keyboard.queue_draw ();
			return true;
		}
		return false;
	}

	protected void create_gui () {
		_appwin = new Gtk.ApplicationWindow (this);
		Gtk.HeaderBar header = new Gtk.HeaderBar ();
		header.title = "SKBD";
		header.show_close_button = true;
		_appwin.set_titlebar (header);

		Gtk.Image* settings_image = new Gtk.Image.from_stock (
			"gtk-properties",
			Gtk.IconSize.LARGE_TOOLBAR);

		var settings_menu_button = new Gtk.Button ();
		header.pack_end (settings_menu_button);
		settings_menu_button.set_image (settings_image);

		settings_menu_button.clicked.connect (() => {
				var window = new SettingsWindow ();
				// TODO connect signals for issuing config changes
				window.show_all ();
				window.set_modal (true);
			});

		_jack_switch = new Gtk.Switch ();
		_jack_switch.state_set.connect (on_toggle_jack);
		header.pack_start (_jack_switch);

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
		SKBD app = new SKBD ();
		return app.run (args);
	}
}