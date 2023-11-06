using AppIndicator;
using Gtk;

namespace BatteryLand {
    delegate void WindowCaller();
    delegate void AppQuitter();

    class TrayIndicator {
        public Battery battery;
        public Indicator indicator;

        public TrayIndicator with_battery(Battery battery, WindowCaller call, AppQuitter quit) {
            this.battery = battery;
            var battery_data = battery.device_data();
            int status = 0;
            if (battery_data.state == UPower.DeviceState.CHARGING) {
                status = 1;
            }
            var icon_title = battery_data.state.to_string().concat(": ", battery_data.percentage.to_string(), "%");

            var current_path = Environment.get_current_dir();
            var icon_name = "resources/default/svg/b_%s_%s.svg".printf(status.to_string(), battery_data.percentage.to_string());
            var icon_path = Path.build_filename(current_path, icon_name);

            indicator = new Indicator("it.lichtzeit.batteryland", "indicator-messages", IndicatorCategory.HARDWARE);
            indicator.set_icon_full(icon_path, null);
            indicator.set_title(icon_title);
            indicator.set_status(IndicatorStatus.ACTIVE);

            var menu = new Gtk.Menu();

            var menu_about = new Gtk.MenuItem.with_label(_("About"));
            menu_about.activate.connect(() => call());

            var menu_quit = new Gtk.MenuItem.with_label(_("Quit"));
            menu_quit.activate.connect(() => quit());

            menu.append(menu_about);
            menu.append(menu_quit);

            menu.show_all();
            indicator.set_menu(menu);

            return this;
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

            indicator.set_icon_full(icon_path, null);
            indicator.set_title(icon_title);
        }
    }
}