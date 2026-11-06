// Dependency-free packaging checks. Run from any working directory.
import { readdir, readFile, realpath } from 'node:fs/promises';
import { dirname, extname, isAbsolute, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = await realpath(fileURLToPath(new URL('..', import.meta.url)));
const failures = [];
const excluded = new Set(['node_modules', 'dist', 'coverage', '.git', '.verification', 'runs']);
function inside(path) {
  const rel = relative(root, path);
  return !isAbsolute(rel) && rel !== '..' && !rel.startsWith('../') && !rel.startsWith('..\\');
}
async function walk(directory) {
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    if (excluded.has(entry.name)) continue;
    const path = resolve(directory, entry.name);
    if (entry.isSymbolicLink()) {
      failures.push(`${relative(root, path)}: symlinks are not portable packaging`);
    } else if (entry.isDirectory()) {
      await walk(path);
    } else if (extname(path) === '.md') {
      const markdown = await readFile(path, 'utf8');
      for (const match of markdown.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
        const link = match[1];
        if (/^https?:\/\//.test(link) || link.startsWith('#')) continue;
        const target = resolve(dirname(path), link.split('#')[0]);
        try {
          if (!inside(target) || !inside(await realpath(target))) throw new Error('outside package');
        } catch {
          failures.push(`${relative(root, path)}: missing or external local target ${link}`);
        }
      }
    }
  }
}
await walk(root);
const entry = await readFile(resolve(root, 'SKILL.md'), 'utf8');
const normalized = entry.replace(/\r\n/g, '\n');
const words = entry.trim().split(/\s+/).length;
console.log(`SKILL.md: ${words} whitespace-delimited words; ${Buffer.byteLength(entry)} UTF-8 bytes (not token counts).`);
if (!normalized.startsWith('---\nname: lean-ui\ndescription: ') || !normalized.includes('\n---\n')) {
  failures.push('SKILL.md: missing expected skill frontmatter');
}
if (words > 600) failures.push('SKILL.md exceeds 600-word entrypoint budget');
if (failures.length) {
  console.error(failures.join('\n'));
  process.exitCode = 1;
} else {
  console.log('Local Markdown links stay inside the package; entrypoint budget passed.');
}
