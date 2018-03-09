using ToxCore;

namespace ToxVapi {
  public class Bot : Object {
    private const string URL = "https://github.com/naxuroqa/vala-toxcore-c";
    private const string BOT_NAME = "RicinBot";
    private const string BOT_MOOD = "A simple bot written in Vala - " + URL;
    private const string GROUP_NAME = "Official Ricin's conference - https://github.com/RicinApp/Ricin";
    private string TOX_SAVE = "Bot.tox";

    private Tox handle;

    private bool connected = false;
    private uint32 conference_number;

    private MainLoop loop = new MainLoop();

    public Bot() {
      stdout.printf("Running on c-toxcore version %u.%u.%u\n",
                    ToxCore.Version.MAJOR, ToxCore.Version.MINOR, ToxCore.Version.PATCH);

      var options = new Options(null);
      options.ipv6_enabled = true;
      options.udp_enabled = true;
      options.proxy_type = ProxyType.NONE;

      if (FileUtils.test(TOX_SAVE, FileTest.EXISTS)) {
        uint8[] savedata;
        FileUtils.get_data(TOX_SAVE, out savedata);
        options.savedata_type = SaveDataType.TOX_SAVE;
        options.set_savedata_data(savedata);
      }

      handle = new Tox(options, null);
      bootstrap.begin();

      handle.self_set_name(BOT_NAME, null);
      handle.self_set_status_message(BOT_MOOD, null);

      conference_number = handle.conference_new(null);
      handle.conference_set_title(conference_number, GROUP_NAME, null);

      stdout.printf("Tox name: %s\n", handle.self_get_name());
      stdout.printf("ToxID: %s\n", Tools.bin2hex(handle.self_get_address()));

      handle.callback_self_connection_status(on_self_connection_status);
      handle.callback_friend_message(on_friend_message);
      handle.callback_friend_request(on_friend_request);
      handle.callback_friend_status(on_friend_status);

      tox_loop();
      loop.run();
    }

    private void tox_loop () {
      var interval = handle.iteration_interval();
      Timeout.add(interval, () => {
        handle.iterate(this);
        tox_loop();
        return Source.REMOVE;
      });
    }

    private async void bootstrap () {
      var sess = new Soup.Session();
      var msg = new Soup.Message("GET", "https://nodes.tox.chat/json");
      var stream = yield sess.send_async (msg, null);
      var json = new Json.Parser();
      if (yield json.load_from_stream_async(stream, null)) {
        Server[] servers = {};
        var array = json.get_root().get_object().get_array_member("nodes");
        array.foreach_element((arr, index, node) => {
          servers += Json.gobject_deserialize(typeof (Server), node) as Server;
        });
        while (!connected) {
          for (int i = 0; i < 4; ++i) {           // bootstrap to 4 random nodes
            int index = Random.int_range(0, servers.length);
            stdout.printf("Bootstrapping to %s:%llu by %s\n", servers[index].ipv4, servers[index].port, servers[index].maintainer);
            handle.bootstrap(
              servers[index].ipv4,
              (uint16) servers[index].port,
              Tools.hex2bin(servers[index].public_key),
              null
              );
          }

          // wait 5 seconds without blocking main loop
          Timeout.add(5000, () => {
            bootstrap.callback ();
            return Source.REMOVE;
          });
          yield;
        }
        stdout.printf("Done bootstrapping\n");
      }
    }

    private static void on_self_connection_status(Tox tox, Connection connection_status, void* user_data) {
      var bot = user_data as Bot;
      if (connection_status != Connection.NONE) {
        stdout.printf("Connected to Tox\n");
        bot.connected = true;
      } else {
        stdout.printf("Disconnected\n");
        bot.connected = false;
      }
    }

