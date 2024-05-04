import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final ctrlText = TextEditingController();
final ctrlKey = TextEditingController();

var cipherText = 'empty text';
var plainText = 'empty text';
encrypt.Encrypted? encrypted;

//  final key = encrypt.Key.fromSecureRandom(32);
var key = encrypt.Key.fromUtf8(ctrlKey.text);
final encrypter = encrypt.Encrypter(encrypt.AES(key));
final iv = encrypt.IV.fromSecureRandom(16);

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void encryptText(String text) {
    final plainText = text;
    encrypted = encrypter.encrypt(plainText, iv: iv);

    cipherText = encrypted!.base64;
    setState(() {});
    // debugPrint(encrypted.base64);
    debugPrint(cipherText);
  }

  void decryptText() {
    final decrypted = encrypter.decrypt(encrypted!, iv: iv);
    plainText = decrypted;
    setState(() {});
    debugPrint(decrypted);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cryptography Modern'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: ctrlText,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                    hintText: 'Masukkan text untuk dienkripsi',
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ctrlKey,
                  maxLength: 32,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Secret Key',
                    hintText: 'Masukkan secret key',
                  ),
                  onChanged: (value) {
                    key = encrypt.Key.fromUtf8(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                Text(encrypt.Key.fromUtf8(ctrlKey.text).base64),
                const SizedBox(height: 20),
                Text(iv.base64),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: (ctrlText.text.isNotEmpty) && (ctrlKey.text.length == 32)
                      ? () {
                          encryptText(ctrlText.text);
                        }
                      : null,
                  child: const Text('Encrypt'),
                ),
                const SizedBox(height: 20),
                Text(
                  'cipher text: $cipherText',
                  textScaler: const TextScaler.linear(2),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    decryptText();
                  },
                  child: const Text(
                    "Decrypt",
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'plain text: $plainText',
                  textScaler: const TextScaler.linear(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
