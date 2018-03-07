using ToxCore;

namespace ToxVapi {
  public class Bot : Object {
    private const string BOT_NAME = "RicinBot";
    private const string BOT_MOOD = "A simple bot in Vala - https://github.com/RicinApp/tox-vapi";
    private const string GROUP_NAME = "Official Ricin's groupchat - https://github.com/RicinApp/Ricin";
    private string TOX_SAVE = "Bot.tox";

    private Tox handle;

    private bool connected = false;
    private int group_number;

    private MainLoop loop = new MainLoop();

    public Bot() {
      print("Running Toxcore version %u.%u.%u\n",
            ToxCore.Version.MAJOR, ToxCore.Version.MINOR, ToxCore.Version.PATCH);

      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(ref err_options_new);
      options.ipv6_enabled = true;
      options.udp_enabled = true;
      options.proxy_type = ProxyType.NONE;

      if (FileUtils.test(TOX_SAVE, FileTest.EXISTS)) {
        uint8[] savedata;
        FileUtils.get_data(TOX_SAVE, out savedata);
        options.savedata_type = SaveDataType.TOX_SAVE;
        options.set_savedata_data(savedata);
      }

      var err_new = ErrNew.OK;
      handle = new Tox(options, ref err_new);

      bootstrap.begin();

      var err_set_info = ErrSetInfo.OK;
      handle.self_set_name(BOT_NAME, ref err_set_info);
      handle.self_set_status_message(BOT_MOOD, ref err_set_info);

      var name = handle.self_get_name();
      print("Tox name: %s\n", name);

      var toxid = handle.self_get_address();
      print("ToxID: %s\n", Tools.bin2hex(toxid));

      // // Callbacks.
      // this.handle.callback_self_connection_status((handle, status) => {
      //   if (status != ConnectionStatus.NONE) {
      //     print("Connected to Tox\n");
      //     connected = true;
      //   } else {
      //     print("Disconnected\n");
      //     connected = false;
      //   }
      // });
      // this.handle.callback_friend_message(this.on_friend_message);
      // this.handle.callback_friend_request(this.on_friend_request);
      // this.handle.callback_friend_status(this.on_friend_status);
      //
      // // TEMP DEV ZONE
      // this.group_number = this.handle.add_groupchat();
      // this.handle.group_set_title(this.group_number, "Ricin groupchat".data);
      //
      // this.handle.callback_group_message((self, group_number, peer_number, message) => {
      //   if (this.handle.group_peernumber_is_ours(group_number, peer_number) == 1) {
      //     return;
      //   }
      //
      //   string message_string = Tools.arr2str(message);
      //   debug(@"$peer_number: $message_string");
      // });
      //
      // this.handle.callback_group_action((self, group_number, peer_number, action) => {
      //   string action_string = Tools.arr2str(action);
      //   debug(@"* $peer_number $action_string");
      // });
      //
      // this.handle.callback_group_title((self, group_number, peer_number, title) => {
      //   this.handle.group_message_send(group_number, @"$peer_number changed topic to $(Tools.arr2str(title))".data);
      // });
      // // TEMP DEV ZONE

      tox_loop();
      loop.run();
    }

    void tox_loop () {
      var interval = handle.iteration_interval();
      Timeout.add(interval, () => {
        handle.iterate(this);
        tox_loop();
        return Source.REMOVE;
      });
    }

    class Server : Object {
      public string maintainer { get; set; }
      public string location { get; set; }
      public string ipv4 { get; set; }
      public string ipv6 { get; set; }
      public uint64 port { get; set; }
      public string public_key { get; set; }
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
            print("Bootstrapping to %s:%llu by %s\n", servers[index].ipv4, servers[index].port, servers[index].maintainer);
            var err_bootstrap = ErrBootstrap.OK;
            handle.bootstrap(
              servers[index].ipv4,
              (uint16) servers[index].port,
              Tools.hex2bin(servers[index].public_key),
              ref err_bootstrap
              );
          }

