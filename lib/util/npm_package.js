/*
Copyright (c) Anthony Beaumont
This source code is licensed under the MIT License
found in the LICENSE file in the root directory of this source tree.
*/

import { env, arch, cwd } from "node:process";
import { basename } from "node:path";
import { readFile } from "node:fs/promises";

export async function exposePackageVar(){
  const result = Object.create(null);
  
  const npm_package =  env?.["npm_package_json"] || join(cwd(), "package.json");
  const file = await readFile(npm_package, "utf8");
  const json = JSON.parse(file);
  
  const keys = [
    "name",
    "version",
    "description",
    "homepage",
    "license",
    "author",
    "funding"
  ];
  for (const key of keys){
    const value = json[key];
    if (!value) continue;

    if (key === "name"){
      result["npm_package_" + key] = basename(value);
    } else if (key === "author"){
      result["npm_package_" + key] = value.name || value;
    } else if (key === "funding") {
      const val = Array.isArray(value) ? value[0] : value;
      result["npm_package_" + key] = val.url || val;
    } else {
      result["npm_package_" + key] = value;
    }
  }
  result["npm_config_arch"] = env?.["npm_config_arch"] || arch;
  return result;
}