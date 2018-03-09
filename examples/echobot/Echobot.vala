using ToxCore;

namespace Examples {
  public class Echobot {
    struct DhtNode {
      public string ip;
      public uint16 port;
      public string key_hex;
      public uint8[] key_bin;
    }

    private static void friend_request_cb(Tox tox, uint8[] public_key, uint8[] message, void* user_data) {
      tox.friend_add_norequest(public_key, null);
    }

    private static void friend_message_cb(Tox tox, uint32 friend_number, MessageType type, uint8[] message, void* user_data) {
      tox.friend_send_message(friend_number, type, (string) message, null);
    }

    private static void self_connection_status_cb(Tox tox, Connection connection_status, void* user_data) {
      switch (connection_status) {
        case Connection.NONE:
          stdout.printf("Offline\n");
          break;
        case Connection.TCP:
          stdout.printf("Online, using TCP\n");
          break;
        case Connection.UDP:
          stdout.printf("Online, using UDP\n");
          break;
      }
    }

    private static uint8[] hex2bin (string s) {
      var buf = new uint8[s.length / 2];
      var b = 0;
      for (var i = 0; i < buf.length; ++i) {
        s.substring(2 * i, 2).scanf("%02x", ref b);
        buf[i] = (uint8) b;
      }
      return buf;
    }

    private static string bin2hex (uint8[] bin) {
      var b = new StringBuilder();
      foreach (var c in bin) {
        b.append("%02X".printf(c));
      }
      return b.str;
    }

    public int run() {
      var tox = new Tox(null, null);
      var name = "Echo Bot";
      tox.self_set_name(name, null);
      var status_message = "Echoing your messages";
      tox.self_set_status_message(status_message, null);

      DhtNode[] nodes = {
        DhtNode() { ip = "130.133.110.14",             port = 33445, key_hex = "461FA3776EF0FA655F1A05477DF1B3B614F7D6B124F7DB1DD4FE3C08B03B640F" },
        DhtNode() { ip = "2001:6f8:1c3c:babe::14:1",   port = 33445, key_hex = "461FA3776EF0FA655F1A05477DF1B3B614F7D6B124F7DB1DD4FE3C08B03B640F" },
        DhtNode() { ip = "sorunome.de",                port = 33445, key_hex = "02807CF4F8BB8FB390CC3794BDF1E8449E9A8392C5D3F2200019DA9F1E812E46" },
        DhtNode() { ip = "178.62.250.138",             port = 33445, key_hex = "788236D34978D1D5BD822F0A5BEBD2C53C64CC31CD3149350EE27D4D9A2F9B6B" },
        DhtNode() { ip = "2a03:b0c0:2:d0::16:1",       port = 33445, key_hex = "788236D34978D1D5BD822F0A5BEBD2C53C64CC31CD3149350EE27D4D9A2F9B6B" },
        DhtNode() { ip = "163.172.136.118",            port = 33445, key_hex = "2C289F9F37C20D09DA83565588BF496FAB3764853FA38141817A72E3F18ACA0B" },
        DhtNode() { ip = "2001:bc8:4400:2100::1c:50f", port = 33445, key_hex = "2C289F9F37C20D09DA83565588BF496FAB3764853FA38141817A72E3F18ACA0B" },
        DhtNode() { ip = "128.199.199.197",            port = 33445, key_hex = "B05C8869DBB4EDDD308F43C1A974A20A725A36EACCA123862FDE9945BF9D3E09" },
        DhtNode() { ip = "2400:6180:0:d0::17a:a001",   port = 33445, key_hex = "B05C8869DBB4EDDD308F43C1A974A20A725A36EACCA123862FDE9945BF9D3E09" },
        DhtNode() { ip = "node.tox.biribiri.org",      port = 33445, key_hex = "F404ABAA1C99A9D37D61AB54898F56793E1DEF8BD46B1038B9D822E8460FAB67" }
      };

      foreach (var node in nodes) {
        node.key_bin = hex2bin(node.key_hex);
        tox.bootstrap(node.ip, node.port, node.key_bin, null);
      }

      var tox_id_bin = tox.self_get_address();
      var tox_id_hex = bin2hex(tox_id_bin).up();

      stdout.printf(@"Tox ID $tox_id_hex\n");

      tox.callback_friend_request(friend_request_cb);
      tox.callback_friend_message(friend_message_cb);

      tox.callback_self_connection_status(self_connection_status_cb);

      while (true) {
        tox.iterate(this);
        Posix.usleep(tox.iteration_interval() * 1000);
      }
    }

    public static int main(string[] args) {
      foreach (var arg in args) {
        if (arg == "--help" || arg == "-h") {
          stdout.printf("Usage: %s\n", args[0]);
          return 0;
        }
      }
      var echobot = new Echobot();
      return echobot.run();
    }
  }
}
