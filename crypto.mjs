'use strict';

/**
 * @function
 * @description Encrypts a string
 * @param {string} value - The string to encrypt
 * @param {number} [seed=7937] - The seed
 * @returns {string} The encrypted string
 */
function encryptString(value, seed = 7937) {
  let res = '';

  for (let i = 0; i < value.length; i++) {
    const char = ((value.charCodeAt(i)) + seed * (i + 2)) % 65536;

    res += res.length > 0 ? `-${char}` : char;
  }

  return res;
}

/**
 * @function
 * @description Decrypts a string
 * @param {string} value - The string to decrypt
 * @param {number} [seed=7937] - The seed
 * @returns {string} The decrypted string
 */
function decryptString(value, seed = 7937) {
  let res = '';

  for (let i = 0, chars = value.split('-'); i < chars.length; i++) {
    res += String.fromCharCode((65536 + parseInt(chars[i]) - seed * (i + 2) % 65536) % 65536);
  }

  return res;
}
