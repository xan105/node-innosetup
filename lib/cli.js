#!/usr/bin/env node

/*
Copyright (c) Anthony Beaumont
This source code is licensed under the MIT License
found in the LICENSE file in the root directory of this source tree.
*/

import { env, exit } from "node:process";
import { join } from "node:path";
import { compile } from "./index.js";
import { exposePackageVar } from "./util/npm_package.js";

try {
  await compile(
    env?.["npm_package_config_setup_script"] || join(import.meta.dirname, "../default.iss"), {
    dir:      env?.["npm_package_config_setup_dir"],
    filename: env?.["npm_package_config_setup_filename"],
    define:   await exposePackageVar(),
    quiet:    env?.["npm_package_config_setup_quiet"] === "true",
    stdout:   console.log,
    stderr:   console.error
  });
  exit(0);
}catch(err){
  console.error(err);
  exit(1);
}