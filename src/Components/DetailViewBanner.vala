using Granite.Widgets;

namespace Application {
public class DetailViewBanner : ListBoxRow {

    private ResponseTranslator responseTranslator = new ResponseTranslator ();
    private Gtk.Image icon = new Gtk.Image.from_icon_name ("package", Gtk.IconSize.DND);
    Gtk.Box package_row;

    Gtk.Label summary_label;
    Gtk.Label version_label;

    public DetailViewBanner (Package package){
        reloadView(package);
    }

    public void loadPackage(Package newPackage){
        remove(package_row);
        reloadView(newPackage);
        show_all();
    }

    public void reloadView(Package package){
        
        var installedPackages = responseTranslator.getInstalledPackages();
        var refreshablePackages = responseTranslator.getRefreshablePackages();

        name_label = new Gtk.Label(package.getName().strip());
        name_label.get_style_context ().add_class ("detail-view-banner-title");

        summary_label = new Gtk.Label("");
        if(package.getDeveloper() != null){
            summary_label = generateSummaryLabel(package.getDeveloper());        
        }
        version_label = new Gtk.Label("");
        if(package.getVersion() != null){
            version_label = generateSummaryLabel(package.getVersion());
        }

        var delete_button = generateDeleteButton(package);
        var update_button = generateUpdateButton(package);
        var open_button = generateOpenButton(package);
        var install_button = generateInstallButton(package);

        var vertical_box_first = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        vertical_box_first.add (name_label);
        vertical_box_first.add (summary_label);

        var vertical_box_second = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        vertical_box_second.add (version_label);
        
        package_row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        package_row.margin = 12;
        package_row.add(icon);
        package_row.add (vertical_box_first);
        package_row.add(vertical_box_second);

        if(!isInstalled(package, installedPackages)){
            summary_label.set_label("This snap is not installed yet");
            package_row.pack_end (install_button, false, false);
            add (package_row);
            return;
        }

        if(package.getName() != "core" && package.getDeveloper() != "conanical"){
            package_row.pack_end (open_button, false, false);
        }

        if(!isLatestVersion(package, refreshablePackages)){
            package_row.pack_end (update_button, false, false);
        }
        if(package.getName() != "core" && package.getDeveloper() != "conanical"){
            package_row.pack_end (delete_button, false, false);
        }

        add (package_row);
    }
}
}
