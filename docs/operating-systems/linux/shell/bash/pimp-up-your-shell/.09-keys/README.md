# SSH-Keys

You don't use passphrases for your keys?

With SSH keys, if someone gains access to your computer, they also gain access
to every system that uses that key. To add an extra layer of security, you can
add a passphrase to your SSH key. You can use ssh-agent to securely save your
passphrase so you don't have to reenter it.

---

## Use `ssh-agent` to Remember Your Passphrases

I don't use macOS keychain, I use a very popular one called [`keychain`](https://www.funtoo.org/Keychain).

```bash
brew info keychain
brew install keychain
```

Append to your `~/.bash_profile`

```bash
if hash keychain 2>/dev/null; then
  eval `keychain --eval --agents ssh --inherit any --quiet id_rsa`
fi
```

Read about '`--inherit any`' [here](https://www.funtoo.org/Keychain).

---

## `keychain`

Using the alternative [`keychain`](https://www.funtoo.org/Keychain), every
time you restart your computer, and open a new terminal, you will be asked
once for the passphrase of `id_rsa`.

---
