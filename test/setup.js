import test from "node:test";
import assert from "node:assert/strict";
import { platform } from "node:process";
import { join } from "node:path";
import { rm, mkdir, writeFile } from "node:fs/promises";
import { compile } from "../lib/index.js";
import { exposePackageVar } from "../lib/util/npm_package.js";

test("Create default setup", {
  skip: platform === "win32" ? false : "This test runs on Windows"
}, async () => {
  const path = join(import.meta.dirname, "../build");
  await rm(path, { recursive: true, force: true });
  await mkdir(join(path, "app"), { recursive: true });
  await writeFile(join(path, "app", "innosetup.exe"), "", "utf8"); //dummy
  await assert.doesNotReject(async()=>{
    return compile(join(import.meta.dirname, "../default.iss"), {
      define: await exposePackageVar()
    });
  });
});