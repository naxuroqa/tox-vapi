
using ToxEncryptSave;
namespace Tests {
  public class ToxEncryptSaveTest {
    private const string PREFIX = "/toxencryptsave/";

    private static void test_constants() {
      assert(PASS_SALT_LENGTH == pass_salt_length());
      assert(PASS_KEY_LENGTH == pass_key_length());
      assert(PASS_ENCRYPTION_EXTRA_LENGTH == pass_encryption_extra_length());
    }

    private static void test_passkey_derive() {
      var err_key_derivation = ErrKeyDerivation.OK;
      var pass_key = new PassKey.derive("🔑".data, ref err_key_derivation);
      assert(err_key_derivation == ErrKeyDerivation.OK);
      assert(pass_key != null);
    }

    private static void test_passkey_derive_with_salt() {
      var salt = new uint8[pass_salt_length()];
      var err_key_derivation = ErrKeyDerivation.OK;
      var pass_key = new PassKey.derive_with_salt("🔑".data, salt, ref err_key_derivation);
      assert(err_key_derivation == ErrKeyDerivation.OK);
      assert(pass_key != null);
    }

    private static void test_passkey_encrypt() {
      var err_key_derivation = ErrKeyDerivation.OK;
      var pass_key = new PassKey.derive("🔑".data, ref err_key_derivation);

      var err_encryption = ErrEncryption.OK;
      var encrypted = pass_key.encrypt("🔐".data, ref err_encryption);
      assert(err_encryption == ErrEncryption.OK);
      assert(encrypted != null);
    }

    private static void test_passkey_decrypt() {
      var err_key_derivation = ErrKeyDerivation.OK;
      var pass_key = new PassKey.derive("🔑".data, ref err_key_derivation);

      var err_encryption = ErrEncryption.OK;
      var encrypted = pass_key.encrypt("🔐".data, ref err_encryption);

      var err_decryption = ErrDecryption.OK;
      var plaintext = pass_key.decrypt(encrypted, ref err_decryption);
      assert(err_decryption == ErrDecryption.OK);
      assert(plaintext != null);
      assert((string) plaintext == "🔐");
    }

    private static void test_is_data_encrypted() {
      var data = new uint8[pass_encryption_extra_length()];
      assert(!is_data_encrypted(data));

      var err_encryption = ErrEncryption.OK;
      var ciphertext = pass_encrypt("🔐".data, "🔑".data, ref err_encryption);
      assert(is_data_encrypted(ciphertext));
    }

    private static void test_get_salt() {
      var data = new uint8[pass_encryption_extra_length()];
      var err_get_salt = ErrGetSalt.OK;
      var salt = get_salt(data, ref err_get_salt);
      assert(err_get_salt == ErrGetSalt.BAD_FORMAT);
      assert(salt == null);

      var err_encryption = ErrEncryption.OK;
      var ciphertext = pass_encrypt("🔐".data, "🔑".data, ref err_encryption);
      salt = get_salt(ciphertext, ref err_get_salt);
      assert(err_get_salt == ErrGetSalt.OK);
      assert(salt != null);
      assert(salt.length == pass_salt_length());
    }

    private static void test_pass_encrypt() {
      var err_encryption = ErrEncryption.OK;
      var ciphertext = pass_encrypt("🔐".data, "🔑".data, ref err_encryption);
      assert(err_encryption == ErrEncryption.OK);
      assert(ciphertext != null);
    }

    private static void test_pass_decrypt() {
      var err_encryption = ErrEncryption.OK;
      var ciphertext = pass_encrypt("🔐".data, "🔑".data, ref err_encryption);

      var err_decryption = ErrDecryption.OK;
      var plaintext = pass_decrypt(ciphertext, "🔑".data, ref err_decryption);
      assert(err_decryption == ErrDecryption.OK);
      assert(plaintext != null);
      assert((string) plaintext == "🔐");
    }

    private static void test_enums() {
      assert(ErrDecryption.OK != ErrDecryption.NULL);
      assert(ErrDecryption.OK != ErrDecryption.INVALID_LENGTH);
      assert(ErrDecryption.OK != ErrDecryption.BAD_FORMAT);
      assert(ErrDecryption.OK != ErrDecryption.KEY_DERIVATION_FAILED);
      assert(ErrDecryption.OK != ErrDecryption.FAILED);

      assert(ErrEncryption.OK != ErrEncryption.NULL);
      assert(ErrEncryption.OK != ErrEncryption.KEY_DERIVATION_FAILED);
      assert(ErrEncryption.OK != ErrEncryption.FAILED);

      assert(ErrGetSalt.OK != ErrGetSalt.NULL);
      assert(ErrGetSalt.OK != ErrGetSalt.BAD_FORMAT);

      assert(ErrKeyDerivation.OK != ErrKeyDerivation.NULL);
      assert(ErrKeyDerivation.OK != ErrKeyDerivation.FAILED);
    }

    public static int main(string[] args) {
      Test.init(ref args);

      Test.add_func(PREFIX + "test_constants", test_constants);
      Test.add_func(PREFIX + "test_passkey_derive", test_passkey_derive);
      Test.add_func(PREFIX + "test_passkey_derive_with_salt", test_passkey_derive_with_salt);
      Test.add_func(PREFIX + "test_passkey_encrypt", test_passkey_encrypt);
      Test.add_func(PREFIX + "test_passkey_decrypt", test_passkey_decrypt);
      Test.add_func(PREFIX + "test_is_data_encrypted", test_is_data_encrypted);
      Test.add_func(PREFIX + "test_get_salt", test_get_salt);
      Test.add_func(PREFIX + "test_pass_encrypt", test_pass_encrypt);
      Test.add_func(PREFIX + "test_pass_decrypt", test_pass_decrypt);
      Test.add_func(PREFIX + "test_enums", test_enums);

      Test.run();
      return 0;
    }
  }
}
