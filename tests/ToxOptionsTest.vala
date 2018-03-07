
using ToxCore;
namespace Tests {
  public class ToxOptionsTest {
    private const string PREFIX = "/toxoptions/";

    private static void test_create() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(ref err_options_new);
      assert(err_options_new == ErrOptionsNew.OK);
      assert(options != null);
    }

    private static void test_properties_defaults_impl(Options options) {
      assert(options.ipv6_enabled);
      assert(options.udp_enabled);
      assert(options.local_discovery_enabled);
      assert(options.proxy_type == ProxyType.NONE);
      assert(options.proxy_host == null);
      assert(options.proxy_port == 0);
      assert(options.start_port == 0);
      assert(options.end_port == 0);
      assert(options.tcp_port == 0);
      assert(options.hole_punching_enabled);
      assert(options.savedata_type == SaveDataType.NONE);
      assert(options.get_savedata_data() == null);

      //FIXME log_callback
    }

    private static void test_properties_defaults() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(ref err_options_new);

      test_properties_defaults_impl(options);

    }

    private static void test_properties_setters_impl(Options options, uint8[] data) {
      options.ipv6_enabled = false;
      options.udp_enabled = false;
      options.local_discovery_enabled = false;
      options.proxy_type = ProxyType.SOCKS5;
      options.ipv6_enabled = false;
      options.ipv6_enabled = false;
      options.proxy_host = "something";
      options.proxy_port = 1;
      options.start_port = 1;
      options.end_port = 1;
      options.tcp_port = 1;
      options.hole_punching_enabled = false;
      options.savedata_type = SaveDataType.TOX_SAVE;
      options.set_savedata_data(data);
    }

    private static void test_properties_setters() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(ref err_options_new);

      var data = new uint8[] { 1, 2, 3 };
      test_properties_setters_impl(options, data);

      assert(!options.ipv6_enabled);
      assert(!options.udp_enabled);
      assert(!options.local_discovery_enabled);
      assert(options.proxy_type == ProxyType.SOCKS5);
      assert(options.proxy_host == "something");
      assert(options.proxy_port == 1);
      assert(options.start_port == 1);
      assert(options.end_port == 1);
      assert(options.tcp_port == 1);
      assert(!options.hole_punching_enabled);
      assert(options.savedata_type == SaveDataType.TOX_SAVE);

      assert(options.get_savedata_data().length == data.length);
      assert(Memory.cmp(data, options.get_savedata_data(), data.length) == 0);

      //FIXME log_callback
    }

    private static void test_properties_reset() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(ref err_options_new);
      var data = new uint8[] { 1, 2, 3 };
      test_properties_setters_impl(options, data);
      options.default ();
      test_properties_defaults_impl(options);
    }

    public static int main(string[] args) {
      Test.init(ref args);
      Test.add_func(PREFIX + "test_create", test_create);
      Test.add_func(PREFIX + "test_properties_defaults", test_properties_defaults);
      Test.add_func(PREFIX + "test_properties_setters", test_properties_setters);
      Test.add_func(PREFIX + "test_properties_reset", test_properties_reset);
      Test.run();
      return 0;
    }
  }
}
