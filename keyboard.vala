public class midithing.Keyboard : Gtk.Widget {
	private bool _note_state[12*12];

	private const int[] _wholes = {0, 2, 4, 5, 7, 9, 11};
	private const int[] _whole_steps = {2, 2, 1, 2, 2, 2, 1};
	private const int[] _half_steps = {2, 3, 2, 2, 3};

	public int octaves { get; set; default = 2; }

	// this is mathy midi; 0 is the lowest, not -1
	private int _root_octave = 4;

	// NB this is "common user" midi. -1 is the lowest octave, and we
	// automatically correct this to "mathy" midi on assignment. For
	// some reason so many people expect this, and compliance is more
	// reasonable than instructing musicians how to do math properly.
	public int root_octave {
		get {
			return _root_octave;
		}

		set {
			// contract enforcement
			return_if_fail (value < -1);
			return_if_fail (value > 9);
			// adjustment for stupidity
			_root_octave = value + 1;
		}
	}

	public bool get_note(int note) {
		return _note_state[note];
	}

	public void set_note(int note, bool state) {
		_note_state[note] = state;
		// XXX this doesn't queue the widget to re-draw, by the way
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
		cr.move_to (x+key_sharp, 0);
		cr.line_to (x+key_sharp, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, 0);
		cr.fill ();
	}

	private void piddle_with_half_note (Cairo.Context canvas, int note) {
		if (_note_state[note]) {
			canvas.set_source_rgb (0.8, 0.0, 0.0);
		} else {
			canvas.set_source_rgb (0.0, 0.0, 0.0);
		}
	}

	public override bool draw (Cairo.Context cr) {
		double key_width = get_allocated_width () / (7.0 * _octaves);
		double key_halfwidth = key_width * 0.65;
		double key_height = get_allocated_height ();
		double key_phiheight = key_height / 1.6;
		double key_sharp = key_width - (key_halfwidth / 2.0);
		int i;

		// draw key background
		cr.set_source_rgb (1.0, 1.0, 1.0);
		cr.move_to (0, 0);
		cr.line_to (0, key_height);
		cr.line_to (key_width*_octaves*7.0, key_height);
		cr.line_to (key_width*_octaves*7.0, 0);
		cr.fill ();

		// stamp active wholes
		cr.set_source_rgb (1.0, 0.0, 0.0);
		int note = root_octave * 12;
		for (i = 0; i < (7*_octaves); i++) {
			if (_note_state[note]) {
				cr.move_to (i*key_width, 0);
				cr.line_to (i*key_width, key_height);
				cr.line_to ((i+1)*key_width, key_height);
				cr.line_to ((i+1)*key_width, 0);
				cr.fill ();
			}
			note += _whole_steps[i % 7];
			stdout.printf("NOTE: %d\n", note);
		}

		cr.set_source_rgb (1.0, 1.0, 1.0);
		note = (root_octave * 12) + 1;
		i = 0;
		for (int octave = 0; octave < _octaves; octave++) {
			piddle_with_half_note (cr, note);
			note += _half_steps[i++ % 5];
			draw_half(cr, key_width*(0+(octave*7)), key_sharp, key_phiheight, key_halfwidth);

			piddle_with_half_note (cr, note);
			note += _half_steps[i++ % 5];
			draw_half(cr, key_width*(1+(octave*7)), key_sharp, key_phiheight, key_halfwidth);

			cr.set_source_rgb (0.0, 0.0, 0.0);
			cr.move_to (key_width*(3+(octave*7)), 0);
			cr.line_to (key_width*(3+(octave*7)), key_phiheight);
			cr.stroke ();

			piddle_with_half_note (cr, note);
			note += _half_steps[i++ % 5];
			draw_half(cr, key_width*(3+(octave*7)), key_sharp, key_phiheight, key_halfwidth);

			piddle_with_half_note (cr, note);
			note += _half_steps[i++ % 5];
			draw_half(cr, key_width*(4+(octave*7)), key_sharp, key_phiheight, key_halfwidth);

			piddle_with_half_note (cr, note);
			note += _half_steps[i++ % 5];
			draw_half(cr, key_width*(5+(octave*7)), key_sharp, key_phiheight, key_halfwidth);
		}

		cr.set_source_rgb (0.0, 0.0, 0.0);
		for (i = 1; i < (7*_octaves); i++) {
			cr.move_to (i*key_width, key_phiheight);
			cr.line_to (i*key_width, key_height);
			cr.stroke ();
		}

		for (i = 1; i < _octaves; i++) {
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
