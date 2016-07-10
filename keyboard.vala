public class midithing.Keyboard : Gtk.Widget {
	private bool _note_state[12*12];

	public int octaves { get; set; default = 2; }
	public int root_octave { get; set; default = 3; }

	public bool get_note(int note) {
		return _note_state[note];
	}

	public void set_note(int note, bool state) {
		_note_state[note] = state;
		// TODO only do this if the note is in our visible region
		// TODO use dirty rectangles on the specific notes that did change
		queue_draw ();
	}

	public Keyboard() {
	}

	public override void realize() {
		Gdk.WindowAttr attr = {};
		attr.window_type = Gdk.WindowType.CHILD;

		Gdk.Window window = new Gdk.Window (get_parent_window (), attr, 0);
		window.set_user_data (this);

		set_window (window);
		set_realized (true);
	}

	private void draw_half(Cairo.Context cr, double x, double key_sharp, double key_phiheight, double key_halfwidth) {
		cr.set_source_rgb (0.0, 0.0, 0.0);
		cr.move_to (x+key_sharp, 0);
		cr.line_to (x+key_sharp, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, 0);
		cr.fill ();
	}

	public override bool draw (Cairo.Context cr) {
		double key_width = get_allocated_width () / (7.0 * _octaves);
		double key_halfwidth = key_width * 0.65;
		double key_height = get_allocated_height ();
		double key_phiheight = key_height / 1.6;
		double key_sharp = key_width - (key_halfwidth / 2.0);

		// draw key background
		cr.set_source_rgb (1.0, 1.0, 1.0);
		cr.move_to (0, 0);
		cr.line_to (0, key_height);
		cr.line_to (key_width*_octaves*7.0, key_height);
		cr.line_to (key_width*_octaves*7.0, 0);
		cr.fill ();

		for (int octave = 0; octave < _octaves; octave++) {
			draw_half(cr, key_width*(0+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
			draw_half(cr, key_width*(1+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
			cr.move_to (key_width*(3+(octave*7)), 0);
			cr.line_to (key_width*(3+(octave*7)), key_phiheight);
			cr.stroke ();
			draw_half(cr, key_width*(3+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
			draw_half(cr, key_width*(4+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
			draw_half(cr, key_width*(5+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
		}

		for (int i = 1; i < (7*_octaves); i++) {
			cr.move_to (i*key_width, key_phiheight);
			cr.line_to (i*key_width, key_height);
			cr.stroke ();
		}

		for (int i = 1; i < _octaves; i++) {
			cr.move_to (i*7*key_width, 0);
			cr.line_to (i*7*key_width, key_phiheight);
			cr.stroke ();
		}

		cr.move_to (3*key_width, key_phiheight);
		cr.line_to (3*key_width, key_height);
		cr.stroke ();

		cr.move_to (0, key_height);
		cr.line_to (key_width*7*_octaves, key_height);
		cr.stroke ();

		return true;
	}
}
