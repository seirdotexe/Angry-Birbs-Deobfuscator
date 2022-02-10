'use strict';

import { writeFile, readFile, readdir, mkdir } from 'fs/promises';
import { Birb } from './birb.mjs';

/**
 * @async
 * @function
 * @description Retrieves information of an obfuscated script
 * @param {string} scriptFullName - The full script name
 * @returns {{scriptName:string, className:string, scriptContent:string, obfuscatedNames:string[]}} Obfuscated script info
 */
async function getObfuscatedScriptInfo(scriptFullName) {
  const matcher = new RegExp(`§(.*?)§`, 'gm');

  const [scriptName] = scriptFullName.split('.as');
  //! If you get an error here, please make an issue on the Github and mention which ENCODED script name you're decoding
  const className = scriptName.includes('%22') ? decodeURI(scriptName) : scriptName; //? Windows can encode certain characters
  const scriptContent = await readFile(`scripts/${scriptFullName}`, 'utf8');
  const obfuscatedNames = scriptContent.match(matcher); //? Gather everything between '§', which is the JPEXS delimiter

  return { scriptName, className, scriptContent, obfuscatedNames };
}

/**
 * @function
 * @description Retrieves information of an obfuscated script, and eventually, the deobfuscated script
 * @param {{scriptName:string, className:string, scriptContent:string, obfuscatedNames:string[]}} obfuscatedScriptInfo - Obfuscated script info
 * @returns {{className:string, scriptName:string, scriptFullName:string, scriptContent:string}} Deobfuscated script info
 */
function getDeobfuscatedScriptInfo(obfuscatedScriptInfo) {
  //? Certain characters need escaping when using regex
  const payload = obfuscatedScriptInfo.obfuscatedNames.join('|')
    .replaceAll('$', '\\$')
    .replaceAll('+', '\\+').replaceAll('^', '\\^')
    .replaceAll('?', '\\?').replaceAll('[', '\\[');
  const matcher = new RegExp(payload, 'gi');

  const className = obfuscatedScriptInfo.className.startsWith('§')
    ? Birb.lookup(obfuscatedScriptInfo.className)
    : obfuscatedScriptInfo.className;
  const scriptName = className;
  const scriptFullName = `${scriptName}.as`;
  const scriptContent = obfuscatedScriptInfo.scriptContent.replace(matcher, (matched) => Birb.lookup(matched));

  return { className, scriptName, scriptFullName, scriptContent };
}

/**
 * @async
 * @function
 * @description Deobfuscates all scripts inside said folder and saves it
 * @param {string} [dir='scripts'] - The directory to scan for obfuscated scripts
 */
async function deobfuscateScripts(dir = 'scripts') {
  const scripts = await readdir(dir);

  for (let i = 0; i < scripts.length; i++) {
    const scriptOrDir = scripts[i];

    if (scriptOrDir.startsWith('§') && scriptOrDir.endsWith('§')) {
      // Todo: Support folders
    } else if (scriptOrDir.endsWith('.as')) {
      const obfuscatedScriptInfo = await getObfuscatedScriptInfo(scriptOrDir);
      const deobfuscatedScriptInfo = getDeobfuscatedScriptInfo(obfuscatedScriptInfo);

      await writeFile(`deobfuscated/${deobfuscatedScriptInfo.scriptFullName}`, deobfuscatedScriptInfo.scriptContent);
    } else {
      console.log(`Skipping ${scriptOrDir} as it's not a valid obfuscated script/dir.`);
    }
  }
}

//? Example
async function run() {
  await Birb.init();
  await deobfuscateScripts();
}

run();
