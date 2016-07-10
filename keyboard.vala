public class midithing.Keyboard : Gtk.Widget {
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

	const double key_height = 80.0;
	const double key_phiheight = 80.0 / 1.6;
	const double key_width = 30.0;
	const double key_halfwidth = key_width * 0.65;
	const double key_sharp = key_width - (key_halfwidth / 2.0);

	private void draw_half(Cairo.Context cr, double x) {
		cr.set_source_rgb (0.0, 0.0, 0.0);
		cr.move_to (x+key_sharp, 0);
		cr.line_to (x+key_sharp, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, key_phiheight);
		cr.line_to (x+key_sharp+key_halfwidth, 0);
		cr.fill ();
	}

	public override bool draw (Cairo.Context cr) {
		cr.set_source_rgb (0.0, 1.0, 0.0);
		cr.rectangle (0, 0, get_allocated_width (), get_allocated_height ());
		cr.fill ();

		cr.set_source_rgb (1.0, 1.0, 1.0);
		cr.move_to (0, 0);
		cr.line_to (0, key_height);
		cr.line_to (key_width*7.0, key_height);
		cr.line_to (key_width*7.0, 0);
		cr.fill ();

		draw_half(cr, key_width*0);
		draw_half(cr, key_width*1);
		draw_half(cr, key_width*3);
		draw_half(cr, key_width*4);
		draw_half(cr, key_width*5);

		cr.move_to (3*key_width, 0);
		cr.line_to (3*key_width, key_phiheight);
		cr.stroke ();

		for (int i = 1; i < 7; i++) {
			cr.move_to (i*key_width, key_phiheight);
			cr.line_to (i*key_width, key_height);
			cr.stroke ();
		}

		cr.move_to (3*key_width, key_phiheight);
		cr.line_to (3*key_width, key_height);
		cr.stroke ();

		cr.move_to (0, key_height);
		cr.line_to (key_width*7, key_height);
		cr.stroke ();

		return true;
	}
}
