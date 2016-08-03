/* Copyright (c) 2016 Joshua A. Cearley

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use, copy,
   modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
   ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
*/

public class skbd.Keyboard : Gtk.Widget {
	private bool _note_state[12*12];

	private const int[] _wholes = {0, 2, 4, 5, 7, 9, 11};
	private const int[] _whole_steps = {2, 2, 1, 2, 2, 2, 1};
	private const int[] _half_steps = {2, 3, 2, 2, 3};

	public int octaves { get; set; default = 2; }

	// this is mathy midi; 0 is the lowest, not -1
	private int _root_octave = 4;

	// NB this is one higher than you would expect; C3 is actually the
	// fourth octave, because there is a -1 octave in most midi apps.
	public int root_octave {
		get {
			return _root_octave;
		}

		set {
			return_if_fail (value >= 0);
			return_if_fail (value <= 10);
			_root_octave = value;
		}
	}

	public bool get_note(int note) {
		return _note_state[note];
	}

	public void set_note(int note, bool state)
	requires ((note >= 0) && (note <= 127)) {
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
