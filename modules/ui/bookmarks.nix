# ./modules/ui/bookmarks.nix
# The shell's bookmarks menu (sarisarinama#18): main's bookmarks/*.txt, one
# category per file. Links open in qutebrowser, work's in brave, as main's
# bookmarks script did.
{
  flake.modules.homeManager.shell = {
    programs.sarisarinama.bookmarks = {
      browser = "qutebrowser";
      categories = {
        blogs = {
          label = "Blogs";
          links = [
            {
              label = "Maria Solano";
              url = "https://www.mariasolos.com/posts";
            }
            {
              label = "Nicolas Boisvert";
              url = "https://nboisvert.com/blog";
            }
            {
              label = "Emergent Mind";
              url = "https://unmovedcentre.com";
            }
            {
              label = "Asaduzzaman Pavel";
              url = "https://iampavel.dev/blog";
            }
          ];
        };
        chill = {
          label = "Chill";
          links = [
            {
              label = "Youtube";
              url = "https://youtube.com";
            }
            {
              label = "Twitch";
              url = "https://twitch.com";
            }
            {
              label = "Reddit";
              url = "https://reddit.com";
            }
            {
              label = "Gmail";
              url = "https://gmail.com";
            }
            {
              label = "Art Wallpapers";
              url = "https://artvee.com";
            }
          ];
        };
        code = {
          label = "Code";
          links = [
            {
              label = "Github";
              url = "https://github.com/juanalbarran";
            }
            {
              label = "Tony, btw";
              url = "https://tonybtw.com";
            }
            {
              label = "Linux Journey";
              url = "http://linuxjourney.com";
            }
            {
              label = "Rust";
              url = "https://rust-lang.org";
            }
          ];
        };
        dotfiles = {
          label = "Dotfiles";
          links = [
            {
              label = "okwilkins";
              url = "https://github.com/okwilkins/.dotfiles";
            }
          ];
        };
        java = {
          label = "Java";
          links = [
            {
              label = "Official Java Documentation";
              url = "https://dev.java/learn";
            }
            {
              label = "Javabook";
              url = "https://javabook.mccue.dev/prelude/java";
            }
            {
              label = "Java API specification";
              url = "https://docs.oracle.com/en/java/javase/26/docs/api/index.html";
            }
          ];
        };
        repositories = {
          label = "Repositories";
          links = [
            {
              label = "How to secure a Linux server";
              url = "https://github.com/imthenachoman/How-To-Secure-A-Linux-Server";
            }
          ];
        };
        work = {
          label = "Work";
          browser = "brave";
          links = [
            {
              label = "Confulence";
              url = "https://jira.nixs.com/browse/NJS-6390";
            }
            {
              label = "Xtime";
              url = "https://xtime.nixs.co";
            }
            {
              label = "Salesforce - Flosum";
              url = "https://appexchange.salesforce.com/appxListingDetail?listingId=a0N30000000psM0EAI";
            }
            {
              label = "Salesforce - Trailhead";
              url = "https://trailhead.salesforce.com/content/learn/trails/force_com_dev_beginner";
            }
          ];
        };
      };
    };
  };
}
