using ToxCore;

namespace Tests {
  public class ToxCoreTest {
    private const string PREFIX = "/toxcore/";

    private static void add_dummy_friend(Tox tox) {
      var address = new uint8[address_size()];
      var err_friend_add = ErrFriendAdd.OK;
      var ret = tox.friend_add(address, "dummy", out err_friend_add);
      assert(err_friend_add == ErrFriendAdd.OK);
      assert(ret == 0);
    }

    private static void test_constants() {
      assert(public_key_size() != 0);
      assert(public_key_size() == PUBLIC_KEY_SIZE);
      assert(secret_key_size() != 0);
      assert(secret_key_size() == SECRET_KEY_SIZE);
      assert(conference_uid_size() != 0);
      assert(conference_uid_size() == CONFERENCE_UID_SIZE);
      assert(conference_id_size() != 0);
      assert(conference_id_size() == CONFERENCE_ID_SIZE);
      assert(nospam_size() != 0);
      assert(nospam_size() == NOSPAM_SIZE);
      assert(address_size() != 0);
      assert(address_size() == ADDRESS_SIZE);
      assert(max_name_length() != 0);
      assert(max_name_length() == MAX_NAME_LENGTH);
      assert(max_status_message_length() != 0);
      assert(max_status_message_length() == MAX_STATUS_MESSAGE_LENGTH);
      assert(max_friend_request_length() != 0);
      assert(max_friend_request_length() == MAX_FRIEND_REQUEST_LENGTH);
      assert(max_message_length() != 0);
      assert(max_message_length() == MAX_MESSAGE_LENGTH);
      assert(max_custom_packet_size() != 0);
      assert(max_custom_packet_size() == MAX_CUSTOM_PACKET_SIZE);
      assert(hash_length() != 0);
      assert(hash_length() == HASH_LENGTH);
      assert(file_id_length() != 0);
      assert(file_id_length() == FILE_ID_LENGTH);
      assert(max_filename_length() != 0);
      assert(max_filename_length() == MAX_FILENAME_LENGTH);
      assert(max_hostname_length() != 0);
      assert(max_hostname_length() == MAX_HOSTNAME_LENGTH);
    }

    private static void test_version() {
      assert(ToxCore.Version.major() == ToxCore.Version.MAJOR);
      assert(ToxCore.Version.minor() == ToxCore.Version.MINOR);
      assert(ToxCore.Version.patch() == ToxCore.Version.PATCH);
      assert(ToxCore.Version.is_compatible(ToxCore.Version.MAJOR, ToxCore.Version.MINOR, ToxCore.Version.PATCH));
    }

    private static void test_create_null_options() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(err_new == ErrNew.OK);
      assert(tox != null);
    }

    private static void test_create() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(out err_options_new);
      assert(err_options_new == ErrOptionsNew.OK);

