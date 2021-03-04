# llhttp

Ruby bindings for [llhttp](https://github.com/nodejs/llhttp).

This is a monorepo that includes projects for MRI and FFI. Generally speaking, you should use MRI unless you can't. Both
projects are implemented with the exact same features, but the MRI implementation is more performant.

Both projects share a test suite, helping ensure parity.
