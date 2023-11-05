using GLib;

namespace UPower
{
    [DBus (name = "org.freedesktop.UPower")]
    public interface UPower : Object
    {
        public abstract string daemon_version {owned get;}
        public abstract bool on_battery {get;}
        public abstract bool lid_is_closed {get;}
        public abstract bool lid_is_present {get;}
        public abstract void enumerate_devices(out ObjectPath[] devices) throws Error;
        public abstract void get_display_device(out ObjectPath display_device) throws Error;
        public abstract signal void device_added(ObjectPath device);
        public abstract signal void device_removed(ObjectPath device);
    }

    [DBus (name = "org.freedesktop.DBus.Properties")]
    public interface Properties : Object
    {
        public abstract Variant get(string interface_name, string property_name) throws DBusError, IOError;
        public abstract HashTable<string, Variant> get_all(string interface_name) throws DBusError, IOError;
        public abstract void set(string interface_name, string property_name, Variant value) throws DBusError, IOError;
        public signal void properties_changed(string interface_name, HashTable<string, Variant> changed_properties, string[] invalidated_properties);
    }

    [CCode (type_signature = "u")]
    public enum DeviceType
    {
        UNKNOWN = 0,
        LINE_POWER = 1,
        BATTERY = 2,
        UPS = 3,
        MONITOR = 4,
        MOUSE = 5,
        KEYBOARD = 6,
        PDA = 7,
        PHONE = 8;

        public string to_string()
        {
            switch(this)
            {
                case UNKNOWN:
                    return _("Unknown");
                case LINE_POWER:
                    return _("Line Power");
                case BATTERY:
                    return _("Battery");
                case UPS:
                    return _("UPS");
                case MONITOR:
                    return _("Monitor");
                case MOUSE:
                    return _("Mouse");
                case KEYBOARD:
                    return _("Keyboard");
                case PDA:
                    return _("PDA");
                case PHONE:
                    return _("Phone");
                default:
                    assert_not_reached();
            }
        }
    }

    [CCode (type_signature = "u")]
    public enum DeviceState
    {
        UNKNOWN = 0,
        CHARGING = 1,
        DISCHARGING = 2,
        EMPTY = 3,
        CHARGED = 4,
        PENDING_CHARGE = 5,
        PENDING_DISCHARGE = 6;

        public string to_string() {
            switch (this) {
                case UNKNOWN:
                    return _("Unknown");
                case CHARGING:
                    return _("Charging");
                case DISCHARGING:
                    return _("Discharging");
                case EMPTY:
                    return _("Empty");
                case CHARGED:
                    return _("Charged");
                case PENDING_CHARGE:
                    return _("Pending Charge");
                case PENDING_DISCHARGE:
                    return _("Pending Discharge");
                default:
                    assert_not_reached();
            }
        }
    }

    [CCode (type_signature = "u")]
    public enum DeviceTechnology
    {
        UNKNOWN = 0,
        LI_ION = 1,
        LI_POL = 2,
        LI_PHOS = 3,
        ACID = 4,
        NI_CAD = 5,
        NI_HYD = 6;

        public string to_string() {
            switch (this) {
                case UNKNOWN:
                    return _("Unknown");
                case LI_ION:
                    return _("Li-Ion");
                case LI_POL:
                    return _("Li-Pol");
                case LI_PHOS:
                    return _("Li-Phos");
                case ACID:
                    return _("Acid");
                case NI_CAD:
                    return _("Ni-Cd");
                case NI_HYD:
                    return _("Ni-MH");
                default:
                    assert_not_reached();
            }
        }
    }

    [CCode (type_signature = "u")]
    public enum DeviceWarningLevel
    {
        UNKNOWN = 0,
        NONE = 1,
        DISCHARGING = 2,
        LOW = 3,
        CRITICAL = 4,
        ACTION = 5
    }

    [DBus (name = "org.freedesktop.UPower.Device")]
    public interface Device : Object
    {
        public abstract string native_path {owned get;}
        public abstract string vendor {owned get;}
        public abstract string model {owned get;}
        public abstract string serial {owned get;}
        public abstract string icon_name {owned get;}
        public abstract uint64 update_time {get;}
        [DBus (name = "Type")]
        public abstract DeviceType device_type {get;}
        public abstract bool power_supply {get;}
        public abstract bool has_history {get;}
        public abstract bool has_statistics {get;}
        public abstract bool online {get;}
        public abstract double energy {get;}
        public abstract double energy_empty {get;}
        public abstract double energy_full {get;}
        public abstract double energy_full_design {get;}
        public abstract double energy_rate {get;}
        public abstract double voltage {get;}
        public abstract int64 time_to_empty {get;}
        public abstract int64 time_to_full {get;}
        public abstract double percentage {get;}
        public abstract bool is_present {get;}
        public abstract DeviceState state {get;}
        public abstract bool is_rechargeable {get;}
        public abstract double capacity {get;}
        public abstract DeviceTechnology technology {get;}
        public abstract DeviceWarningLevel warning_level {get;}
        public abstract bool recall_notice {get;}
        public abstract string recall_vendor {owned get;}
        public abstract string recall_url {owned get;}
        public abstract void refresh() throws Error;
        public abstract void get_history(string type, uint timespan, uint resolution,[DBus (signature="a(udu)")] out Variant data) throws Error;
        public abstract void get_statistics(string type,[DBus (signature="a(dd)")] out Variant data) throws Error;
    }
}