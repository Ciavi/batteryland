using AppIndicator;
using GLib;
using Gtk;
using UPower;

namespace BatteryLand {
    public class Battery : Object {
        internal DBusConnection connection;
        internal UPower.Device device;

        public signal void dbus_properties_changed();

        public Battery(string path) {
            try {
                device = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.UPower", path);
                connection = Bus.get_sync(BusType.SYSTEM);
                connection.signal_subscribe(null, "org.freedesktop.DBus.Properties", "PropertiesChanged", path, null, DBusSignalFlags.NONE, properties_changed);
            } catch (Error e) {
                stderr.printf("%s\n", e.message);
            }
        }

        public UPower.Device device_data() {
            return device;
        }

        public void properties_changed(DBusConnection connection, string? sender_name, string object_path, string interface_name, string signal_name, Variant parameters) {
            dbus_properties_changed();
        }
    }

    public class Client : Object {
        bool active;

        Battery battery;
        Gtk.Menu menu;
        Indicator tray_indicator;
        UPower.UPower upower;
        Window window;
        
        public Client(string[] args) {
            Gtk.init(ref args);

            build_battery();
            build_tray();

            active = true;
        }

        public int run() {
            menu.show_all();
            tray_indicator.set_menu(menu);

            Gtk.main();

            return 0;
        }

        public void quit() {
            Gtk.main_quit();
        }

        public void show_window() {
            build_window();
            window.show_all();
        }

        public void hide_window() {
            window.hide();
        }

        public void update() {
            var battery_data = battery.device_data();
            int status = 0;
            if (battery_data.state == UPower.DeviceState.CHARGING) {
                status = 1;
            }
            var icon_title = battery_data.state.to_string().concat(": ", battery_data.percentage.to_string(), "%");

            var current_path = Environment.get_current_dir();
            var icon_name = "resources/default/svg/b_%s_%s.svg".printf(status.to_string(), battery_data.percentage.to_string());
            var icon_path = Path.build_filename(current_path, icon_name);

            tray_indicator.set_icon_full(icon_path, null);
            tray_indicator.set_title(icon_title);
        }

        private void build_battery() {
            try {
                upower = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.UPower", "/org/freedesktop/UPower");
                
                ObjectPath[] devices;
                upower.enumerate_devices(out devices);

                foreach (var device in devices) {
                    if (device.to_string().contains("BAT")) {
                        battery = new Battery(device.to_string());
                        battery.dbus_properties_changed.connect(update);
                        break;
                    }
                }
            } catch (Error e) {
                stderr.printf("%s\n", e.message);
            }
        }

        private void build_window() {
            window = new Window(WindowType.TOPLEVEL);
            window.set_title(_("BatteryLand"));
            window.set_default_size(360, 480);
            window.set_size_request(360, 480);
            window.set_position(WindowPosition.CENTER_ALWAYS);
            window.set_resizable(false);

            var bg_github_normal = Gdk.RGBA();
            bg_github_normal.parse("#6e5494");
            var fg_github_normal = Gdk.RGBA();
            fg_github_normal.parse("#fafafa");

            var main_container = new Box(Orientation.VERTICAL, 12);
            main_container.set_margin_top(12);
            main_container.set_margin_bottom(12);
            main_container.set_margin_start(12);
            main_container.set_margin_end(12);
            main_container.set_halign(Align.FILL);
            main_container.set_valign(Align.END);

            var top_container = new Grid();
            top_container.set_orientation(Orientation.VERTICAL);
            top_container.set_row_spacing(12);
            top_container.set_halign(Align.CENTER);

            var current_path = Environment.get_current_dir();
            var logo_name = "resources/default/svg/b_1_100.svg";
            var logo_path = Path.build_filename(current_path, logo_name);

            var logo = new Image();

            try {
                var logo_buf = new Gdk.Pixbuf.from_file_at_scale(logo_path, 96, 96, true);
                logo.set_from_pixbuf(logo_buf);
            } catch (Error err) {
                stderr.printf("%s\n", err.message);
            }

            var title_attributes = new Pango.AttrList();
            title_attributes.insert(Pango.AttrSize.new_absolute(28 * Pango.SCALE));
            title_attributes.insert(Pango.attr_weight_new(Pango.Weight.BOLD));

            var title = new Label(_("BatteryLand"));
            title.set_attributes(title_attributes);

            var description = new Label(_("Yet another battery icon for your system tray"));

            var scroll_container = new ScrolledWindow(null, null);
            scroll_container.set_valign(Align.FILL);

            var changelog = new TextView();
            changelog.buffer.set_text("");

            scroll_container.add(changelog);

            top_container.attach(logo, 0, 1);
            top_container.attach_next_to(title, logo, PositionType.BOTTOM);
            top_container.attach_next_to(description, title, PositionType.BOTTOM);
            top_container.attach_next_to(description, scroll_container, PositionType.BOTTOM);

            var bottom_container = new Grid();
            bottom_container.set_orientation(Orientation.HORIZONTAL);
            bottom_container.set_column_spacing(12);
            bottom_container.set_column_homogeneous(true);
            bottom_container.set_halign(Align.FILL);

            var button_github = new Button.with_label(_("GitHub"));
            button_github.override_background_color(StateFlags.NORMAL, bg_github_normal);
            button_github.override_background_color(StateFlags.ACTIVE, fg_github_normal);
            button_github.override_color(StateFlags.NORMAL, fg_github_normal);
            button_github.override_color(StateFlags.ACTIVE, bg_github_normal);
            button_github.clicked.connect(github_button_clicked);

            var button_quit = new Button.with_label(_("Quit"));
            button_quit.clicked.connect(quit);

            bottom_container.attach(button_github, 1, 0);
            bottom_container.attach_next_to(button_quit, button_github, PositionType.RIGHT);

            main_container.add(top_container);
            main_container.add(bottom_container);

            window.add(main_container);
        }

        private void build_tray() {
            var battery_data = battery.device_data();
            int status = 0;
            if (battery_data.state == UPower.DeviceState.CHARGING) {
                status = 1;
            }
            var icon_title = battery_data.state.to_string().concat(": ", battery_data.percentage.to_string(), "%");
            
            tray_indicator = new Indicator("it.lichtzeit.batteryland", "indicator-messages", AppIndicator.IndicatorCategory.HARDWARE);
            tray_indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);

            var current_path = Environment.get_current_dir();
            var icon_name = "resources/default/svg/b_%s_%s.svg".printf(status.to_string(), battery_data.percentage.to_string());
            var icon_path = Path.build_filename(current_path, icon_name);

            tray_indicator.set_icon_full(icon_path, null);
            tray_indicator.set_title(icon_title);

            menu = new Gtk.Menu();

            var menu_about = new Gtk.MenuItem.with_label(_("About"));
            menu_about.activate.connect(() => show_window());

            var menu_quit = new Gtk.MenuItem.with_label(_("Quit"));
            menu_quit.activate.connect(() => quit());

            menu.append(menu_about);
            menu.append(menu_quit);
        }

        private void github_button_clicked() {
            try {
                Gtk.show_uri_on_window(window, "https://github.com/Ciavi/BatteryLand", 0);
            } catch (Error err) {
                stderr.printf("%s\n", err.message);
            }
        }
    }
}

int main(string[] args) {
    var client = new BatteryLand.Client(args);
    return client.run();
}