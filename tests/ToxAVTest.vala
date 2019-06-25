using ToxAV;

namespace Tests {
  public class ToxAVTest {
    private const string PREFIX = "/toxav/";

    private static void test_create() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.OK);
      assert(toxav != null);
    }

    private static void test_create_null() {
      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV((ToxCore.Tox) null, out err_new);
      assert(err_new == ErrNew.NULL);
      assert(toxav == null);
    }

    private static void test_create_multiple() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.OK);
      var toxav2 = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.MULTIPLE);
      assert(toxav != null);
      assert(toxav2 == null);
    }

    private static void test_iterate() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(toxav.iteration_interval() != 0);
      toxav.iterate();
    }

    private static void test_answer() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var err_answer = ErrAnswer.OK;
      var ret = toxav.answer(0, 0, 0, out err_answer);
      assert(err_answer == ErrAnswer.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_audio_send_frame() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var data = new int16[10];
      var err_send_frame = ErrSendFrame.OK;
      var ret = toxav.audio_send_frame(0, data, 1, 1, 8000, out err_send_frame);
      assert(err_send_frame == ErrSendFrame.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_audio_set_bit_rate() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var err_bit_rate_set = ErrBitRateSet.OK;
      var ret = toxav.audio_set_bit_rate(0, 0, out err_bit_rate_set);
      assert(err_bit_rate_set == ErrBitRateSet.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_call() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var err_call = ErrCall.OK;
      var ret = toxav.call(0, 0, 0, out err_call);
      assert(err_call == ErrCall.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_call_control() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var err_call_control = ErrCallControl.OK;
      var ret = toxav.call_control(0, CallControl.RESUME, out err_call_control);
      assert(err_call_control == ErrCallControl.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_video_send_frame() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var data = new uint8[16];
      var err_send_frame = ErrSendFrame.OK;
      var ret = toxav.video_send_frame(0, 4, 4, data, data, data, out err_send_frame);
      assert(err_send_frame == ErrSendFrame.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void test_video_set_bit_rate() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      var err_bit_rate_set = ErrBitRateSet.OK;
      var ret = toxav.video_set_bit_rate(0, 0, out err_bit_rate_set);
      assert(err_bit_rate_set == ErrBitRateSet.FRIEND_NOT_FOUND);
      assert(!ret);
    }

    private static void audio_callback(ToxCore.Tox tox,
                                       uint32 group_number,
                                       uint32 peer_number,
                                       [CCode(array_length = false)] int16[] pcm,
                                       uint samples,
                                       uint8 channels,
                                       uint32 sampling_rate) {}

    private static void test_add_av_groupchat() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.OK);
      var ret = ToxAV.ToxAV.add_av_groupchat(tox, audio_callback);
      assert(ret == 0);
      assert(ToxAV.ToxAV.groupchat_av_enabled(tox, 0) == true);
      assert(toxav != null);
    }

    private static void test_join_av_groupchat() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.OK);
      var data = new uint8[1];
      var ret = ToxAV.ToxAV.join_av_groupchat(tox, 0, data, audio_callback);
      assert(ret == -1);
      assert(toxav != null);
    }

    private static void test_group_send_audio() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      assert(err_new == ErrNew.OK);
      var data = new int16[1000];
      var ret = ToxAV.ToxAV.group_send_audio(tox, 0, data, 1, 1, 8000);
      assert(ret == -1);
      assert(toxav != null);
    }

    private static void test_groupchat_audio_toggle() {
      var tox = new ToxCore.Tox(null);
      var toxav = new ToxAV.ToxAV(tox);

      var conference_number = tox.conference_new();
      assert(ToxAV.ToxAV.groupchat_av_enabled(tox, conference_number) == false);

      var ret_enable = ToxAV.ToxAV.groupchat_enable_av(tox, conference_number, () => {});
      assert(ret_enable == -1);

      var ret_disable = ToxAV.ToxAV.groupchat_disable_av(tox, conference_number);
      assert(ret_disable == -1);
    }

    private static void test_callbacks() {
      var err_new_core = ToxCore.ErrNew.OK;
      var tox = new ToxCore.Tox(null, out err_new_core);

      var err_new = ErrNew.OK;
      var toxav = new ToxAV.ToxAV(tox, out err_new);
      toxav.callback_audio_bit_rate((av, friend_number, audio_bit_rate) => {});
      toxav.callback_audio_receive_frame((av, friend_number, pcm, sample_count, channels, sampling_rate) => {});
      toxav.callback_call((av, friend_number, audio_enabled, video_enabled) => {});
      toxav.callback_call_state((av, friend_number, state) => {});
      toxav.callback_video_bit_rate((av, friend_number, video_bit_rate) => {});
      toxav.callback_video_receive_frame((av, friend_number, width, height, y, u, v, ystride, ustride, vstride) => {});
    }

    private static void test_enums() {
      assert(ErrAnswer.OK != ErrAnswer.SYNC);
      assert(ErrAnswer.OK != ErrAnswer.CODEC_INITIALIZATION);
      assert(ErrAnswer.OK != ErrAnswer.FRIEND_NOT_FOUND);
      assert(ErrAnswer.OK != ErrAnswer.FRIEND_NOT_CALLING);
      assert(ErrAnswer.OK != ErrAnswer.INVALID_BIT_RATE);

      assert(ErrBitRateSet.OK != ErrBitRateSet.SYNC);
      assert(ErrBitRateSet.OK != ErrBitRateSet.INVALID_BIT_RATE);
      assert(ErrBitRateSet.OK != ErrBitRateSet.FRIEND_NOT_FOUND);
      assert(ErrBitRateSet.OK != ErrBitRateSet.FRIEND_NOT_IN_CALL);

      assert(ErrCall.OK != ErrCall.MALLOC);
      assert(ErrCall.OK != ErrCall.SYNC);
      assert(ErrCall.OK != ErrCall.FRIEND_NOT_FOUND);
      assert(ErrCall.OK != ErrCall.FRIEND_NOT_CONNECTED);
      assert(ErrCall.OK != ErrCall.FRIEND_ALREADY_IN_CALL);
      assert(ErrCall.OK != ErrCall.INVALID_BIT_RATE);

      assert(ErrCallControl.OK != ErrCallControl.SYNC);
      assert(ErrCallControl.OK != ErrCallControl.FRIEND_NOT_FOUND);
      assert(ErrCallControl.OK != ErrCallControl.FRIEND_NOT_IN_CALL);
      assert(ErrCallControl.OK != ErrCallControl.INVALID_TRANSITION);

      assert(ErrNew.OK != ErrNew.NULL);
      assert(ErrNew.OK != ErrNew.MALLOC);
      assert(ErrNew.OK != ErrNew.MULTIPLE);

      assert(ErrSendFrame.OK != ErrSendFrame.NULL);
      assert(ErrSendFrame.OK != ErrSendFrame.FRIEND_NOT_FOUND);
      assert(ErrSendFrame.OK != ErrSendFrame.FRIEND_NOT_IN_CALL);
      assert(ErrSendFrame.OK != ErrSendFrame.SYNC);
      assert(ErrSendFrame.OK != ErrSendFrame.INVALID);
      assert(ErrSendFrame.OK != ErrSendFrame.PAYLOAD_TYPE_DISABLED);
      assert(ErrSendFrame.OK != ErrSendFrame.RTP_FAILED);

      assert(FriendCallState.NONE != FriendCallState.ERROR);
      assert(FriendCallState.NONE != FriendCallState.FINISHED);
      assert(FriendCallState.NONE != FriendCallState.SENDING_A);
      assert(FriendCallState.NONE != FriendCallState.SENDING_V);
      assert(FriendCallState.NONE != FriendCallState.ACCEPTING_A);
      assert(FriendCallState.NONE != FriendCallState.ACCEPTING_V);
    }

    public static int main(string[] args) {
      Test.init(ref args);

      Test.add_func(PREFIX + "test_create", test_create);
      Test.add_func(PREFIX + "test_create_null", test_create_null);
      Test.add_func(PREFIX + "test_create_multiple", test_create_multiple);
      Test.add_func(PREFIX + "test_iterate", test_iterate);
      Test.add_func(PREFIX + "test_answer", test_answer);
      Test.add_func(PREFIX + "test_audio_send_frame", test_audio_send_frame);
      Test.add_func(PREFIX + "test_audio_set_bit_rate", test_audio_set_bit_rate);
      Test.add_func(PREFIX + "test_call", test_call);
      Test.add_func(PREFIX + "test_call_control", test_call_control);
      Test.add_func(PREFIX + "test_video_send_frame", test_video_send_frame);
      Test.add_func(PREFIX + "test_video_set_bit_rate", test_video_set_bit_rate);
      Test.add_func(PREFIX + "test_add_av_groupchat", test_add_av_groupchat);
      Test.add_func(PREFIX + "test_join_av_groupchat", test_join_av_groupchat);
      Test.add_func(PREFIX + "test_group_send_audio", test_group_send_audio);
      Test.add_func(PREFIX + "test_groupchat_audio_toggle", test_groupchat_audio_toggle);
      Test.add_func(PREFIX + "test_callbacks", test_callbacks);
      Test.add_func(PREFIX + "test_enums", test_enums);

      Test.run();
      return 0;
    }
  }
}
