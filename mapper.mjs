'use strict';

import { parseStringPromise } from 'xml2js';
import { readFile, writeFile } from 'fs/promises';

//? Support CLI interaction
if (process.argv[2]) {
  getTables(process.argv[2]);
}

/**
 * @function
 * @async
 * @description Parses and retrieves tables from the provided SecureSWF XML
 * @param {string} map - The SecureSWF XML map to parse
 */
async function getTables(map) {
  const xml = await readFile(map, 'utf8');
  const json = await parseStringPromise(xml);
  const tables = { full: {}, oldToId: {}, newToId: {} };

  for (const id in json.MapTable.ID) {
    const { Old, New } = json.MapTable.ID[id]['$'];
    const cleanedNew = Buffer.from(New.split(',')).toString();

    //? JPEXS uses the § delimiter
    tables.full[id] = { Old, New: `§${cleanedNew}§` }
    tables.oldToId[Old] = id;
    tables.newToId[tables.full[id].New] = id;
  }

  //? Store all mapped tables
  await writeFile('data/decrypted_secure_map(table_full).json', JSON.stringify(tables.full, null, 4));
  await writeFile('data/decrypted_secure_map(table_old_to_id).json', JSON.stringify(tables.oldToId, null, 4));
  await writeFile('data/decrypted_secure_map(table_new_to_id).json', JSON.stringify(tables.newToId, null, 4));
}

/**
 * @exports
 * @function
 * @async
 * @description Looks through the parsed tables
 * @param {string} value - The value to look up
 * @returns {{New:string, Old:string}} The looked up object
 */
async function lookupTable(value) {
  const full = JSON.parse(await readFile('decrypted_secure_map(table_full).json'));
  const table = (value[0] === '§' && value[value.length - 1] === '§') //? Obfuscated or not
    ? JSON.parse(await readFile('decrypted_secure_map(table_new_to_id).json'))
    : JSON.parse(await readFile('decrypted_secure_map(table_old_to_id).json'));
  const id = table[value];

  if (id) {
    return full[id];
  }
}