    private static void on_friend_message(Tox handle, uint32 friend_number, MessageType type, uint8[] message, void* user_data) {
      var bot = user_data as Bot;
      var message_string = (string) message;
      var friend_name = handle.friend_get_name(friend_number, null);
      stdout.printf("%s: %s\n", friend_name, message_string);

      if (message_string.has_prefix("add ")) {
        var tox_id = message_string.splice(0, 4);
        var _message = "Add me please?";
        stdout.printf(@"Sending a friend request to $tox_id: \"$_message\"\n");
        var friend_num = handle.friend_add(Tools.hex2bin(tox_id), _message, null);
        stdout.printf(@"friend_num == $friend_num\n");
        return;
      }

      switch (message_string.down()) {
        case "about":
          var response_message = @"Hi $friend_name! I'm a simple bot developed to test Vala bindings for Tox.\n";
          response_message += @"See $URL for more information";
          handle.friend_send_message(friend_number, MessageType.NORMAL, response_message, null);
          break;
        case "help":
          var response_message = "Available commands:\n"
                                 + "* about: Print some information about me.\n"
                                 + "* invite: Invite you to a conference.\n"
                                 + "* id: Print my Tox ID.\n"
                                 + "* version - Display my c-toxcore version.";

          handle.friend_send_message(friend_number, MessageType.ACTION, response_message, null);
          break;
        case "id":
          var tox_id = handle.self_get_address();
          var response_message = Tools.bin2hex(tox_id);
          handle.friend_send_message(friend_number, MessageType.NORMAL, response_message, null);
          break;
        case "invite":
          handle.conference_invite(friend_number, bot.conference_number, null);
          break;
        case "version":
          var response_message = "Currently using c-toxcore version: %u.%u.%u".printf(ToxCore.Version.major(), ToxCore.Version.minor(), ToxCore.Version.patch());
          handle.friend_send_message(friend_number, MessageType.NORMAL, response_message, null);
          break;
        default:
          var response_message = "Unknown command. Type `help` for a list of commands.";
          handle.friend_send_message(friend_number, MessageType.NORMAL, response_message, null);
          break;
      }
    }

    private static void on_friend_request (Tox handle, uint8[] public_key, uint8[] message, void* user_data) {
      var bot = user_data as Bot;
      public_key.length = (int) public_key_size();

      stdout.printf("Received a friend request from:\n");
      stdout.printf("--- %s\n", Tools.bin2hex(public_key));
      stdout.printf("--- %s\n", (string) message);
      handle.friend_add_norequest(public_key, null);

      // Save the friend in the .tox file.
      bot.save_data();
    }

    private static void on_friend_status(Tox handle, uint32 friend_number, UserStatus status, void* user_data) {
      var bot = user_data as Bot;
      var name = handle.friend_get_name(friend_number, null);
      string _status = "Offline";

      switch (status) {
        case UserStatus.NONE:
          _status = "Online";
          break;
        case UserStatus.AWAY:
          _status = "Away";
          break;
        case UserStatus.BUSY:
          _status = "Busy";
          break;
        default:
          _status = "Offline";
          break;
      }

      stdout.printf("%s is now %s\n", name, _status);
    }

    public bool save_data () {
      info("Saving data to " + TOX_SAVE);
      var buffer = handle.get_savedata();
      return FileUtils.set_data(TOX_SAVE, buffer);
    }

    public static void main() {
      var bot = new ToxVapi.Bot();
      bot.save_data();    // always save data on exit
    }

    class Server : Object {
      public string maintainer { get; set; }
      public string location { get; set; }
      public string ipv4 { get; set; }
      public string ipv6 { get; set; }
      public uint64 port { get; set; }
      public string public_key { get; set; }
    }

    class Tools {
      public static uint8[] hex2bin (string s) {
        uint8[] buf = new uint8[s.length / 2];
        for (int i = 0; i < buf.length; ++i) {
          int b = 0;
          s.substring(2 * i, 2).scanf("%02x", ref b);
          buf[i] = (uint8) b;
        }
        return buf;
      }
      public static string bin2hex (uint8[] bin) {
        var b = new StringBuilder();
        for (var i = 0; i < bin.length; ++i) {
          b.append("%02X".printf(bin[i]));
        }
        return b.str;
      }
      public static string arr2str (uint8[] array) {
        uint8[] name = new uint8[array.length + 1];
        GLib.Memory.copy(name, array, sizeof(uint8) * name.length);
        name[array.length] = '\0';
        return ((string) name).to_string();
      }
    }
  }

}
