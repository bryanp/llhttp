# llhttp

Ruby bindings for [llhttp](https://github.com/nodejs/llhttp).

This is a monorepo that includes projects for MRI and FFI. Generally speaking, you should prefer the MRI version and
fallback to the FFI version for better compatibility. There is parity between the two implementations, but the MRI
implementation is more performant.

* [MRI](https://github.com/metabahn/llhttp/tree/main/mri)
* [FFI](https://github.com/metabahn/llhttp/tree/main/ffi)
