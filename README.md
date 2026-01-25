About
=====

Compile innosetup script `.iss` to create Windows installer/setup.

This is a wrapper for Innosetup's console-mode compiler (`ISCC.exe`).

📖 See [Innosetup documentation](https://jrsoftware.org/ishelp/) for more details.

📦 Scoped @xan105 packages are for my own personal use but feel free to use them.

Usage / Example
===============

This package provides both a CLI bin and a module export.

## CLI

The CLI usage is intended to be used as a npm-run command:

```json
{
  "scripts": {
    "build": "innosetup"
  },
  "config": {
    "setup": {
      "script": "mysetup.iss",
      "filename": "mysetup"
    }
  }
}
```

```console
npm run build
```

The following variables from your `package.json` are exposed to the `.iss` script through Inno Setup Preprocessor's define:

  - name        ->  #npm_package_name
  - version     ->  #npm_package_version
  - description ->  #npm_package_description
  - homepage    ->  #npm_package_homepage
  - license     ->  #npm_package_license
  - author      ->  #npm_package_author
  - funding     ->  #npm_package_funding
  - arch        ->  #npm_config_arch
  
A default `.iss` script (`default.iss`) is shipped with this package and is used by default when you do not specify your own `.iss` script.
You can also use it as a starting point to create your own `.iss` script!

💡 The default `.iss` script (`default.iss`) expects your app files to be located inside `build/app/` and your main executable to be named as _npm_package_name_ + `.exe`.

The CLI bin can be configured using `package.json`'s `config` field:

- `setup.script` (default.iss): Path to the `.iss` script.
- `setup.dir` (build): Output file(s) to specified dir path.
- `setup.filename` (mysetup): Specifies an output filename.
- `setup.quiet` (false): Quiet compile (print error messages only).

## Module

The module export exposes the JS wrapper used by the CLI bin.

```js
import { compile } from "@xan105/innosetup";

await compile("mysetup.iss", {
    dir: "./build",
    filename: "mysetup",
    quiet: false,
    define: {
      author: "xan105", 
      arch: "x64"
    }
  });
```

Install
=======

As a dev dependency:

```
npm install -D @xan105/innosetup
```

As a dependency:

```
npm install @xan105/innosetup
```

⚠️ This package doesn't have any installation restrictions in its package.json file to facilitate multi-platform development; however, it is at the moment only designed to work on Windows.

API
===

⚠️ This module is only available as an ECMAScript module (ESM).

## Named export

### `compile(script: string, option?: object) Promise<void>`

Compile given innosetup script using Innosetup's console-mode compiler (`ISCC.exe`).

⚠️ The Innosetup compiler runs only on Windows!

**Options:**

- `dir?: string` ("./build")

  Output file(s) to specified dir path.

- `filename?: string` (mysetup)

  Specifies an output filename.

- `define?: {key:value, ...}` (none)

  Expose variable(s) to the `.iss` script through Inno Setup Preprocessor's define.
  
  eg: `{foo:bar} => #define public foo "bar"`
  
  ```ini
  [Setup]
  AppName={#foo} ;"bar"
  ```

- `quiet?: boolean` (false)

  Quiet compile (print error messages only).

- `stdout?: function` (none)

  Callback to receive `ISCC.exe` stdout as string (data chunk).

- `stderr?: function` (none)

  Callback to receive `ISCC.exe` stderr as string (data chunk).
  
**Return**

✔️ The promise resolves when the compilation was successful.

❌ The promise rejects when the compilation failed or something unexpected went wrong.