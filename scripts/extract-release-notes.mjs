import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

function escapeRegex(text) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

const repoRoot = process.cwd();
const changelogPath = join(repoRoot, 'CHANGELOG.md');
const targetVersion = process.argv[2];

if (!targetVersion) {
  console.error('Usage: node scripts/extract-release-notes.mjs <version>');
  process.exit(1);
}

const normalizedVersion = targetVersion.replace(/^v/i, '');

if (!existsSync(changelogPath)) {
  process.stdout.write(`## Release v${normalizedVersion}\n\nNo CHANGELOG.md found.\n`);
  process.exit(0);
}

const changelog = readFileSync(changelogPath, 'utf8');
const sectionRegex = new RegExp(
  `^## \\[v?${escapeRegex(normalizedVersion)}\\][^\\n]*\\n([\\s\\S]*?)(?=^## \\[|(?![\\s\\S]))`,
  'm',
);
const match = changelog.match(sectionRegex);

if (!match) {
  process.stdout.write(
    `## Release v${normalizedVersion}\n\nNo CHANGELOG section for this version. See commit history for details.\n`,
  );
  process.exit(0);
}

process.stdout.write(`${match[0].trim()}\n`);
