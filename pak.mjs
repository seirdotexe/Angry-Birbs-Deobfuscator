'use strict';

import { RND } from './RND.mjs';
import { readFile, writeFile } from 'fs/promises';
import { promisify } from 'util';
import zlib from 'zlib';

//? Support CLI interaction
if (process.argv[2] && process.argv[3]) {
  await decryptPackage(process.argv[2], parseInt(process.argv[3]));
}

/**
 * @async
 * @function
 * @description Decrypts a .pak file
 * @param {string} file - The path of the .pak file
 * @param {number} seed - The seed of the .pak file
 * @throws {TypeError} The seed must be valid
 */
async function decryptPackage(file, seed) {
  if (seed !== 185 && seed !== 4125) {
    throw new Error('Invalid or unknown seed. Try 4125 or 185.');
  }

  const buffer = await readFile(file);

  RND.setSeed(seed);

  let idx = 0;

  for (idx = Math.min(buffer.length, 65536) - 1; idx >= 0; idx -= 2) {
    buffer[idx] -= RND.random();
  }

  for (idx = buffer.length - 1; idx >= 0; idx -= RND.random()) {
    buffer[idx] -= RND.random();
  }

  for (idx = buffer.length - 1; idx >= Math.max(buffer.length, 65536) - 65536; idx -= 2) {
    buffer[idx] -= RND.random();
  }

  const inflateRaw = promisify(zlib.inflateRaw);
  const decrypted = await inflateRaw(buffer);
  const name = file.includes('/')
    ? file.split('/').pop().split('.pak')[0]
    : file.split('.pak')[0];
  const [path] = file.split(name);

  await writeFile(`${path}${name}.zip`, decrypted);
}