          // wait 5 seconds without blocking main loop
          Timeout.add(5000, () => {
            bootstrap.callback ();
            return Source.REMOVE;
          });
          yield;
        }
        print("Done bootstrapping\n");
      }
    }
    //
    // public void on_friend_message (Tox handle, uint32 friend_number, MessageType type, uint8[] message) {
    //   string message_string = (string) message;
    //   uint8[] result = new uint8[MAX_NAME_LENGTH];
    //   this.handle.friend_get_name(friend_number, result, null);
    //   print("%s: %s\n", (string) result, message_string);
    //
    //   if (message_string.has_prefix("add ")) {
    //     var tox_id = message_string.splice(0, 4);
    //     var _message = "Add me plz ?";
    //     print("Sending a friend request to %s: \"%s\"\n", tox_id, _message);
    //     uint32 friend_num = this.handle.friend_add(Tools.hex2bin(tox_id), _message.data, null);
    //     print("friend_num == %u\n", friend_num);
    //     return;
    //   }
    //
    //   switch (message_string.down()) {
    //     case "invite":
    //       this.handle.invite_friend((int32) friend_number, this.group_number);
    //       break;
    //     case "help":
    //       var response_message = "Available commands:\n";
    //       response_message += "about - Print informations about the bot.\n";
    //       response_message += "delfr - Make the bot delete you from it friend-list.\n";
    //       response_message += "save  - Save the .tox profile of the bot. [DEBUG ONLY]\n";
    //       response_message += "version - Display the bot version.";
    //
    //       this.handle.friend_send_message(friend_number, MessageType.ACTION, response_message.data, null);
    //       break;
    //     case "id":
    //       uint8[] toxid = new uint8[ADDRESS_SIZE];
    //       this.handle.self_get_address(toxid);
    //       var response_message = "My ToxID: " + Tools.bin2hex(toxid);
    //       this.handle.friend_send_message(friend_number, MessageType.NORMAL, response_message.data, null);
    //       break;
    //     case "about":
    //       var response_message = "Hi %s! I'm a simple bot developed to test Vala bindings to Tox. (I don't support groupchats)".printf((string) result);
    //       this.handle.friend_send_message(friend_number, MessageType.NORMAL, response_message.data, null);
    //       break;
    //     case "save":
    //       this.handle.friend_send_message(friend_number, MessageType.ACTION, "is saving it .tox file.".data, null);
    //       this.save_data();
    //       break;
    //     case "delfr":
    //       this.handle.friend_send_message(friend_number, MessageType.ACTION, "deleted you. Don't forget to delete it too.".data, null);
    //       this.handle.friend_delete(friend_number, null);
    //       break;
    //     case "version":
    //       var response_message = "Current version: d02cffe163";
    //       this.handle.friend_send_message(friend_number, MessageType.NORMAL, response_message.data, null);
    //       break;
    //     case "quit":
    //       this.handle.friend_send_message(friend_number, MessageType.ACTION, "will now quit Tox network.".data, null);
    //       loop.quit();
    //       break;
    //     default:
    //       var response_message = "Unknown command. Please type `help` to get started. ^-^";
    //       this.handle.friend_send_message(friend_number, MessageType.NORMAL, response_message.data, null);
    //       break;
    //   }
    // }
    //
    // public void on_friend_request (Tox handle, uint8[] public_key, uint8[] message) {
    //   public_key.length = PUBLIC_KEY_SIZE;       // Fix an issue with Vala.
    //   var pkey = Tools.bin2hex(public_key);
    //   var message_string = (string) message;
    //
    //   print("Received a friend request from:\n");
    //   print("--- %s\n", pkey);
    //   print("--- %s\n", message_string);
    //   this.handle.friend_add_norequest(public_key, null);
    //
    //   // Save the friend in the .tox file.
    //   this.save_data();
    // }
    //
    // public void on_friend_status (Tox handle, uint32 friend_number, UserStatus status) {
    //   uint8[] result = new uint8[MAX_NAME_LENGTH];
    //   var name = this.handle.friend_get_name(friend_number, result, null);
    //   string _status = "Offline";
    //
    //   switch (status) {
    //     case UserStatus.NONE:
    //       _status = "Online";
    //       break;
    //     case UserStatus.AWAY:
    //       _status = "Away";
    //       break;
    //     case UserStatus.BUSY:
    //       _status = "Busy";
    //       break;
    //     default:
    //       _status = "Offline";
    //       break;
    //   }
    //
    //   print("%s is now %s\n", Tools.bin2nullterm(result), _status);
    // }

    public bool save_data () {
      info("Saving data to " + TOX_SAVE);
      var buffer = handle.get_savedata();
      return FileUtils.set_data(TOX_SAVE, buffer);
    }
  }

  public class Tools {
    public static uint8[] hex2bin (string s) {
      uint8[] buf = new uint8[s.length / 2];
      for (int i = 0; i < buf.length; ++i) {
        int b = 0;
        s.substring(2 * i, 2).scanf("%02x", ref b);
        buf[i] = (uint8) b;
      }
      return buf;
    }
    public static string bin2hex (uint8[] bin)
    requires(bin.length != 0) {
      StringBuilder b = new StringBuilder();
      for (int i = 0; i < bin.length; ++i) {
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

void main() {
  var bot = new ToxVapi.Bot();
  bot.save_data();    // always save data on exit
}
