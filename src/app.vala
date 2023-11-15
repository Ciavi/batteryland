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
        TrayIndicator tray_indicator;
        UPower.UPower upower;
        AboutWindow window;
        
        public Client(string[] args) {
            Gtk.init(ref args);

            build_battery();
            tray_indicator = new TrayIndicator().with_battery(battery, show_window, quit);

            active = true;
        }

        public int run() {
            Gtk.main();
            return 0;
        }

        public void quit() {
            Gtk.main_quit();
        }

        public void show_window() {
            window = new AboutWindow(quit);
            window.show_all();
        }

        public void hide_window() {
            window.hide();
        }

        private void build_battery() {
            try {
                upower = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.UPower", "/org/freedesktop/UPower");
                
                ObjectPath[] devices;
                upower.enumerate_devices(out devices);

                foreach (var device in devices) {
                    if (device.to_string().contains("BAT")) {
                        battery = new Battery(device.to_string());
                        break;
                    }
                }
            } catch (Error e) {
                stderr.printf("%s\n", e.message);
            }
        }
    }
}

int main(string[] args) {
    Intl.setlocale(LocaleCategory.ALL, "");
    
    var langpack_dir = Path.build_filename(BatteryLand.PREFIX, "share", "locale");
    Intl.bindtextdomain(BatteryLand.PACKAGE, langpack_dir);
    Intl.bind_textdomain_codeset(BatteryLand.PACKAGE, "UTF-8");
    Intl.textdomain(BatteryLand.PACKAGE);

    var client = new BatteryLand.Client(args);
    return client.run();
}