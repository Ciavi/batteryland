using AppIndicator;
using Gtk;

namespace BatteryLand {
    delegate void WindowCaller();
    delegate void AppQuitter();

    class TrayIndicator {
        public Battery battery;
        public Indicator indicator;

        public TrayIndicator with_battery(Battery battery, WindowCaller call, AppQuitter quit, bool is_tlp_installed) {
            this.battery = battery;

            indicator = new Indicator("it.lichtzeit.batteryland", "indicator-messages", IndicatorCategory.HARDWARE);
            indicator.set_icon_full(build_icon_path(), "");
            indicator.set_title(build_icon_title());
            indicator.set_status(IndicatorStatus.ACTIVE);

            var menu = new Gtk.Menu();

            var menu_tlpui = new Gtk.MenuItem.with_label(_("Open TLPUI"));
            menu_tlpui.activate.connect(() => open_tlp_ui());

            var menu_about = new Gtk.MenuItem.with_label(_("About"));
            menu_about.activate.connect(() => call());

            var menu_quit = new Gtk.MenuItem.with_label(_("Quit"));
            menu_quit.activate.connect(() => quit());

            if (is_tlp_installed)
                menu.append(menu_tlpui);

            menu.append(menu_about);
            menu.append(menu_quit);

            menu.show_all();
            indicator.set_menu(menu);

            battery.dbus_properties_changed.connect(update);

            return this;
        }

        public void update() {
            indicator.set_icon_full(build_icon_path(), "");
            indicator.set_title(build_icon_title());
        }

        private string build_icon_path() {
            var battery_data = battery.device_data();
            int status = 0;

            if (battery_data.state == UPower.DeviceState.CHARGING) status = 1;

            var icon_name = "resources/%s/svg/b_%s_%s.svg".printf(BatteryLand.THEME, status.to_string(), battery_data.percentage.to_string());
            
            return Path.build_filename(PREFIX, DATADIR, icon_name);
        }

        private string build_icon_title() {
            var battery_data = battery.device_data();
            int status = 0;

            if (battery_data.state == UPower.DeviceState.CHARGING) status = 1;

            return battery_data.state.to_string().concat(": ", battery_data.percentage.to_string(), "%");
        }

        private void open_tlp_ui() {
            string[] args = {""};
            try {
                int id;
                Process.spawn_async("tlpui", args, null, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out id);
            } catch (Error e) {
                stderr.printf("%s\n", e.message);
            }
        }
    }
}