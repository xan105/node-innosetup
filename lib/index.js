/*
Copyright (c) Anthony Beaumont
This source code is licensed under the MIT License
found in the LICENSE file in the root directory of this source tree.
*/

import { platform, cwd } from "node:process";
import { join, resolve } from "node:path";
import { spawn } from "node:child_process";
import { 
  asString, 
  asBoolean, 
  asObject,
  asFunction,
  shouldString, 
  shouldObject 
} from "@xan105/types";

export function compile(script, option = {}){
  return new Promise((success, reject) => {

    if (platform !== "win32") return reject(new Error("The Innosetup compiler runs only on Windows!"));
    shouldString(script);
    shouldObject(option);
    
    const options = {
      dir:      asString(option.dir)        || join(cwd(), "build"),
      filename: asString(option.filename)   || "mysetup",
      define:   asObject(option.define)     ?? Object.create(null),
      quiet:    asBoolean(option.quiet)     ?? false,
      stdout:   asFunction(option.stdout)   ?? function(){},
      stderr:   asFunction(option.stderr)   ?? function(){}
    };

    const args = [
      `/O"${resolve(options.dir)}"`,
      `/F"${options.filename.replace(".exe", "")}"`
    ];
    if (options.quiet) args.push(`/Q`);
    for (const [ name, value ] of Object.entries(options.define)) {
      if(value) args.push(`/D${name}="${value}"`);
    }
    args.push(`"${resolve(script)}"`);

    const bin = join(import.meta.dirname, "../vendor/innosetup/iscc.exe");
    const iscc = spawn(`"${bin}" ${args.join(" ")}`, {
      cwd: cwd(), 
      shell: true
    });

    iscc.stdout.on("data", (data) => {
      options.stdout(`${data}`);
    });

    const stderr = [];
    iscc.stderr.on("data", (data) => {
      stderr.push(data);
      options.stderr(`${data}`);
    });

    iscc.on("close", (code) => {
      switch(code){
        case 0: {
          return success();
        }
        case 1: {
          const error = new Error("Command line parameters were invalid or an internal error occurred");
          return reject(error);
        }
        case 2: {
          const error = new Error("Compilation failed", { cause: stderr.join("\n") });
          return reject(error);
        }
        default: {
          const error = new Error("Unknown error");
          return reject(error);
        }
      }
    });
  });
}