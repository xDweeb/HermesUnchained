import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { test } from "node:test";

const launcherUrl = new URL("../../scripts/ops/hermes-unchained", import.meta.url);

test("HermesUnchained shares its configured client key with OmniRoute", async () => {
  const launcher = await readFile(launcherUrl, "utf8");

  assert.match(launcher, /--env "OMNIROUTE_API_KEY=\$DUMMY_KEY"/);
  assert.match(launcher, /export OPENAI_API_KEY="\$DUMMY_KEY"/);
  assert.match(launcher, /export ANTHROPIC_API_KEY="\$DUMMY_KEY"/);
  assert.doesNotMatch(launcher, /export (?:OPENAI|ANTHROPIC)_API_KEY="sk-dummy"/);
});