      var err_new = ErrNew.OK;
      var tox = new Tox(options, out err_new);
      assert(err_new == ErrNew.OK);
      assert(tox != null);
    }

    private static void test_create_bad_save_format() {
      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(out err_options_new);
      assert(err_options_new == ErrOptionsNew.OK);
      options.savedata_type = SaveDataType.TOX_SAVE;
      var savedata = new uint8[] { 0xba, 0xad, 0xba, 0xad };
      options.set_savedata_data(savedata);

      var err_new = ErrNew.OK;
      var tox = new Tox(options, out err_new);
      assert(err_new == ErrNew.LOAD_BAD_FORMAT);
      assert(tox == null);
    }

    private static void test_get_savedata() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var savedata = tox.get_savedata();
      assert(savedata != null);
      assert(savedata.length > 0);
    }

    private static void test_savedata_restore() {
      uint8[] ? savedata = null;
      var err_new = ErrNew.OK;
      {
        var tox = new Tox(null, out err_new);
        savedata = tox.get_savedata();
      }

      var err_options_new = ErrOptionsNew.OK;
      var options = new Options(out err_options_new);
      assert(err_options_new == ErrOptionsNew.OK);
      options.savedata_type = SaveDataType.TOX_SAVE;
      options.set_savedata_data(savedata);

      var tox = new Tox(options, out err_new);
      assert(err_new == ErrNew.OK);
      assert(tox != null);
    }

    private static void test_iterate() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(tox.iteration_interval() != 0);
      tox.iterate(null);
    }

    private static void test_add_tcp_relay() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_bootstrap = ErrBootstrap.OK;
      var public_key = new uint8[public_key_size()];
      var ret = tox.add_tcp_relay("dummyaddress", 0, public_key, out err_bootstrap);
      assert(err_bootstrap == ErrBootstrap.BAD_PORT);
      assert(!ret);
    }

    private static void test_bootstrap() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var public_key = new uint8[public_key_size()];
      var err_bootstrap = ErrBootstrap.OK;
      var ret = tox.bootstrap("dummyaddress", 0, public_key, out err_bootstrap);
      assert(err_bootstrap == ErrBootstrap.BAD_PORT);
      assert(!ret);
    }

    private static void test_self_get_address() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);

      var id = tox.self_get_address();
      assert(id != null);
      assert(id.length == address_size());
    }

    private static void test_self_get_friend_list() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(tox.self_get_friend_list().length == 0);
      add_dummy_friend(tox);
      assert(tox.self_get_friend_list().length == 1);
    }

    private static void test_self_dht_id() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);

      var id = tox.self_get_dht_id();
      assert(id != null);
      assert(id.length == public_key_size());
    }

    private static void test_self_get_name() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var name = tox.self_get_name();
      assert(name != null);
      assert(name == "");
    }

    private static void test_self_set_name() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_set_info = ErrSetInfo.OK;
      var ret = tox.self_set_name("name", out err_set_info);
      assert(ret);
      assert(err_set_info == ErrSetInfo.OK);

      var name = tox.self_get_name();
      assert(name != null);
      assert(name == "name");

      ret = tox.self_set_name("", out err_set_info);
      assert(ret);
      assert(err_set_info == ErrSetInfo.OK);

      name = tox.self_get_name();
      assert(name != null);
      assert(name == "");
    }

    private static void test_self_get_public_key() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var public_key = tox.self_get_public_key();
      assert(public_key != null);
      assert(public_key.length == public_key_size());
    }

    private static void test_self_get_secret_key() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var secret_key = tox.self_get_secret_key();
      assert(secret_key != null);
      assert(secret_key.length == secret_key_size());
    }

    private static void test_self_get_status_message() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var status_message = tox.self_get_status_message();
      assert(status_message != null);
      assert(status_message == "");
    }

    private static void test_self_set_status_message() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_set_info = ErrSetInfo.OK;
      var ret = tox.self_set_status_message("message", out err_set_info);
      assert(ret);
      assert(err_set_info == ErrSetInfo.OK);

      var message = tox.self_get_status_message();
      assert(message != null);
      assert(message == "message");

      ret = tox.self_set_status_message("", out err_set_info);
      assert(ret);
      assert(err_set_info == ErrSetInfo.OK);

      message = tox.self_get_status_message();
      assert(message != null);
      assert(message == "");
    }

    private static void test_self_get_tcp_port() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_get_port = ErrGetPort.OK;
      var port = tox.self_get_tcp_port(out err_get_port);
      assert(err_get_port == ErrGetPort.NOT_BOUND);
      assert(port == 0);
    }

    private static void test_self_get_udp_port() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_get_port = ErrGetPort.OK;
      var port = tox.self_get_udp_port(out err_get_port);
      assert(err_get_port == ErrGetPort.OK);
      assert(port != 0);
    }

    private static void test_self_set_typing() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_set_typing = ErrSetTyping.OK;
      var ret = tox.self_set_typing(0, true, out err_set_typing);
      assert(err_set_typing == ErrSetTyping.FRIEND_NOT_FOUND);
      assert(!ret);

      add_dummy_friend(tox);
      ret = tox.self_set_typing(0, true, out err_set_typing);
      assert(err_set_typing == ErrSetTyping.OK);
      assert(ret);
    }

    private static void test_self_status() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(tox.self_status == UserStatus.NONE);
      tox.self_status = UserStatus.AWAY;
      assert(tox.self_status == UserStatus.AWAY);
    }

    private static void test_self_nospam() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(tox.self_nospam != 0);
      tox.self_nospam = 0;
      assert(tox.self_nospam == 0);
    }

    private static void test_friend_add() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);

      add_dummy_friend(tox);
    }

    private static void test_friend_add_norequest() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);

      var address = new uint8[address_size()];
      var err_friend_add = ErrFriendAdd.OK;
      var ret = tox.friend_add_norequest(address, out err_friend_add);
      assert(err_friend_add == ErrFriendAdd.OK);
      assert(ret == 0);
    }

    private static void test_friend_exists() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      assert(!tox.friend_exists(0));
      add_dummy_friend(tox);
      assert(tox.friend_exists(0));
    }

    private static void test_friend_by_public_key() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var address = new uint8[public_key_size()];
      var err_friend_by_public_key = ErrFriendByPublicKey.OK;
      var ret = tox.friend_by_public_key(address, out err_friend_by_public_key);
      assert(ret == uint32.MAX);
      assert(err_friend_by_public_key == ErrFriendByPublicKey.NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_by_public_key(address, out err_friend_by_public_key);
      assert(ret == 0);
      assert(err_friend_by_public_key == ErrFriendByPublicKey.OK);
    }

    private static void test_friend_last_online() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_get_last_online = ErrFriendGetLastOnline.OK;
      var ret = tox.friend_get_last_online(0, out err_friend_get_last_online);
      assert(ret == uint64.MAX);
      assert(err_friend_get_last_online == ErrFriendGetLastOnline.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_get_last_online(0, out err_friend_get_last_online);
      assert(ret == 0);
      assert(err_friend_get_last_online == ErrFriendGetLastOnline.OK);
    }

    private static void test_friend_get_name() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_query = ErrFriendQuery.OK;
      var ret = tox.friend_get_name(0, out err_friend_query);
      assert(ret == null);
      assert(err_friend_query == ErrFriendQuery.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_get_name(0, out err_friend_query);
      assert(ret != null);
      assert(ret.length == 0);
      assert(err_friend_query == ErrFriendQuery.OK);
    }

    private static void test_friend_get_public_key() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_get_public_key = ErrFriendGetPublicKey.OK;
      var ret = tox.friend_get_public_key(0, out err_friend_get_public_key);
      assert(ret == null);
      assert(err_friend_get_public_key == ErrFriendGetPublicKey.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_get_public_key(0, out err_friend_get_public_key);
      assert(ret != null);
      assert(ret.length == public_key_size());
      assert(err_friend_get_public_key == ErrFriendGetPublicKey.OK);
    }

    private static void test_friend_get_status_message() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_query = ErrFriendQuery.OK;
      var ret = tox.friend_get_status_message(0, out err_friend_query);
      assert(ret == null);
      assert(err_friend_query == ErrFriendQuery.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_get_status_message(0, out err_friend_query);
      assert(ret != null);
      assert(ret.length == 0);
      assert(err_friend_query == ErrFriendQuery.OK);
    }

    private static void test_friend_send_lossless_packet() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var data = new uint8[] { 180, 1, 2, 3 };
      var invalid_data = new uint8[] { 0, 1, 2, 3 };
      var err_friend_custom_packet = ErrFriendCustomPacket.OK;
      var ret = tox.friend_send_lossless_packet(0, data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.FRIEND_NOT_FOUND);
      assert(!ret);

      add_dummy_friend(tox);
      ret = tox.friend_send_lossless_packet(0, data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.FRIEND_NOT_CONNECTED);
      assert(!ret);

      ret = tox.friend_send_lossless_packet(0, invalid_data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.INVALID);
      assert(!ret);
    }

    private static void test_friend_send_lossy_packet() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var data = new uint8[] { 210, 1, 2, 3 };
      var invalid_data = new uint8[] { 0, 1, 2, 3 };
      var err_friend_custom_packet = ErrFriendCustomPacket.OK;
      var ret = tox.friend_send_lossy_packet(0, data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.FRIEND_NOT_FOUND);
      assert(!ret);

      add_dummy_friend(tox);
      ret = tox.friend_send_lossy_packet(0, data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.FRIEND_NOT_CONNECTED);
      assert(!ret);

      ret = tox.friend_send_lossy_packet(0, invalid_data, out err_friend_custom_packet);
      assert(err_friend_custom_packet == ErrFriendCustomPacket.INVALID);
      assert(!ret);
    }

    private static void test_friend_send_message() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_send_message = ErrFriendSendMessage.OK;
      var ret = tox.friend_send_message(0, MessageType.NORMAL, "test", out err_friend_send_message);
      assert(err_friend_send_message == ErrFriendSendMessage.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);
      ret = tox.friend_send_message(0, MessageType.NORMAL, "test", out err_friend_send_message);
      assert(err_friend_send_message == ErrFriendSendMessage.FRIEND_NOT_CONNECTED);

      ret = tox.friend_send_message(0, MessageType.NORMAL, "", out err_friend_send_message);
      assert(err_friend_send_message == ErrFriendSendMessage.EMPTY);
    }

    private static void test_friend_delete() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_friend_delete = ErrFriendDelete.OK;
      var ret = tox.friend_delete(0, out err_friend_delete);
      assert(!ret);
      assert(err_friend_delete == ErrFriendDelete.FRIEND_NOT_FOUND);

      add_dummy_friend(tox);

      ret = tox.friend_delete(0, out err_friend_delete);
      assert(ret);
      assert(err_friend_delete == ErrFriendDelete.OK);
    }

    private static void test_file_control() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_file_control = ErrFileControl.OK;
      var ret = tox.file_control(0, 0, FileControl.CANCEL, out err_file_control);
      assert(err_file_control == ErrFileControl.FRIEND_NOT_FOUND);
      assert(!ret);

      add_dummy_friend(tox);
      ret = tox.file_control(0, 0, FileControl.CANCEL, out err_file_control);
      assert(err_file_control == ErrFileControl.FRIEND_NOT_CONNECTED);
      assert(!ret);
    }

    private static void test_file_get_file_id() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_file_get = ErrFileGet.OK;
      var ret = tox.file_get_file_id(0, 0, out err_file_get);
      assert(err_file_get == ErrFileGet.FRIEND_NOT_FOUND);
      assert(ret == null);

      add_dummy_friend(tox);
      ret = tox.file_get_file_id(0, 0, out err_file_get);
      assert(err_file_get == ErrFileGet.NOT_FOUND);
      assert(ret == null);
    }

    private static void test_file_seek() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_file_seek = ErrFileSeek.OK;
      var ret = tox.file_seek(0, 0, 0, out err_file_seek);
      assert(err_file_seek == ErrFileSeek.FRIEND_NOT_FOUND);
      assert(!ret);

      add_dummy_friend(tox);
      ret = tox.file_seek(0, 0, 0, out err_file_seek);
      assert(err_file_seek == ErrFileSeek.FRIEND_NOT_CONNECTED);
      assert(!ret);
    }

    private static void test_file_send() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_file_send = ErrFileSend.OK;
      var ret = tox.file_send(0, FileKind.DATA, 0, null, "filename", out err_file_send);
      assert(err_file_send == ErrFileSend.FRIEND_NOT_FOUND);
      assert(ret == uint32.MAX);

      add_dummy_friend(tox);
      ret = tox.file_send(0, FileKind.DATA, 0, null, "filename", out err_file_send);
      assert(err_file_send == ErrFileSend.FRIEND_NOT_CONNECTED);
      assert(ret == uint32.MAX);
    }

    private static void test_file_send_chunk() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var data = new uint8[] { 0, 1, 2, 3 };
      var err_file_send_chunk = ErrFileSendChunk.OK;
      var ret = tox.file_send_chunk(0, 0, 0, data, out err_file_send_chunk);
      assert(err_file_send_chunk == ErrFileSendChunk.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_conference_delete() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_delete = ErrConferenceDelete.OK;
      var ret = tox.conference_delete(0, out err_conference_delete);
      assert(err_conference_delete == ErrConferenceDelete.CONFERENCE_NOT_FOUND);
      assert(!ret);

      var err_conference_new = ErrConferenceNew.OK;
      tox.conference_new(out err_conference_new);

      ret = tox.conference_delete(0, out err_conference_delete);
      assert(err_conference_delete == ErrConferenceDelete.OK);
      assert(ret);
    }

    private static void test_conference_get_chatlist() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var ret = tox.conference_get_chatlist();
      assert(ret.length == 0);

      var err_conference_new = ErrConferenceNew.OK;
      tox.conference_new(out err_conference_new);

      ret = tox.conference_get_chatlist();
      assert(ret.length == 1);
      assert(ret[0] == 0);
    }

    private static void test_conference_get_title() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_title = ErrConferenceTitle.OK;
      var ret = tox.conference_get_title(0, out err_conference_title);
      assert(err_conference_title == ErrConferenceTitle.CONFERENCE_NOT_FOUND);
      assert(ret == null);

      var err_conference_new = ErrConferenceNew.OK;
      tox.conference_new(out err_conference_new);

      ret = tox.conference_get_title(0, out err_conference_title);
      assert(err_conference_title == ErrConferenceTitle.INVALID_LENGTH);
      assert(ret == null);
    }

    private static void test_conference_get_type() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_get_type = ErrConferenceGetType.OK;
      tox.conference_get_type(0, out err_conference_get_type);
      assert(err_conference_get_type == ErrConferenceGetType.CONFERENCE_NOT_FOUND);

      var err_conference_new = ErrConferenceNew.OK;
      tox.conference_new(out err_conference_new);

      var ret = tox.conference_get_type(0, out err_conference_get_type);
      assert(err_conference_get_type == ErrConferenceGetType.OK);
      assert(ret == ConferenceType.TEXT);
    }

    private static void test_conference_invite() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_invite = ErrConferenceInvite.OK;
      var ret = tox.conference_invite(0, 0, out err_conference_invite);
      assert(err_conference_invite == ErrConferenceInvite.CONFERENCE_NOT_FOUND);
      assert(!ret);
    }

    private static void test_conference_join() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var cookie = new uint8[] { 1, 2, 3 };
      var err_conference_join = ErrConferenceJoin.OK;
      var ret = tox.conference_join(0, cookie, out err_conference_join);
      assert(err_conference_join == ErrConferenceJoin.INVALID_LENGTH);
      assert(ret == uint32.MAX);
    }

    private static void test_conference_new() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_new = ErrConferenceNew.OK;
      var ret = tox.conference_new(out err_conference_new);
      assert(err_conference_new == ErrConferenceNew.OK);
      assert(ret == 0);
    }

    private static void test_conference_peer_count() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      tox.conference_peer_count(0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
    }

    private static void test_conference_peer_get_name() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var ret = tox.conference_peer_get_name(0, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
      assert(ret == null);
    }

    private static void test_conference_peer_get_public_key() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var ret = tox.conference_peer_get_public_key(0, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
      assert(ret == null);
    }

    private static void test_conference_peer_number_is_ours() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var ret = tox.conference_peer_number_is_ours(0, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
      assert(!ret);
    }

    private static void test_conference_send_message() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_send_message = ErrConferenceSendMessage.OK;
      var ret = tox.conference_send_message(0, MessageType.NORMAL, "message", out err_conference_send_message);
      assert(err_conference_send_message == ErrConferenceSendMessage.CONFERENCE_NOT_FOUND);
      assert(!ret);
    }

    private static void test_conference_set_title() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_title = ErrConferenceTitle.OK;
      var ret = tox.conference_set_title(0, "title", out err_conference_title);
      assert(err_conference_title == ErrConferenceTitle.CONFERENCE_NOT_FOUND);
      assert(!ret);
    }

    private static void test_conference_get_id() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var ret = tox.conference_get_id(0);
      assert(ret == null);
    }

    private static void test_conference_get_by_id() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var id = new uint8[CONFERENCE_ID_SIZE];
      var err_conference_by_id = ErrConferenceById.OK;
      var ret = tox.conference_by_id(id, out err_conference_by_id);
      assert(err_conference_by_id == ErrConferenceById.NOT_FOUND);
    }

    private static void test_conference_get_id_matches_get_by_id() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      var err_conference_new = ErrConferenceNew.OK;
      var ret = tox.conference_new(out err_conference_new);

      assert(err_conference_new == ErrConferenceNew.OK);
      assert(ret == 0);

      var id = tox.conference_get_id(ret);
      assert(id != null);

      var err_conference_by_id = ErrConferenceById.OK;
      var conference_number = tox.conference_by_id(id, out err_conference_by_id);
      assert(err_conference_by_id == ErrConferenceById.OK);
      assert(conference_number == ret);
    }

    private static void test_conference_restore() {
      uint8[] ? savedata = null;
      uint8[] ? conference_id = null;
      {
        var tox = new Tox();
        conference_id = tox.conference_get_id(tox.conference_new());
        savedata = tox.get_savedata();
      }

      var options = new Options();
      options.savedata_type = SaveDataType.TOX_SAVE;
      options.set_savedata_data(savedata);
      var tox = new Tox(options);

      assert(conference_id != null);
      assert(conference_id.length == conference_id_size());

      var chatlist = tox.conference_get_chatlist();
      assert(chatlist != null && chatlist.length == 1);

      var conference_id_new = tox.conference_get_id(chatlist[0]);
      assert(conference_id_new != null);
      assert(conference_id_new.length == conference_id_size());
      assert(Memory.cmp(conference_id, conference_id_new, conference_id.length) == 0);
    }

    private static void test_conference_offline_peer_count_when_nonexistent() {
      var tox = new Tox();
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      tox.conference_offline_peer_count(0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
    }

    private static void test_conference_offline_peer_count_when_not_connected() {
      var tox = new Tox();
      var conference_number = tox.conference_new();
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var offline_peer_count = tox.conference_offline_peer_count(conference_number, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.OK);
      assert(offline_peer_count == 0);
    }

    private static void test_conference_offline_peer_get_name() {
      var tox = new Tox();
      var conference_number = tox.conference_new();
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var name = tox.conference_offline_peer_get_name(conference_number, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.PEER_NOT_FOUND);
      assert(name == null);
    }

    private static void test_conference_offline_peer_get_public_key() {
      var tox = new Tox();
      var conference_number = tox.conference_new();
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var key = tox.conference_offline_peer_get_public_key(conference_number, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.PEER_NOT_FOUND);
      assert(key == null);
    }

    private static void test_conference_offline_peer_get_last_active() {
      var tox = new Tox();
      var conference_number = tox.conference_new();
      var err_conference_peer_query = ErrConferencePeerQuery.OK;
      var timestamp = tox.conference_offline_peer_get_last_active(conference_number, 0, out err_conference_peer_query);
      assert(err_conference_peer_query == ErrConferencePeerQuery.PEER_NOT_FOUND);
    }

    private static void test_conference_set_max_offline() {
      var tox = new Tox();
      var conference_number = tox.conference_new();
      var err = ErrConferenceSetMaxOffline.OK;
      var ret = tox.conference_set_max_offline(conference_number, 5, out err);
      assert(err == ErrConferenceSetMaxOffline.OK);
      assert(ret == true);
    }

    private static void test_hash() {
      var data1 = new uint8[] { 0, 1, 2, 3, 4 };
      var data2 = new uint8[] { 0, 1, 2, 3, 4 };
      var data3 = new uint8[] { 0, 1, 2, 3, 3 };
      var data4 = new uint8[] { 0, 1, 2, 3 };
      var hash1 = Tox.hash(data1);
      var hash2 = Tox.hash(data2);
      var hash3 = Tox.hash(data3);
      var hash4 = Tox.hash(data4);

      assert(hash1.length == HASH_LENGTH);
      assert(hash2.length == HASH_LENGTH);
      assert(hash3.length == HASH_LENGTH);
      assert(hash4.length == HASH_LENGTH);
      assert(Memory.cmp(hash1, hash2, hash1.length) == 0);
      assert(Memory.cmp(hash1, hash3, hash1.length) != 0);
      assert(Memory.cmp(hash1, hash4, hash1.length) != 0);
    }

    private static void conference_invite_cb(Tox self, uint32 friend_number, ConferenceType type, uint8[] cookie, void* user_data) {}
    private static void conference_message_cb(Tox self, uint32 conference_number, uint32 peer_number, MessageType type, uint8[] message, void* user_data) {}
    private static void conference_peer_list_changed_cb(Tox self, uint32 conference_number, void* user_data) {}
    private static void conference_peer_name_cb(Tox self, uint32 conference_number, uint32 peer_number, uint8[] name, void* user_data) {}
    private static void conference_title_cb(Tox self, uint32 conference_number, uint32 peer_number, uint8[] name, void* user_data) {}
    private static void conference_connected_cb(Tox self, uint32 conference_number, void *user_data) {}
    private static void file_chunk_request_cb(Tox self, uint32 friend_number, uint32 file_number, uint64 position, size_t length, void* user_data) {}
    private static void file_recv_cb(Tox self, uint32 friend_number, uint32 file_number, uint32 kind, uint64 file_size, uint8[] filename, void* user_data) {}
    private static void file_recv_chunk_cb(Tox self, uint32 friend_number, uint32 file_number, uint64 position, uint8[] data, void* user_data) {}
    private static void file_recv_control_cb(Tox self, uint32 friend_number, uint32 file_number, FileControl control, void* user_data) {}
    private static void friend_connection_status_cb(Tox self, uint32 friend_number, Connection connection_status, void* userdata) {}
    private static void friend_lossless_packet_cb(Tox self, uint32 friend_number, uint8[] data, void* user_data) {}
    private static void friend_lossy_packet_cb(Tox self, uint32 friend_number, uint8[] data, void* user_data) {}
    private static void friend_message_cb(Tox self, uint32 friend_number, MessageType type, uint8[] message, void* user_data) {}
    private static void friend_name_cb(Tox self, uint32 friend_number, uint8[] name, void* user_data) {}
    private static void friend_read_receipt_cb(Tox self, uint32 friend_number, uint32 message_id, void* user_data) {}
    private static void friend_request_cb(Tox self, uint8[] public_key, uint8[] message, void* user_data) {}
    private static void friend_status_cb(Tox self, uint32 friend_number, UserStatus status, void* user_data) {}
    private static void friend_status_message_cb(Tox self, uint32 friend_number, uint8[] message, void* user_data) {}
    private static void friend_typing_cb(Tox self, uint32 friend_number, bool is_typing, void* userdata) {}
    private static void self_connection_status_cb(Tox self, Connection connection_status, void* user_data) {}

    private static void test_callbacks() {
      var err_new = ErrNew.OK;
      var tox = new Tox(null, out err_new);
      tox.callback_conference_invite(conference_invite_cb);
      tox.callback_conference_message(conference_message_cb);
      tox.callback_conference_peer_list_changed(conference_peer_list_changed_cb);
      tox.callback_conference_peer_name(conference_peer_name_cb);
      tox.callback_conference_title(conference_title_cb);
      tox.callback_conference_connected(conference_connected_cb);
      tox.callback_file_chunk_request(file_chunk_request_cb);
      tox.callback_file_recv(file_recv_cb);
      tox.callback_file_recv_chunk(file_recv_chunk_cb);
      tox.callback_file_recv_control(file_recv_control_cb);
      tox.callback_friend_connection_status(friend_connection_status_cb);
      tox.callback_friend_lossless_packet(friend_lossless_packet_cb);
      tox.callback_friend_lossy_packet(friend_lossy_packet_cb);
      tox.callback_friend_message(friend_message_cb);
      tox.callback_friend_name(friend_name_cb);
      tox.callback_friend_read_receipt(friend_read_receipt_cb);
      tox.callback_friend_request(friend_request_cb);
      tox.callback_friend_status(friend_status_cb);
      tox.callback_friend_status_message(friend_status_message_cb);
      tox.callback_friend_typing(friend_typing_cb);
      tox.callback_self_connection_status(self_connection_status_cb);
    }

    private static void test_enums() {
      assert(ConferenceType.TEXT != ConferenceType.AV);

      assert(Connection.NONE != Connection.TCP);
      assert(Connection.NONE != Connection.UDP);

      assert(ErrBootstrap.OK != ErrBootstrap.NULL);
      assert(ErrBootstrap.OK != ErrBootstrap.BAD_HOST);
      assert(ErrBootstrap.OK != ErrBootstrap.BAD_PORT);

      assert(ErrConferenceDelete.OK != ErrConferenceDelete.CONFERENCE_NOT_FOUND);

      assert(ErrConferenceGetType.OK != ErrConferenceGetType.CONFERENCE_NOT_FOUND);

      assert(ErrConferenceInvite.OK != ErrConferenceInvite.CONFERENCE_NOT_FOUND);
      assert(ErrConferenceInvite.OK != ErrConferenceInvite.FAIL_SEND);

      assert(ErrConferenceSetMaxOffline.OK != ErrConferenceSetMaxOffline.CONFERENCE_NOT_FOUND);

      assert(ErrConferenceJoin.OK != ErrConferenceJoin.INVALID_LENGTH);
      assert(ErrConferenceJoin.OK != ErrConferenceJoin.WRONG_TYPE);
      assert(ErrConferenceJoin.OK != ErrConferenceJoin.FRIEND_NOT_FOUND);
      assert(ErrConferenceJoin.OK != ErrConferenceJoin.DUPLICATE);
      assert(ErrConferenceJoin.OK != ErrConferenceJoin.INIT_FAIL);
      assert(ErrConferenceJoin.OK != ErrConferenceJoin.FAIL_SEND);

      assert(ErrConferenceNew.OK != ErrConferenceNew.INIT);

      assert(ErrConferencePeerQuery.OK != ErrConferencePeerQuery.CONFERENCE_NOT_FOUND);
      assert(ErrConferencePeerQuery.OK != ErrConferencePeerQuery.PEER_NOT_FOUND);
      assert(ErrConferencePeerQuery.OK != ErrConferencePeerQuery.NO_CONNECTION);

      assert(ErrConferenceSendMessage.OK != ErrConferenceSendMessage.CONFERENCE_NOT_FOUND);
      assert(ErrConferenceSendMessage.OK != ErrConferenceSendMessage.TOO_LONG);
      assert(ErrConferenceSendMessage.OK != ErrConferenceSendMessage.NO_CONNECTION);
      assert(ErrConferenceSendMessage.OK != ErrConferenceSendMessage.FAIL_SEND);

      assert(ErrConferenceTitle.OK != ErrConferenceTitle.CONFERENCE_NOT_FOUND);
      assert(ErrConferenceTitle.OK != ErrConferenceTitle.INVALID_LENGTH);
      assert(ErrConferenceTitle.OK != ErrConferenceTitle.FAIL_SEND);

      assert(ErrConferenceById.OK != ErrConferenceById.NULL);
      assert(ErrConferenceById.OK != ErrConferenceById.NOT_FOUND);

      assert(ErrFileControl.OK != ErrFileControl.FRIEND_NOT_FOUND);
      assert(ErrFileControl.OK != ErrFileControl.FRIEND_NOT_CONNECTED);
      assert(ErrFileControl.OK != ErrFileControl.NOT_FOUND);
      assert(ErrFileControl.OK != ErrFileControl.NOT_PAUSED);
      assert(ErrFileControl.OK != ErrFileControl.DENIED);
      assert(ErrFileControl.OK != ErrFileControl.ALREADY_PAUSED);
      assert(ErrFileControl.OK != ErrFileControl.SENDQ);

      assert(ErrFileGet.OK != ErrFileGet.NULL);
      assert(ErrFileGet.OK != ErrFileGet.FRIEND_NOT_FOUND);
      assert(ErrFileGet.OK != ErrFileGet.NOT_FOUND);

      assert(ErrFileSeek.OK != ErrFileSeek.FRIEND_NOT_FOUND);
      assert(ErrFileSeek.OK != ErrFileSeek.FRIEND_NOT_CONNECTED);
      assert(ErrFileSeek.OK != ErrFileSeek.NOT_FOUND);
      assert(ErrFileSeek.OK != ErrFileSeek.DENIED);
      assert(ErrFileSeek.OK != ErrFileSeek.INVALID_POSITION);
      assert(ErrFileSeek.OK != ErrFileSeek.SENDQ);

      assert(ErrFileSend.OK != ErrFileSend.NULL);
      assert(ErrFileSend.OK != ErrFileSend.FRIEND_NOT_FOUND);
      assert(ErrFileSend.OK != ErrFileSend.FRIEND_NOT_CONNECTED);
      assert(ErrFileSend.OK != ErrFileSend.NAME_TOO_LONG);
      assert(ErrFileSend.OK != ErrFileSend.TOO_MANY);

      assert(ErrFileSendChunk.OK != ErrFileSendChunk.NULL);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.FRIEND_NOT_FOUND);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.FRIEND_NOT_CONNECTED);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.NOT_FOUND);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.NOT_TRANSFERRING);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.INVALID_LENGTH);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.SENDQ);
      assert(ErrFileSendChunk.OK != ErrFileSendChunk.WRONG_POSITION);

      assert(ErrFriendAdd.OK != ErrFriendAdd.NULL);
      assert(ErrFriendAdd.OK != ErrFriendAdd.TOO_LONG);
      assert(ErrFriendAdd.OK != ErrFriendAdd.NO_MESSAGE);
      assert(ErrFriendAdd.OK != ErrFriendAdd.OWN_KEY);
      assert(ErrFriendAdd.OK != ErrFriendAdd.ALREADY_SENT);
      assert(ErrFriendAdd.OK != ErrFriendAdd.BAD_CHECKSUM);
      assert(ErrFriendAdd.OK != ErrFriendAdd.SET_NEW_NOSPAM);
      assert(ErrFriendAdd.OK != ErrFriendAdd.MALLOC);

      assert(ErrFriendByPublicKey.OK != ErrFriendByPublicKey.NULL);
      assert(ErrFriendByPublicKey.OK != ErrFriendByPublicKey.NOT_FOUND);

      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.NULL);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.FRIEND_NOT_FOUND);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.FRIEND_NOT_CONNECTED);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.INVALID);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.EMPTY);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.TOO_LONG);
      assert(ErrFriendCustomPacket.OK != ErrFriendCustomPacket.SENDQ);

      assert(ErrFriendDelete.OK != ErrFriendDelete.FRIEND_NOT_FOUND);

      assert(ErrFriendGetLastOnline.OK != ErrFriendGetLastOnline.FRIEND_NOT_FOUND);

      assert(ErrFriendGetPublicKey.OK != ErrFriendGetPublicKey.FRIEND_NOT_FOUND);

      assert(ErrFriendQuery.OK != ErrFriendQuery.NULL);
      assert(ErrFriendQuery.OK != ErrFriendQuery.FRIEND_NOT_FOUND);

      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.NULL);
      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.FRIEND_NOT_FOUND);
      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.FRIEND_NOT_CONNECTED);
      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.SENDQ);
      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.TOO_LONG);
      assert(ErrFriendSendMessage.OK != ErrFriendSendMessage.EMPTY);

      assert(ErrGetPort.OK != ErrGetPort.NOT_BOUND);

      assert(ErrNew.OK != ErrNew.NULL);
      assert(ErrNew.OK != ErrNew.MALLOC);
      assert(ErrNew.OK != ErrNew.PORT_ALLOC);
      assert(ErrNew.OK != ErrNew.PROXY_BAD_TYPE);
      assert(ErrNew.OK != ErrNew.PROXY_BAD_HOST);
      assert(ErrNew.OK != ErrNew.PROXY_BAD_PORT);
      assert(ErrNew.OK != ErrNew.PROXY_NOT_FOUND);
      assert(ErrNew.OK != ErrNew.LOAD_ENCRYPTED);
      assert(ErrNew.OK != ErrNew.LOAD_BAD_FORMAT);

      assert(ErrOptionsNew.OK != ErrOptionsNew.MALLOC);

      assert(ErrSetInfo.OK != ErrSetInfo.NULL);
      assert(ErrSetInfo.OK != ErrSetInfo.TOO_LONG);

      assert(ErrSetTyping.OK != ErrSetTyping.FRIEND_NOT_FOUND);

      assert(FileControl.RESUME != FileControl.PAUSE);
      assert(FileControl.RESUME != FileControl.CANCEL);

      assert(FileKind.DATA != FileKind.AVATAR);

      assert(LogLevel.TRACE != LogLevel.DEBUG);
      assert(LogLevel.TRACE != LogLevel.INFO);
      assert(LogLevel.TRACE != LogLevel.WARNING);
      assert(LogLevel.TRACE != LogLevel.ERROR);

      assert(MessageType.NORMAL != MessageType.ACTION);

      assert(ProxyType.NONE != ProxyType.HTTP);
      assert(ProxyType.NONE != ProxyType.SOCKS5);

      assert(SaveDataType.NONE != SaveDataType.TOX_SAVE);
      assert(SaveDataType.NONE != SaveDataType.SECRET_KEY);

      assert(UserStatus.NONE != UserStatus.AWAY);
      assert(UserStatus.NONE != UserStatus.BUSY);
    }

    public static int main(string[] args) {
      Test.init(ref args);

      Test.add_func(PREFIX + "test_constants", test_constants);
      Test.add_func(PREFIX + "test_version", test_version);
      Test.add_func(PREFIX + "test_create_null_options", test_create_null_options);
      Test.add_func(PREFIX + "test_create", test_create);
      Test.add_func(PREFIX + "test_create_bad_save_format", test_create_bad_save_format);
      Test.add_func(PREFIX + "test_get_savedata", test_get_savedata);
      Test.add_func(PREFIX + "test_savedata_restore", test_savedata_restore);
      Test.add_func(PREFIX + "test_iterate", test_iterate);
      Test.add_func(PREFIX + "test_bootstrap", test_bootstrap);
      Test.add_func(PREFIX + "test_add_tcp_relay", test_add_tcp_relay);
      Test.add_func(PREFIX + "test_self_get_address", test_self_get_address);
      Test.add_func(PREFIX + "test_self_dht_id", test_self_dht_id);
      Test.add_func(PREFIX + "test_self_get_friend_list", test_self_get_friend_list);
      Test.add_func(PREFIX + "test_self_get_name", test_self_get_name);
      Test.add_func(PREFIX + "test_self_set_name", test_self_set_name);
      Test.add_func(PREFIX + "test_self_get_public_key", test_self_get_public_key);
      Test.add_func(PREFIX + "test_self_get_secret_key", test_self_get_secret_key);
      Test.add_func(PREFIX + "test_self_get_status_message", test_self_get_status_message);
      Test.add_func(PREFIX + "test_self_set_status_message", test_self_set_status_message);
      Test.add_func(PREFIX + "test_self_get_tcp_port", test_self_get_tcp_port);
      Test.add_func(PREFIX + "test_self_get_udp_port", test_self_get_udp_port);
      Test.add_func(PREFIX + "test_self_set_typing", test_self_set_typing);
      Test.add_func(PREFIX + "test_self_status", test_self_status);
      Test.add_func(PREFIX + "test_self_nospam", test_self_nospam);
      Test.add_func(PREFIX + "test_friend_add", test_friend_add);
      Test.add_func(PREFIX + "test_friend_add_norequest", test_friend_add_norequest);
      Test.add_func(PREFIX + "test_friend_exists", test_friend_exists);
      Test.add_func(PREFIX + "test_friend_by_public_key", test_friend_by_public_key);
      Test.add_func(PREFIX + "test_friend_last_online", test_friend_last_online);
      Test.add_func(PREFIX + "test_friend_get_name", test_friend_get_name);
      Test.add_func(PREFIX + "test_friend_get_public_key", test_friend_get_public_key);
      Test.add_func(PREFIX + "test_friend_get_status_message", test_friend_get_status_message);
      Test.add_func(PREFIX + "test_friend_send_lossless_packet", test_friend_send_lossless_packet);
      Test.add_func(PREFIX + "test_friend_send_lossy_packet", test_friend_send_lossy_packet);
      Test.add_func(PREFIX + "test_friend_send_message", test_friend_send_message);
      Test.add_func(PREFIX + "test_friend_delete", test_friend_delete);
      Test.add_func(PREFIX + "test_file_control", test_file_control);
      Test.add_func(PREFIX + "test_file_get_file_id", test_file_get_file_id);
      Test.add_func(PREFIX + "test_file_seek", test_file_seek);
      Test.add_func(PREFIX + "test_file_send", test_file_send);
      Test.add_func(PREFIX + "test_file_send_chunk", test_file_send_chunk);
      Test.add_func(PREFIX + "test_conference_delete", test_conference_delete);
      Test.add_func(PREFIX + "test_conference_get_chatlist", test_conference_get_chatlist);
      Test.add_func(PREFIX + "test_conference_get_title", test_conference_get_title);
      Test.add_func(PREFIX + "test_conference_get_type", test_conference_get_type);
      Test.add_func(PREFIX + "test_conference_invite", test_conference_invite);
      Test.add_func(PREFIX + "test_conference_join", test_conference_join);
      Test.add_func(PREFIX + "test_conference_new", test_conference_new);
      Test.add_func(PREFIX + "test_conference_peer_count", test_conference_peer_count);
      Test.add_func(PREFIX + "test_conference_peer_get_name", test_conference_peer_get_name);
      Test.add_func(PREFIX + "test_conference_peer_get_public_key", test_conference_peer_get_public_key);
      Test.add_func(PREFIX + "test_conference_peer_number_is_ours", test_conference_peer_number_is_ours);
      Test.add_func(PREFIX + "test_conference_send_message", test_conference_send_message);
      Test.add_func(PREFIX + "test_conference_set_title", test_conference_set_title);
      Test.add_func(PREFIX + "test_conference_get_id", test_conference_get_id);
      Test.add_func(PREFIX + "test_conference_get_by_id", test_conference_get_by_id);
      Test.add_func(PREFIX + "test_conference_get_id_matches_get_by_id", test_conference_get_id_matches_get_by_id);
      Test.add_func(PREFIX + "test_conference_restore", test_conference_restore);
      Test.add_func(PREFIX + "test_conference_offline_peer_count_when_nonexistent", test_conference_offline_peer_count_when_nonexistent);
      Test.add_func(PREFIX + "test_conference_offline_peer_count_when_not_connected", test_conference_offline_peer_count_when_not_connected);
      Test.add_func(PREFIX + "test_conference_offline_peer_get_name", test_conference_offline_peer_get_name);
      Test.add_func(PREFIX + "test_conference_offline_peer_get_public_key", test_conference_offline_peer_get_public_key);
      Test.add_func(PREFIX + "test_conference_offline_peer_get_last_active", test_conference_offline_peer_get_last_active);
      Test.add_func(PREFIX + "test_conference_set_max_offline", test_conference_set_max_offline);
      Test.add_func(PREFIX + "test_hash", test_hash);
      Test.add_func(PREFIX + "test_callbacks", test_callbacks);
      Test.add_func(PREFIX + "test_enums", test_enums);

      Test.run();
      return 0;
    }
  }
}
